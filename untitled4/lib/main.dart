import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

void main() => runApp(const MaterialApp(home: ReadExcel()));

class ReadExcel extends StatefulWidget {
  const ReadExcel({super.key});
  @override
  State<ReadExcel> createState() => _ReadExcelState();
}

class _ReadExcelState extends State<ReadExcel> {
  String fileName = "لم يتم اختيار ملف بعد";
  // 1. هذا هو "المخزن" اللي بياخذ البيانات من الإكسل ويعرضها في الشاشة
  List<List<dynamic>> excelData = [];

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls']);

    if (result != null) {
      String filePath = result.files.single.path!;
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<List<dynamic>> temp = [];
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          // هنا نحول كل سطر إلى قائمة ونضيفه للمخزن المؤقت
          temp.add(row.map((cell) => cell?.value).toList());
        }
      }

      setState(() {
        fileName = basename(filePath);
        excelData = temp; // 2. هنا نحدث الشاشة بالبيانات الجديدة
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Excel Reader'), backgroundColor: Colors.green),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: pickFile, child: const Text('اختر ملف')),

          const Divider(),

          // 3. هذا الجزء هو المسؤول عن عرض الجدول في واجهة التطبيق
          Expanded(
            child: excelData.isEmpty
                ? const Center(child: Text("لا توجد بيانات لعرضها"))
                : SingleChildScrollView(
              scrollDirection: Axis.vertical, // سكرول عمودي
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // سكرول أفقي
                child: DataTable(
                  // إنشاء الأعمدة من أول صف في الملف
                  columns: excelData.first.map((h) => DataColumn(label: Text(h.toString()))).toList(),
                  // إنشاء الصفوف من باقي الملف
                  rows: excelData.skip(1).map((row) => DataRow(
                    cells: row.map((c) => DataCell(Text(c?.toString() ?? ""))).toList(),
                  )).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}