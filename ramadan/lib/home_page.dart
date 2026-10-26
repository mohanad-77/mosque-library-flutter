import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // القائمة الجانبية
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2C3E50)),
              accountName: Text("الشهاب فون"),
              accountEmail: Text("mohanadbataher@gmail.com"),
            ),
            ListTile(leading: const Icon(Icons.star), title: const Text("آراء العملاء"), onTap: () {}),
            ListTile(leading: const Icon(Icons.location_on), title: const Text("موقعنا"), onTap: () {}),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        title: const Text("الشهاب فون"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // البانر العلوي
            Container(
              height: 160, width: double.infinity, margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [Color(0xFF2C3E50), Color(0xFF34495E)]),
              ),
              child: const Center(child: Text("أحدث إكسسوارات الجوال", style: TextStyle(color: Colors.white, fontSize: 18))),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(alignment: Alignment.centerRight, child: Text("الأقسام", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            ),

            // --- هنا الربط مع الفايربيز ---
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('categories').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                if (!snapshot.hasData) return const Text("لا توجد بيانات");

                final docs = snapshot.data!.docs;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    var data = docs[i].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.category, color: Color(0xFF2C3E50)),
                          Text(data['name'] ?? "بدون اسم"),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}