import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_library/data/demo_library.dart';

void main() {
  test('تسجل الإعارة بالكتاب ثم الإرجاع وتحدث عدد النسخ', () {
    final library = DemoLibrary();
    final book = library.bookById('b1');
    expect(book.title, 'رياض الصالحين');
    expect(book.availableCopies, 2);

    final error = library.lend(bookId: book.id, memberId: 'T-1025');
    expect(error, isNull);
    expect(book.availableCopies, 1);
    expect(library.loans.first.bookId, 'b1');

    final loan = library.loans.first;
    library.returnCopy(loan);
    expect(book.availableCopies, 2);
    expect(loan.isActive, isFalse);
    library.returnCopy(loan);
    expect(book.availableCopies, 2); // لا تحتسب الإرجاع مرتين
    library.dispose();
  });

  test('يرفض الكتاب غير الموجود أو المستفيد غير المسجل', () {
    final library = DemoLibrary();
    expect(library.lend(bookId: 'UNKNOWN', memberId: 'T-1025'), isNotNull);
    expect(library.lend(bookId: 'b1', memberId: 'T-9999'), isNotNull);
    expect(library.bookById('b1').availableCopies, 2);
    library.dispose();
  });

  test('لا يسمح بإعارة عدد أكبر من النسخ المتاحة', () {
    final library = DemoLibrary();
    expect(library.lend(bookId: 'b4', memberId: 'T-1025'), isNull);
    expect(library.lend(bookId: 'b4', memberId: 'T-2030'), isNull);
    expect(library.bookById('b4').availableCopies, 0);
    expect(library.lend(bookId: 'b4', memberId: 'T-2040'), isNotNull);
    expect(library.lend(bookId: 'b2', memberId: 'T-1025'), isNotNull);
    expect(library.bookById('b4').availableCopies, 0);
    library.dispose();
  });
}
