import 'package:flutter/material.dart';
// เก็บข้อมูลผู้ใช้จำลองแบบ global
class UserStore {
  static final List<Map<String, String>> users = [];
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isObscure = true;
  bool isObscureConfirm = true;

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สมัครสมาชิก'),
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
                  const Icon(Icons.person_add, size: 80, color: Colors.orange),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อ-นามสกุล',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'เบอร์โทรศัพท์',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'ที่อยู่',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    keyboardType: TextInputType.streetAddress,
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: isObscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'ยืนยันรหัสผ่าน',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isObscureConfirm ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isObscureConfirm = !isObscureConfirm;
                          });
                        },
                      ),
                    ),
                  ),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(errorText!, style: const TextStyle(color: Colors.red)),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final phone = phoneController.text.trim();
                        final address = addressController.text.trim();
                        final password = passwordController.text;
                        final confirmPassword = confirmPasswordController.text;

                        setState(() { errorText = null; });
                        if (name.isEmpty || email.isEmpty || phone.isEmpty || address.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                          setState(() { errorText = 'กรุณากรอกข้อมูลให้ครบถ้วน'; });
                          return;
                        }
                        if (!email.contains('@')) {
                          setState(() { errorText = 'อีเมลไม่ถูกต้อง'; });
                          return;
                        }
                        if (password.length < 4) {
                          setState(() { errorText = 'รหัสผ่านควรมีอย่างน้อย 4 ตัวอักษร'; });
                          return;
                        }
                        if (password != confirmPassword) {
                          setState(() { errorText = 'รหัสผ่านไม่ตรงกัน'; });
                          return;
                        }
                        if (UserStore.users.any((u) => u['email'] == email)) {
                          setState(() { errorText = 'อีเมลนี้ถูกใช้ไปแล้ว'; });
                          return;
                        }
                        UserStore.users.add({
                          'name': name,
                          'email': email,
                          'phone': phone,
                          'address': address,
                          'password': password,
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ')),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('สมัครสมาชิก'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
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