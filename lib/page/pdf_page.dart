import 'package:flutter/material.dart';
import 'package:pdf_invoice/api/pdf_api.dart';
import 'package:pdf_invoice/api/pdf_invoice_api.dart';
import 'package:pdf_invoice/model/customer.dart';
import 'package:pdf_invoice/model/invoice.dart';
import 'package:pdf_invoice/model/supplier.dart';
import 'package:pdf_invoice/widget/button_widget.dart';
import 'package:pdf_invoice/widget/title_widget.dart';

class PdfPage extends StatefulWidget {
  final List<InvoiceItem> items;

  PdfPage(@required this.items);
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 30,
        shadowColor: Colors.white70,
        title: Text("Invoice"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleWidget(
                icon: Icons.picture_as_pdf,
                text: 'Generate Invoice',
              ),
              ButtonWidget(
                text: "Invoice Pdf",
                onClick: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(Duration(days: 7));
                  final invoice = Invoice(
                    supplier: Supplier(
                      name: 'TeamXY Pvt. Ltd.',
                      address: 'PQR Road, UTV city, IND',
                      paymentInfo: 'https://paytm.me/teamXY',
                    ),
                    customer: Customer(
                      name: 'Larry Page',
                      address: "XYZ colony,  UTV city, IND",
                    ),
                    info: InvoiceInfo(
                      date: date,
                      dueDate: dueDate,
                      description: 'My description...',
                      number: '${DateTime.now().millisecondsSinceEpoch}-9999',
                    ),
                    // items: [
                    //   InvoiceItem(
                    //     description: 'Coffee',
                    //     quantity: 3,
                    //     gst: 0.19,
                    //     unitPrice: 5.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Water',
                    //     quantity: 8,
                    //     gst: 0.19,
                    //     unitPrice: 0.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Orange',
                    //     quantity: 3,
                    //     gst: 0.19,
                    //     unitPrice: 2.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Apple',
                    //     quantity: 8,
                    //     gst: 0.19,
                    //     unitPrice: 3.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Mango',
                    //     quantity: 1,
                    //     gst: 0.19,
                    //     unitPrice: 1.59,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Blue Berries',
                    //     quantity: 5,
                    //     gst: 0.19,
                    //     unitPrice: 0.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Lemon',
                    //     quantity: 4,
                    //     gst: 0.19,
                    //     unitPrice: 1.29,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Coffee',
                    //     quantity: 3,
                    //     gst: 0.19,
                    //     unitPrice: 5.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Water',
                    //     quantity: 8,
                    //     gst: 0.19,
                    //     unitPrice: 0.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Orange',
                    //     quantity: 3,
                    //     gst: 0.19,
                    //     unitPrice: 2.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Apple',
                    //     quantity: 8,
                    //     gst: 0.19,
                    //     unitPrice: 3.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Mango',
                    //     //date: DateTime.now(),
                    //     quantity: 1,
                    //     gst: 0.19,
                    //     unitPrice: 1.59,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Blue Berries',
                    //     quantity: 5,
                    //     gst: 0.19,
                    //     unitPrice: 0.99,
                    //   ),
                    //   InvoiceItem(
                    //     description: 'Lemon',
                    //     quantity: 4,
                    //     gst: 0.19,
                    //     unitPrice: 1.29,
                    //   ),
                    // ],
                    items: widget.items,
                  );

                  final pdfFile = await PdfInvoiceApi.generate(invoice);

                  PdfApi.openFile(pdfFile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
