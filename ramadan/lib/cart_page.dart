import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  // دالة وهمية لإرسال الطلب للفايربيز
  Future<void> _confirmOrder(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'items': ['شاحن Ugreen', 'سماعة برو'], // مثال
        'total': 235,
        'status': 'جديد',
        'createdAt': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم تأكيد الطلب بنجاح!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل الطلب: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("سلة المشتريات")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text("مثال لمنتج في السلة"), trailing: Text("140 ر.س")),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("الإجمالي"), Text("140 ر.س", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 20))]),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _confirmOrder(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD4AF37), padding: EdgeInsets.all(15)),
                    child: Text("تأكيد الطلب وحفظه في الفايربيز", style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}