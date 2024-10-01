import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart'; // ต้องติดตั้ง package_info_plus

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _showAppVersion(BuildContext context) async {
    // รับข้อมูลเวอร์ชันของแอป
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เวอร์ชันของแอป'),
          content: Text('เวอร์ชัน: $version'),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
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
        title: const Text('เกี่ยวกับ'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showAppVersion(context),
          child: const Text('แสดงเวอร์ชันของแอป'),
        ),
      ),
    );
  }
}
