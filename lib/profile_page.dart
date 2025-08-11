import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'), // เปลี่ยน path ตามไฟล์รูปของคุณ
            ),
            const SizedBox(height: 20),
            const Text(
              'ชื่อผู้ใช้',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'อีเมล: user@email.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'เบอร์โทรศัพท์: 081-234-5678',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'ที่อยู่: 123 หมู่บ้านสุขใจ ต.ในเมือง อ.เมือง จ.นครราชสีมา',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // เพิ่มฟังก์ชันแก้ไขโปรไฟล์ที่นี่
              },
              child: const Text('แก้ไขโปรไฟล์'),
            ),
          ],
        ),
      ),
    );
  }
}
