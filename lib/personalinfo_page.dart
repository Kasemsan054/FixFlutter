import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ตั้งค่าข้อมูลเริ่มต้น (สามารถเปลี่ยนได้ตามความต้องการ)
    _firstNameController.text = 'ชื่อ';
    _lastNameController.text = 'นามสกุล';
    _phoneController.text = 'เบอร์โทร';
  }

  void _saveInfo() {
    // ประมวลผลการบันทึกข้อมูลที่แก้ไข
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phone = _phoneController.text;

    // คุณสามารถเพิ่มโค้ดเพื่อบันทึกข้อมูลลงฐานข้อมูลได้ที่นี่

    // แสดงข้อความยืนยัน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลส่วนตัว'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'ชื่อ'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'นามสกุล'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'เบอร์โทร'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveInfo,
              child: Text('บันทึกข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
