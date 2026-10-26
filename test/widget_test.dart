import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_library/app/mosque_library_app.dart';

void main() {
  testWidgets('يظهر التصميم العربي الجديد وشاشة تسجيل الدخول', (tester) async {
    await tester.pumpWidget(const MosqueLibraryApp());
    expect(find.text('مكتبات المساجد'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('يصل المستفيد إلى قائمة الكتب التجريبية', (tester) async {
    await tester.pumpWidget(const MosqueLibraryApp());
    await tester.enterText(find.byType(TextField).last, '1234');
    await tester.ensureVisible(find.text('تسجيل الدخول'));
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();
    expect(find.text('رياض الصالحين'), findsOneWidget);
    expect(find.text('المكتبة'), findsOneWidget);
  });
}
