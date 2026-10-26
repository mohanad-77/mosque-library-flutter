import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ في تسجيل الدخول: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_person, size: 80, color: Color(0xFFD4AF37)),
            SizedBox(height: 30),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "البريد الإلكتروني", border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "كلمة المرور", border: OutlineInputBorder())),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD4AF37), padding: EdgeInsets.symmetric(vertical: 15)),
                child: Text("تسجيل الدخول", style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}