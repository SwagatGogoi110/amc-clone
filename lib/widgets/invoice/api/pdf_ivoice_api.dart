import 'dart:io';

import 'package:amcdemo/widgets/invoice/api/pdf_api.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/Company.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    try {
      final pdf = Document();

      pdf.addPage(MultiPage(
        build: (Context context) => [
          buildHeader(invoice),
          SizedBox(height: 3 * PdfPageFormat.cm),
          buildTitle(invoice),
          buildInvoice(invoice),
          Divider(),
          buildTotal(invoice),
        ],
        footer: (context) => buildFooter(invoice),
      ));
      print('PDF generated successfully');
      return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
    } catch (e) {
      print(
          'Error generating PDF: $e'); // Print any error that occurs during PDF generation
      return Future.error('PDF generation failed');
    }
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCompanyInfo(const Company(
                  companyName: 'Automovill Technologies Private Limited',
                  address:
                      '587,Ground Floor,18th Cross,2nd Main,KPC Layout,\nKasavanahalli,Bangalore-35',
                  gstin: '9AANCA9593JIZQ',
                  cin: 'IJ7411OKA2015PTC083874',
                  pan: 'AANCA9593J')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //buildSupplierAddress(invoice.supplier),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCompanyInfo(Company company) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(company.companyName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 8),
          Text('Address: ${company.address}'),
          SizedBox(height: 4),
          Text('GSTIN: ${company.gstin}'),
          SizedBox(height: 4),
          Text('CIN: ${company.cin}'),
          SizedBox(height: 4),
          Text('PAN: ${company.pan}'),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Chassis Number:',
      'Vehicle Make:',
      'Vehicle Model:',
      'KM Driven:',
      'Workshop:',
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      'CH12345',
      'FUJIYAMA',
      'SPECTRA',
      '599',
      'Automovill-workshop02',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Description', 'Date', 'Quantity', 'Unit Price', 'Total'];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\Rs ${item.unitPrice}',
        '\Rs ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
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
    //Calculation of tax will be done here
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final gstPercent = invoice.items.first.vat;
    final gst = netTotal * gstPercent;
    final total = netTotal + gst;

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
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'CGST ${gstPercent * 100} %',
                  value: Utils.formatPrice(gst),
                  unite: true,
                ),
                buildText(
                  title: 'SGST ${gstPercent * 100} %',
                  value: Utils.formatPrice(gst),
                  unite: true,
                ),
                buildText(
                  title: 'IGST ${gstPercent * 100} %',
                  value: Utils.formatPrice(gst),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: '\u00A9', value: 'Automovill Technologies Pvt. Ltd.'),
          buildSimpleText(title: 'Email', value: 'support@automovill.com'),
          buildSimpleText(
              title: 'Website', value: 'https://www.automovill.com'),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
