//
// import 'package:eshhtikiyl_app/features/profile/presentation/pages/show_profile_page.dart';
// import 'package:flutter/material.dart';
// import '../core/services/logout_srevice.dart';
// import '../pages/complaint_list.dart';
// import '../pages/create_complaint.dart';
//
// class HomePage extends StatefulWidget {
// const HomePage({super.key});
//
// @override
// State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
// int _currentIndex = 0;
// final PageStorageBucket _pageStorageBucket = PageStorageBucket();
//
// final List<BottomNavItem> _navItems = const [
// BottomNavItem(
// icon: Icons.list_alt,
// activeIcon: Icons.list_alt_rounded,
// label: "الشكاوى",
// ),
// BottomNavItem(
// icon: Icons.add_circle_outline,
// activeIcon: Icons.add_circle,
// label: "إضافة",
// ),
// BottomNavItem(
// icon: Icons.notifications_outlined,
// activeIcon: Icons.notifications,
// label: "إشعارات",
// ),
// BottomNavItem(
// icon: Icons.more_horiz,
// activeIcon: Icons.more_horiz,
// label: "المزيد",
// ),
// ];
//
// List<Widget> get _pages => [
// _buildPage(0, const ListComplaintsPage()),
// _buildPage(1, const CreateComplaintPage()),
// _buildPage(2, _buildNotificationsPage()),
// _buildPage(3, const MoreTab()),
// ];
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// body: IndexedStack(
// index: _currentIndex,
// children: _pages,
// ),
// bottomNavigationBar: _buildCustomBottomNav(),
// );
// }
//
// Widget _buildPage(int index, Widget child) {
// return PageStorage(
// bucket: _pageStorageBucket,
// child: _currentIndex == index ? child : const SizedBox(),
// );
// }
//
// Widget _buildNotificationsPage() {
// return const Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(
// Icons.notifications_active,
// size: 80,
// color: Colors.white54,
// ),
// SizedBox(height: 16),
// Text(
// "قريباً...",
// style: TextStyle(
// color: Colors.white,
// fontSize: 24,
// fontWeight: FontWeight.bold,
// ),
// ),
// SizedBox(height: 8),
// Text(
// "سيتم تفعيل نظام الإشعارات قريباً",
// style: TextStyle(
// color: Colors.white70,
// fontSize: 16,
// ),
// textAlign: TextAlign.center,
// ),
// ],
// ),
// );
// }
//
// Widget _buildCustomBottomNav() {
// return Container(
// decoration: BoxDecoration(
// color: const Color(0xFFF1CA7B),
// borderRadius: const BorderRadius.all(Radius.circular(70)
// ),
// // boxShadow: [
// // BoxShadow(
// // color: Colors.black.withOpacity(0.3),
// // blurRadius: 15,
// // spreadRadius: 2,
// // offset: const Offset(0, -2),
// // ),
// // ],
// ),
// padding: const EdgeInsets.symmetric(vertical: 3),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: List.generate(
// _navItems.length,
// (index) => _buildNavItem(index),
// ),
// ),
// );
// }
//
// Widget _buildNavItem(int index) {
// final item = _navItems[index];
// final isActive = _currentIndex == index;
//
// return GestureDetector(
// onTap: () => _onNavItemTapped(index),
// child: Container(
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Icon(
// isActive ? item.activeIcon : item.icon,
// color: isActive ? Color(0xFF0A3C3A) : Colors.white70,
// size: 24,
// ),
// const SizedBox(height: 4),
// Text(
// item.label,
// style: TextStyle(
// color: isActive ? Color(0xFF0A3C3A): Colors.white70,
// fontSize: 12,
// fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
// ),
// ),
// ],
// ),
// ),
// );
// }
//
// void _onNavItemTapped(int index) {
// setState(() {
// _currentIndex = index;
// });
// }
// }
//
// class BottomNavItem {
// final IconData icon;
// final IconData activeIcon;
// final String label;
//
// const BottomNavItem({
// required this.icon,
// required this.activeIcon,
// required this.label,
// });
// }
//
// class MoreTab extends StatelessWidget {
// const MoreTab({super.key});
//
// static final List<MoreMenuItem> _menuItems = [
// MoreMenuItem(
// icon: Icons.person_outline,
// title: "الملف الشخصي",
// iconColor: Colors.blue[200],
// onTap: (context) {
// Navigator.push(
// context,
// MaterialPageRoute(builder: (_) => const ProfilePage()),
// );
// },
// ),
// MoreMenuItem(
// icon: Icons.settings_outlined,
// title: "الإعدادات",
// iconColor: Colors.amber[200],
// onTap: (context) {
// // TODO: إضافة صفحة الإعدادات
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(
// content: Text("صفحة الإعدادات قريباً..."),
// ),
// );
// },
// ),
// MoreMenuItem(
// icon: Icons.help_outline,
// title: "المساعدة والدعم",
// iconColor: Colors.green[200],
// onTap: (context) {
// // TODO: إضافة صفحة المساعدة
// },
// ),
// MoreMenuItem(
// icon: Icons.info_outline,
// title: "عن التطبيق",
// iconColor: Colors.purple[200],
// onTap: (context) {
// // TODO: إضافة صفحة عن التطبيق
// },
// ),
// MoreMenuItem(
// icon: Icons.logout,
// title: "تسجيل الخروج",
// iconColor: Colors.red[200],
// onTap: (context) {
// LogoutService.handleLogout(context);
// },
// ),
// ];
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// backgroundColor: const Color(0xFF0A3C3A),
// appBar: _buildAppBar(),
// body: _buildMenuList(context),
// );
// }
//
// AppBar _buildAppBar() {
// return AppBar(
// title: const Row(
// children: [
// Icon(Icons.more_horiz, color: Colors.white, size: 28),
// SizedBox(width: 12),
// Text(
// 'المزيد',
// style: TextStyle(
// color: Colors.white,
// fontSize: 22,
// fontFamily: 'Almarai',
// fontWeight: FontWeight.w600,
// ),
// ),
// ],
// ),
// centerTitle: false,
// backgroundColor: const Color(0xFF1A4A48),
// elevation: 0,
// shape: const RoundedRectangleBorder(
// borderRadius: BorderRadius.vertical(
// bottom: Radius.circular(20),
// ),
// ),
// );
// }
//
// Widget _buildMenuList(BuildContext context) {
// return Padding(
// padding: const EdgeInsets.symmetric(vertical: 20),
// child: Column(
// children: [
// // بطاقة المستخدم (اختيارية)
// _buildUserCard(),
//
// // قائمة الخيارات
// Expanded(
// child: ListView.separated(
// itemCount: _menuItems.length,
// separatorBuilder: (_, __) => const Divider(
// color: Colors.white12,
// height: 1,
// indent: 72,
// ),
// itemBuilder: (context, index) {
// return _buildMenuItem(context, _menuItems[index]);
// },
// ),
// ),
// ],
// ),
// );
// }
//
// Widget _buildUserCard() {
// return Container(
// margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// padding: const EdgeInsets.all(16),
// decoration: BoxDecoration(
// color: Colors.white.withOpacity(0.05),
// borderRadius: BorderRadius.circular(16),
// border: Border.all(color: Colors.white.withOpacity(0.1)),
// ),
// child: Row(
// children: [
// Container(
// width: 50,
// height: 50,
// decoration: BoxDecoration(
// color: Colors.teal.withOpacity(0.3),
// shape: BoxShape.circle,
// ),
// child: const Icon(
// Icons.person,
// color: Colors.white,
// size: 30,
// ),
// ),
// const SizedBox(width: 16),
// Expanded(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "مرحباً بك",
// style: TextStyle(
// color: Colors.teal[200],
// fontSize: 18,
// fontWeight: FontWeight.w600,
// ),
// ),
// const SizedBox(height: 4),
// const Text(
// "يمكنك الوصول إلى جميع خيارات التطبيق من هنا",
// style: TextStyle(
// color: Colors.white70,
// fontSize: 13,
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// );
// }
//
// Widget _buildMenuItem(BuildContext context, MoreMenuItem item) {
// return ListTile(
// contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// leading: Container(
// width: 44,
// height: 44,
// decoration: BoxDecoration(
// color: item.iconColor?.withOpacity(0.2) ?? Colors.white.withOpacity(0.1),
// borderRadius: BorderRadius.circular(12),
// ),
// child: Icon(item.icon, color: item.iconColor ?? Colors.white),
// ),
// title: Text(
// item.title,
// style: const TextStyle(
// color: Colors.white,
// fontSize: 16,
// fontWeight: FontWeight.w500,
// ),
// ),
// trailing: Container(
// width: 32,
// height: 32,
// decoration: BoxDecoration(
// color: Colors.white.withOpacity(0.05),
// shape: BoxShape.circle,
// ),
// child: const Icon(
// Icons.arrow_forward_ios,
// color: Colors.white54,
// size: 16,
// ),
// ),
// onTap: () => item.onTap(context),
// );
// }
// }
//
// class MoreMenuItem {
// final IconData icon;
// final String title;
// final Color? iconColor;
// final void Function(BuildContext) onTap;
//
// MoreMenuItem({
// required this.icon,
// required this.title,
// this.iconColor,
// required this.onTap,
// });
// }
