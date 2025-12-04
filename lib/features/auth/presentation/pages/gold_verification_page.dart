import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/network/http_client.dart';
import '../../../../../../../widgets/gold_btn.dart';
import '../../../../../../../widgets/gold_logo.dart';
import '../../../../../../../widgets/gold_text_field.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/auth_storage.dart';
import '../../../../core/utils/toast_services.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/resendCode/resend_code_request.dart';
import '../../data/models/verifyCode/verify_code_request.dart';
import '../../data/models/verifyCode/verify_code_response.dart';
import '../blocs/verify_code_bloc/verify_code_bloc.dart';
import '../blocs/verify_code_bloc/verify_code_event.dart';
import '../blocs/verify_code_bloc/verify_code_state.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _remainingTime = 300;
  bool _canResend = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  VerificationBloc _createVerificationBloc() {
    return VerificationBloc(
      remoteDataSource: AuthRemoteDataSource(
        httpClient: HttpClient(),
      ),
    );
  }

  void _handleVerification(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final request = VerificationRequest(
        email: widget.email,
        code: _codeController.text.trim(),
      );
      context.read<VerificationBloc>().add(VerificationSubmitted(request: request));
    }
  }

  Future<void> _resendCode() async {
    print('🎯 زر الإعادة تم الضغط عليه');

    if (!_canResend || _isResending) {
      print('❌ لا يمكن الإرسال الآن. canResend: $_canResend, isResending: $_isResending');
      return;
    }

    print('🔄 بدء إعادة الإرسال...');
    setState(() => _isResending = true);

    try {
      print('📱 إنشاء HttpClient و DataSource');
      final dataSource = AuthRemoteDataSource(httpClient: HttpClient());
      final request = ResendCodeRequest(email: widget.email);

      print('📤 إرسال الطلب إلى: ${widget.email}');
      await dataSource.resendVerificationCode(request);

      print('✅ تم الإرسال بنجاح');
      _resetTimer();
      ToastService.showSuccess(context, "تم إعادة إرسال رمز التحقق");

    } catch (e) {
      print('❌ خطأ: $e');
      print('❌ نوع الخطأ: ${e.runtimeType}');
      print('❌ StackTrace: ${e.toString()}');

      ToastService.showError(context, "فشل في إعادة الإرسال: ${e.toString()}");
    } finally {
      print('🏁 انتهت العملية');
      setState(() => _isResending = false);
    }
  }
  void _resetTimer() {
    setState(() {
      _remainingTime = 300;
      _canResend = false;
    });
    _timer?.cancel();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        setState(() => _canResend = true);
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createVerificationBloc(),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<VerificationBloc, VerificationState>(
            listener: (context, state) {
              if (state is VerificationSuccess) {
                _saveUserDataAndNavigate(state.response);
                ToastService.showSuccess(context, "تم التحقق من الحساب بنجاح!");
              } else if (state is VerificationFailure) {
                ToastService.showError(context, state.error);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const EagleLogo(size: 120),
                    const SizedBox(height: 16),

                    const Text(
                      'التحقق من الحساب',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildVerificationMessage(),
                    const SizedBox(height: 24),

                    GoldTextField(
                      controller: _codeController,
                      hint: 'أدخل رمز التحقق',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رمز التحقق';
                        }
                        return null;
                      },
                      keyboard: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      autofocus: true,
                      prefixIcon: const Icon(Icons.verified_user_outlined, color: Color(0xFFBFA46F)),
                    ),
                    const SizedBox(height: 30),

                    BlocBuilder<VerificationBloc, VerificationState>(
                      builder: (context, state) {
                        return GoldButton(
                          label: state is VerificationLoading ? 'جاري التحقق...' : 'تحقق من الحساب',
                          onTap: state is VerificationLoading ? null : () => _handleVerification(context),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildResendSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationMessage() {
    return Column(
      children: [
        const Text(
          'أدخل رمز التحقق المرسل إلى بريدك الإلكتروني',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          widget.email,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFBFA46F),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        const Text(
          'لم تستلم الرمز؟',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),

        _canResend
            ? GestureDetector(
          onTap: _resendCode,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFBFA46F).withOpacity(_isResending ? 0.05 : 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFBFA46F).withOpacity(_isResending ? 0.5 : 1),
              ),
            ),
            child: _isResending
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFFBFA46F),
                strokeWidth: 2,
              ),
            )
                : const Text(
              'إعادة إرسال الرمز',
              style: TextStyle(
                color: Color(0xFFBFA46F),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'يمكنك إعادة الإرسال خلال ',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              _formatTime(_remainingTime),
              style: const TextStyle(
                color: Color(0xFFBFA46F),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _saveUserDataAndNavigate(VerificationResponse response) async {
    try {
      await AuthStorage.saveAuthToken(response.user.token);
      await AuthStorage.saveUserData({
        'id': response.user.id,
        'name': response.user.name,
        'email': response.user.email,
        'phone_number': response.user.phone_number,
      });
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      ToastService.showError(context, 'فشل في حفظ الجلسة');
    }
  }
}