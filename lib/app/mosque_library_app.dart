import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/core/theme/app_theme.dart';
import 'package:mosque_library/data/demo_library.dart';
import 'package:mosque_library/models/app_role.dart';
import 'package:mosque_library/screens/librarian_page.dart';
import 'package:mosque_library/screens/login_page.dart';
import 'package:mosque_library/screens/reader_page.dart';

class MosqueLibraryApp extends StatefulWidget {
  const MosqueLibraryApp({super.key});

  @override
  State<MosqueLibraryApp> createState() => _MosqueLibraryAppState();
}

class _MosqueLibraryAppState extends State<MosqueLibraryApp> {
  final DemoLibrary library = DemoLibrary();
  AppRole? role;

  @override
  void dispose() {
    library.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مكتبات المساجد',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('ar'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: LayoutBuilder(builder: (context, c) {
          // على الويب/الحاسوب تبقى الواجهة بحجم هاتف كما في HTML.
          if (c.maxWidth <= 540) return child ?? const SizedBox.shrink();
          return ColoredBox(
            color: const Color(0xFFF1EBDD),
            child: Center(
              child: Container(
                width: 440,
                height: c.maxHeight,
                decoration: const BoxDecoration(
                  color: ivory,
                  boxShadow: [BoxShadow(color: Color(0x252A3029), blurRadius: 28)],
                ),
                child: child,
              ),
            ),
          );
        }),
      ),
      home: AnimatedBuilder(
        animation: library,
        builder: (context, _) {
          if (role == null) {
            return LoginPage(onLogin: (selected) => setState(() => role = selected));
          }
          if (role == AppRole.librarian) {
            return LibrarianPage(library: library, onLogout: () => setState(() => role = null));
          }
          return ReaderPage(library: library, onLogout: () => setState(() => role = null));
        },
      ),
    );
  }
}
