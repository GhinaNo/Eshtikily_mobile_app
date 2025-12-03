import 'package:eshhtikiyl_app/features/profile/presentation/pages/show_profile_page.dart';
import 'package:flutter/material.dart';
import '../core/services/logout_srevice.dart';
import '../pages/complaint_list.dart';
import '../pages/create_complaint.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const ListComplaintsPage(),
    const CreateComplaintPage(),
    Center(child: Text("الإشعارات", style: TextStyle(color: Colors.white))),
    const MoreTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0A3C3A),
        selectedItemColor: Colors.teal[200],
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "الشكاوى",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "إضافة شكوى",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "الإشعارات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "المزيد",
          ),
        ],
      ),
    );
  }
}

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3C3A),
      appBar: AppBar(
        title: Row(
          children: [
            // الشعار
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'المزيد',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(168, 10, 60, 58),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildItem(Icons.person, "الملف الشخصي", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }),
          _buildItem(Icons.settings, "الإعدادات", () {}),
          _buildItem(Icons.logout, "تسجيل الخروج", () {
            LogoutService.handleLogout(context);
          }),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal[200]),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
      onTap: onTap,
    );
  }
}
