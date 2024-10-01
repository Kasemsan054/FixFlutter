import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance; // สร้าง instance ของ FirebaseAuth

  void _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('กรุณากรอกรหัสผ่านใหม่และยืนยัน');
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorDialog('รหัสผ่านใหม่และยืนยันไม่ตรงกัน');
      return;
    }

    User? user = _auth.currentUser;

    // ตรวจสอบว่าผู้ใช้ล็อกอินอยู่หรือไม่
    if (user != null) {
      try {
        // ใช้ re-authenticate เพื่อให้แน่ใจว่าผู้ใช้เป็นเจ้าของบัญชี
        String email = user.email!;
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);

        await user.reauthenticateWithCredential(credential); // Re-authenticate

        // เปลี่ยนรหัสผ่าน
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ!')),
        );

        // ล้างข้อมูล
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } catch (e) {
        _showErrorDialog('ไม่สามารถเปลี่ยนรหัสผ่านได้: $e');
      }
    } else {
      _showErrorDialog('ผู้ใช้ไม่ได้ล็อกอิน');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ข้อผิดพลาด'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ความปลอดภัย'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: 'รหัสผ่านเก่า'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'รหัสผ่านใหม่'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'ยืนยันรหัสผ่านใหม่'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('เปลี่ยนรหัสผ่าน'),
            ),
          ],
        ),
      ),
    );
  }
}
