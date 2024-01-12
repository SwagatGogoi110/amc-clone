import 'package:amcdemo/widgets/invoice/api/pdf_api.dart';
import 'package:amcdemo/widgets/invoice/api/pdf_ivoice_api.dart';
import 'package:amcdemo/widgets/invoice/button_widget.dart';
import 'package:amcdemo/widgets/invoice/model/invoice.dart';
import 'package:amcdemo/widgets/invoice/model/supplier.dart';
import 'package:amcdemo/widgets/invoice/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Invoice'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TitleWidget(
                icon: Icons.picture_as_pdf,
                text: 'Generate Invoice',
              ),
              const SizedBox(height: 40),
              ButtonWidget(
                text: "Invoice PDF",
                onClicked: () async {
                  // final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  // //final dueDate = date.add(Duration(days: 7));
                  // debugPrint('dyagdy');
                  //
                  // final invoice = Invoice(
                  //     info: InvoiceInfo(number: '${DateTime.now().year}', date: date, ),
                  //     //supplier: Supplier(name: 'Sarah Field', address: 'Washington Street', paymentInfo: 'https://paypal.me/sarahfieldzz'),
                  //     //customer: Customer(name: 'Apple Inc.', address: 'Apple Street, Cupertino, CA 95014'),
                  //     items: [
                  //       InvoiceItem(description: 'Option 12', date: DateTime.now(), under: 'AMC', vat: 0, ),
                  //     ]
                  // );
                  // debugPrint('happy');
                  // final pdfFile = await PdfInvoiceApi.generate(invoice);
                  // debugPrint('2');
                  // PdfApi.openFile(pdfFile);
                  // debugPrint('3');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
