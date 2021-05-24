import 'package:flutter/material.dart';
import 'package:pdf_invoice/dynamicList/check_list.dart';
import 'package:pdf_invoice/page/pdf_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeamXY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      //home: PdfPage(),
      home: CheckList(),
    );
  }
}
