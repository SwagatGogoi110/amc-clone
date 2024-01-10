import 'package:flutter/material.dart';

import '../widgets/invoice/api/pdf_api.dart';
import '../widgets/invoice/api/pdf_ivoice_api.dart';
import '../widgets/invoice/model/customer.dart';
import '../widgets/invoice/model/invoice.dart';
import '../widgets/invoice/model/supplier.dart';

class ServiceDetailsPopup extends StatelessWidget {
  final String chassisNum;

  const ServiceDetailsPopup({super.key, required this.chassisNum});
  List<Map<String, dynamic>> generateTableData() {
    return [
      {
        'Date': '23/09/2023',
        'Services': [
          {'name': 'Speedometer', 'price': '699', 'type': 'N/A'},
          {'name': 'Handle Bar', 'price': '319', 'type': 'N/A'},
          {'name': 'Seat Rest Cover', 'price': '119', 'type': 'N/A'},
          {'name': 'Side stand', 'price': '85', 'type': 'N/A'},
        ],
        'Bill Number': '00302202309220001',
        'Workshop': 'workshop04',
        'Total Cost': '1222.0',
      }, // Add more data as needed
    ];
  }

  DataColumn _createDataColumn(String label){
    return DataColumn(
      label: Text(
        label,
        style: const TextStyle(
            fontSize: 18
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Servicing Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Chassis Number: $chassisNum',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey.shade300),
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey.shade100),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              dataTextStyle: const TextStyle(
                color: Colors.black,
              ),
              columnSpacing: 20.0,
              dataRowMaxHeight: 100,
              columns: <DataColumn>[
                _createDataColumn('Date'),
                _createDataColumn('Services'),
                _createDataColumn('Bill Number'),
                _createDataColumn('Workshop'),
                _createDataColumn('Total Cost'),
                _createDataColumn('Action'),
              ],
              rows: List<DataRow>.generate(
                generateTableData().length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(generateTableData()[index]['Date']!),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (generateTableData()[index]['Services'] as List<Map<String, dynamic>>)
                              .map((service) => Text(
                            '${service['name']}: \$${service['price']} (${service['type']})',
                            style: const TextStyle(fontSize: 13),
                          ))
                              .toList(),
                        ),
                      ),
                    ),

                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(generateTableData()[index]['Bill Number']!),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(generateTableData()[index]['Workshop']!),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(generateTableData()[index]['Total Cost']!),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFCA2C),
                          ),
                          onPressed: () async {
                            final date = DateTime.now();
                            final dueDate = date.add(Duration(days: 7));
                            debugPrint('dyagdy');

                            final invoice = Invoice(
                                info: InvoiceInfo(description: 'My description', number: '${DateTime.now().year}-9999', date: date, dueDate: dueDate),
                                supplier: Supplier(name: 'Sarah Field', address: 'Washington Street', paymentInfo: 'https://paypal.me/sarahfieldzz'),
                                //customer: Customer(name: 'Apple Inc.', address: 'Apple Street, Cupertino, CA 95014'),
                                items: [
                                  InvoiceItem(description: 'Coffee', date: DateTime.now(), quantity: 3, vat: 0.19, unitPrice: 5.99)
                                ]
                            );
                            debugPrint('happy');
                            final pdfFile = await PdfInvoiceApi.generate(invoice);
                            debugPrint('2');
                            PdfApi.openFile(pdfFile);
                            debugPrint('3');
                          },
                          child: const Text('View More'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
