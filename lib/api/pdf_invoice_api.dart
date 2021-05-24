import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_invoice/api/pdf_api.dart';
import 'package:pdf_invoice/model/customer.dart';
import 'package:pdf_invoice/model/invoice.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_invoice/model/supplier.dart';
import '../model/invoice.dart';
import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    final imagePng =
        (await rootBundle.load('assets/img.png')).buffer.asUint8List();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          buildHeader(invoice),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildInvoice(invoice),
          Divider(),
          buildTotal(invoice),
        ],
        header: (context) => buildTop(imagePng),
        footer: (context) => buildFooter(invoice, imagePng),
      ),
    );
    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static buildTitle(Invoice invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INVOICE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Text(invoice.info.description),
      ],
    );
  }

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Description', 'Qty', 'Price', 'GST', 'Total'];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.gst);
      return [
        item.description,
        '${item.quantity}',
        "${item.unitPrice}",
        '${item.gst} %',
        "${total.toStringAsFixed(2)}",
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      defaultColumnWidth: IntrinsicColumnWidth(flex: 1.5),
      tableWidth: TableWidth.max,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.gst;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Gross total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total Amount (in INR)',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 1 * PdfPageFormat.mm)
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    @required String title,
    @required String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);
    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: style),
          ),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Widget buildTop(Uint8List img) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: PdfColors.black,
          child: Row(
            children: [
              Text(
                'INVOICE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2 * PdfPageFormat.cm),
      ],
    );
  }

  static Widget buildFooter(Invoice invoice, Uint8List img) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Divider(),
        SizedBox(height: 2 * PdfPageFormat.mm),
        buildSimpleText(
          title: 'Address',
          value: invoice.supplier.address,
        ),
        SizedBox(),
        buildSimpleText(
          title: 'Paytm',
          value: invoice.supplier.paymentInfo,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              MemoryImage(img),
              fit: BoxFit.fitHeight,
              height: 40,
              width: 40,
            ),
            SizedBox(
              width: 0.5 * PdfPageFormat.cm,
            ),
            Text(
              "TeamXY",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: PdfColor.fromHex('1d3557'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static buildSimpleText({@required String title, @required String value}) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static Widget buildHeader(Invoice invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildSupplierAddress(invoice.supplier),
            Container(
              height: 50,
              width: 50,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: invoice.info.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCustomerAddress(invoice.customer),
            buildInvoiceInfo(invoice.info),
          ],
        ),
      ],
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BILLING ADDRESS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Text(
          supplier.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(supplier.address),
      ],
    );
  }

  static Widget buildCustomerAddress(Customer customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SHIPPING ADDRESS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Text(
          customer.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(customer.address),
      ],
    );
  }

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        titles.length,
        (index) {
          final title = titles[index];
          final value = data[index];
          return buildText(
            title: title,
            value: value,
            width: 200,
          );
        },
      ),
    );
  }
}
