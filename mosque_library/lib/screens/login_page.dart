import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/core/utils/show_note.dart';
import 'package:mosque_library/models/app_role.dart';
import 'package:mosque_library/widgets/field_label.dart';
import 'package:mosque_library/widgets/green_button.dart';
import 'package:mosque_library/widgets/library_mark.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});
  final ValueChanged<AppRole> onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: 'ahmad@mosque.local');
  final passwordController = TextEditingController();
  AppRole selectedRole = AppRole.reader;
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    if (!emailController.text.trim().contains('@') || passwordController.text.trim().isEmpty) {
      showNote(context, 'أدخل بريدًا إلكترونيًا وكلمة مرور للتجربة');
      return;
    }
    // نموذج تجريبي؛ لا توجد مصادقة حقيقية حتى يكتمل الخادم.
    widget.onLogin(selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: ColoredBox(
                  color: deepGreen,
                  child: GreenPattern(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                      SizedBox(height: 22),
                      LibraryMark(size: 104),
                      SizedBox(height: 4),
                      Text('مكتبات المساجد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 27)),
                      SizedBox(height: 3),
                      Text('بوابة المعرفة الرقمية والورقية', style: TextStyle(color: Color(0xFFE6E8DE), fontSize: 12)),
                    ]),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -13),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  decoration: const BoxDecoration(
                    color: ivory,
                    border: Border(top: BorderSide(color: softGold, width: 4)),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const FieldLabel('البريد الإلكتروني'),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(hintText: 'example@mosque.local'),
                    ),
                    const SizedBox(height: 19),
                    const FieldLabel('كلمة المرور'),
                    TextField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: !passwordVisible,
                      onSubmitted: (_) => submit(),
                      decoration: InputDecoration(
                        hintText: 'كلمة المرور',
                        suffixIcon: IconButton(
                          tooltip: passwordVisible ? 'إخفاء كلمة المرور' : 'إظهار كلمة المرور',
                          onPressed: () => setState(() => passwordVisible = !passwordVisible),
                          icon: Icon(passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 19),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const FieldLabel('نوع الحساب'),
                    Row(children: [
                      Expanded(child: _RoleSelector(
                        text: 'مستفيد', selected: selectedRole == AppRole.reader,
                        onTap: () => setState(() => selectedRole = AppRole.reader),
                      )),
                      const SizedBox(width: 9),
                      Expanded(child: _RoleSelector(
                        text: 'أمين المكتبة', selected: selectedRole == AppRole.librarian,
                        onTap: () => setState(() => selectedRole = AppRole.librarian),
                      )),
                    ]),
                    const SizedBox(height: 19),
                    GreenButton(label: 'تسجيل الدخول', onPressed: submit),
                    Center(child: TextButton(
                      onPressed: () => showNote(context, 'استعادة كلمة المرور تتطلب ربط الخادم لاحقًا'),
                      child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: deepGreen, fontSize: 12)),
                    )),
                    const SizedBox(height: 18),
                    const Center(child: Text(
                      'نموذج تجريبي — تسجيل الدخول غير متصل بالخادم',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, fontSize: 11),
                    )),
                    const SizedBox(height: 5),
                    const Center(child: Text('جرّب أي كلمة مرور غير فارغة',
                      style: TextStyle(color: muted, fontSize: 11))),
                  ]),
                ),
              ),
            ]),
          ),
        );
      })),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.text, required this.selected, required this.onTap});
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF9F4E5) : const Color(0xFFEAE5D9),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? gold : Colors.transparent),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            if (selected) ...[
              const SizedBox(width: 5),
              const Icon(Icons.check_circle, color: gold, size: 16),
            ],
          ]),
        ),
      ),
    );
  }
}
