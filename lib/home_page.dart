import 'package:flutter/material.dart';
import 'package:tucksalon/booking_page.dart';
import 'package:tucksalon/notifications_page.dart';
import 'package:tucksalon/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('หน้าโฮม')),
    const BookingPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('การจองคิว'),
          content: const BookingForm(),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                BookingForm.clearFields();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ล้างข้อมูล'),
              onPressed: () {
                BookingForm.clearFields();
              },
            ),
            ElevatedButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                final formState = BookingForm.of(context);
                formState?.confirmBooking();
                BookingForm.clearFields();
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'โฮม',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'การจอง',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.add, size: 40, color: Colors.white),
          onPressed: _showBookingDialog,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class BookingForm extends StatefulWidget {
  static final TextEditingController _dateController = TextEditingController();
  static final TextEditingController _timeController = TextEditingController();

  const BookingForm({super.key});

  static _BookingFormState? of(BuildContext context) {
    return context.findAncestorStateOfType<_BookingFormState>();
  }

  @override
  _BookingFormState createState() => _BookingFormState();

  static void clearFields() {
    _dateController.clear();
    _timeController.clear();
  }
}

class _BookingFormState extends State<BookingForm> {
  final List<String> services = ["บริการ 1", "บริการ 2", "บริการ 3"];
  final List<String> workers = ["ช่าง 1", "ช่าง 2", "ช่าง 3"];

  String? selectedService;
  String? selectedWorker;

  void confirmBooking() {
    String date = BookingForm._dateController.text;
    String time = BookingForm._timeController.text;

    if (selectedWorker == null || selectedService == null || date.isEmpty || time.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ข้อผิดพลาด'),
            content: const Text('กรุณากรอกข้อมูลให้ครบถ้วน!'),
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
      return;
    }

    print('การจอง: ช่าง: $selectedWorker, บริการ: $selectedService, วันที่: $date, เวลา: $time');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        BookingForm._dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        BookingForm._timeController.text = "${picked.hour}:${picked.minute}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'เลือกช่าง'),
          items: workers.map((String worker) {
            return DropdownMenuItem<String>(
              value: worker,
              child: Text(worker),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedWorker = value;
            });
          },
        ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'เลือกบริการ'),
          items: services.map((String service) {
            return DropdownMenuItem<String>(
              value: service,
              child: Text(service),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedService = value;
            });
          },
        ),
        TextField(
          controller: BookingForm._dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'เลือกวันที่',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
        ),
        TextField(
          controller: BookingForm._timeController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'เลือกเวลา',
            suffixIcon: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () => _selectTime(context),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
