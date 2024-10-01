import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      // แสดงข้อความสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ลิงก์รีเซ็ตรหัสผ่านถูกส่งไปที่อีเมลของคุณ")),
      );
      
      // นำกลับไปยังหน้าเข้าสู่ระบบ
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
      // แสดงข้อความผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ไม่สามารถส่งลิงก์รีเซ็ตรหัสผ่านได้: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลืมรหัสผ่าน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'กรุณาใส่อีเมลของคุณ'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('ส่งลิงก์รีเซ็ตรหัสผ่าน'),
            ),
          ],
        ),
      ),
    );
  }
}
