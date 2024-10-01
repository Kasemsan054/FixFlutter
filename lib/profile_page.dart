import 'package:flutter/material.dart';
import 'package:tucksalon/about_page.dart';
import 'package:tucksalon/login_page.dart';
import 'package:tucksalon/personalinfo_page.dart';
import 'package:tucksalon/security_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ชื่อผู้ใช้
              Text(
                user?.displayName ?? 'John Doe',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // รายการเมนู
              Expanded(
                child: ListView(
                  children: [
                    _buildListTile('ข้อมูลส่วนตัว', Icons.person, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PersonalInfoPage()),
                      );
                    }),
                    _buildListTile('ความปลอดภัย', Icons.lock, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecurityPage()),
                      );
                    }),
                    _buildListTile('เกี่ยวกับ', Icons.info, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutPage()),
                      );
                    }),
                    // ปุ่มออกจากระบบ
                    _buildListTile('ออกจากระบบ', Icons.logout, () {
                      _signOut(context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // แสดงข้อความยืนยัน
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ออกจากระบบเรียบร้อยแล้ว')),
      );
      // นำผู้ใช้กลับไปยังหน้าเข้าสู่ระบบ (Login)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()), // แก้ไขบรรทัดนี้
      );
    } catch (e) {
      // แสดงข้อผิดพลาดถ้ามี
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการออกจากระบบ')),
      );
    }
  }
}
