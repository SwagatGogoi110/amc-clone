import 'dart:convert';

import 'package:amcdemo/provider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../widgets/invoice/api/pdf_api.dart';
import '../widgets/invoice/api/pdf_ivoice_api.dart';
import '../widgets/invoice/model/invoice.dart';

class ServiceDetailsPopup extends StatefulWidget {
  final String chassisNum;
  final String vehicleMake;
  final String vehicleModel;

  const ServiceDetailsPopup({Key? key, required this.chassisNum, required this.vehicleMake, required this.vehicleModel})
      : super(key: key);

  @override
  State<ServiceDetailsPopup> createState() => _ServiceDetailsPopupState();
}

class _ServiceDetailsPopupState extends State<ServiceDetailsPopup> {
  List<Map<String, dynamic>>? details;

  Future<void> fetchDetails(String chassisNum) async {
    final apiUrl =
        'https://backendev.automovill.com/api/v1/invoices/$chassisNum';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.jwtToken;

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final res = await http.get(Uri.parse(apiUrl), headers: headers);
    final List<dynamic> resData = jsonDecode(res.body);

    if (details == null) {
      setState(() {
        details = resData.cast<Map<String, dynamic>>();
      });
    }
    print(resData);
  }

  List<Map<String, dynamic>> generateTableData() {
    return details?.map((item) {
      List<Map<String, dynamic>> servicesList = [];

      if (item["services"] != null && item["services"] is List) {
        for (var service in item["services"]) {
          servicesList.add({
            'name': service["name"] ?? '',
            'price': service["price"] ?? '',
            'type': service["type"] ?? '',
          });
        }
      }
      return {
        'Date': item["date_of_booking"] ?? '',
        'Services': servicesList,
        'Bill Number': item["bill_number"] ?? '',
        'Distance Travelled': item["distance_travelled"] ?? '',
        'Workshop': item["workshop_id"] ?? '',
        'Total Cost': item["total_cost"].toString() ?? '',
      };
    }).toList() ??
        [];
  }

  DataColumn _createDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> generateIndividualInvoice(
      BuildContext context, Map<String, dynamic> data) async {
    final List<Map<String, dynamic>> servicesList = data['Services'] ?? [];

    final invoice = Invoice(
      info: InvoiceInfo(
        number: data['Bill Number'] as String? ?? '',
        date: data['Date'] as String? ?? '',
        chassisNum: widget.chassisNum,
        vMake: widget.vehicleMake,
        vModel: widget.vehicleModel,
        kmDrive: data['Distance Travelled'].toString() ?? '',
        workshop: data['Workshop'] as String? ?? '',
      ),
      items: servicesList.map((service) {
        return InvoiceItem(
          description: service['name'] as String? ?? '',
          date: data['Date'] as String? ?? '', // Use 'Date' or provide another appropriate date if needed
          under: service['type'] as String? ?? '',
          unitPrice: double.parse(service['price'].toString() as String? ?? '0.0'),
        );
      }).toList(),
    );

    print('Data received: $data');
    print(data['Distance Travelled'].toString());

    print('Invoice generated: $invoice');


    final pdfFile = await PdfInvoiceApi.generate(invoice);
    PdfApi.openFile(pdfFile);
  }



  @override
  void initState() {
    super.initState();
    fetchDetails(widget.chassisNum);
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
            'Chassis Number: ${widget.chassisNum}',
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
              dataRowMaxHeight: 120,
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
                          children:
                          (generateTableData()[index]['Services'] as List<Map<String, dynamic>>)
                              .map((service) => Text(
                            '${service['name']}: Rs ${service['price']} (${service['type']})',
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
                            generateIndividualInvoice(
                                context, generateTableData()[index]);
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
