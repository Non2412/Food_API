import 'package:flutter/material.dart';
import 'register_page.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<Map<String, String>> get _users => UserStore.users;
  String? errorText;
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลืมรหัสผ่าน'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('กรุณากรอกอีเมลที่ใช้สมัครสมาชิก'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              // ตัวอย่าง: แจ้งเตือนส่งลิงก์รีเซ็ตรหัสผ่าน (Demo)
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('หากอีเมลถูกต้อง ระบบจะส่งลิงก์รีเซ็ตรหัสผ่านให้คุณ')),
              );
            },
            child: const Text('ส่ง'),
          ),
        ],
      ),
    );
  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      backgroundColor: Colors.orange[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 80, color: Colors.orange),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'อีเมล',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(errorText!, style: const TextStyle(color: Colors.red)),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text;
                        setState(() { errorText = null; });
                        final user = _users.firstWhere(
                          (u) => u['email'] == email && u['password'] == password,
                          orElse: () => {},
                        );
                        if (user.isEmpty) {
                          setState(() { errorText = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง'; });
                          return;
                        }
                        // บันทึกอีเมลผู้ใช้ที่ล็อกอินล่าสุด
                        currentUserEmail = user['email'];
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('เข้าสู่ระบบ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('สมัครสมาชิก'),
                      ),
                      TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text('ลืมรหัสผ่าน?'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
