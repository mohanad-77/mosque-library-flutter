import 'package:flutter/material.dart';
class page extends StatelessWidget {
  const page({super.key});
var A =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pages'),
      backgroundColor: Colors.cyan,),
      body: Center(
        child: Column(
          children: [
            ElevatedButton( onPressed: SizedBox.square ,
                child: Text('click'))

          ],
        ),
      ),

    );
  }
}
