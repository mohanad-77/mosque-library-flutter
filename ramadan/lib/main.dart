import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // هذه السطر هو اللي كان يعلق عندك لأنه ينتظر الويب
    await Firebase.initializeApp();
    print("تم الاتصال بنجاح!");
  } catch (e) {
    print("خطأ في التهيئة: $e");
  }

  runApp(const ShehabPhoneApp());
}

class ShehabPhoneApp extends StatelessWidget {
  const ShehabPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الشهاب فون',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(), // صفحتك اللي فيها الأقسام
    );
  }
}