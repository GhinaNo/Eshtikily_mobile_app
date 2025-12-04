// import 'package:flutter/material.dart';
//
// class CustomAnimatedDialog extends StatefulWidget {
//   final Widget child;
//
//   const CustomAnimatedDialog({super.key, required this.child});
//
//   @override
//   State<CustomAnimatedDialog> createState() => _CustomAnimatedDialogState();
// }
//
// class _CustomAnimatedDialogState extends State<CustomAnimatedDialog>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 220),
//     );
//
//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutBack,
//     );
//
//     _controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: FadeTransition(
//         opacity: _controller,
//         child: widget.child,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
