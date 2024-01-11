import 'dart:convert';

import 'package:amcdemo/provider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WarrantyDetailsPopup extends StatefulWidget {
  final String chassisNum;
  final String warrantyStart;
  final String warrantyEnd;
  const WarrantyDetailsPopup({super.key, required this.chassisNum, required this.warrantyStart, required this.warrantyEnd});

  @override
  State<WarrantyDetailsPopup> createState() => _WarrantyDetailsPopupState();
}

class _WarrantyDetailsPopupState extends State<WarrantyDetailsPopup> {

  List<Map<String, dynamic>>? details;

  Future<void> fetchDetails(String chassisNum) async {
    final apiUrl = 'https://backendev.automovill.com/api/v1/warranty-availability/$chassisNum';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.jwtToken;

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final res = await http.get(Uri.parse(apiUrl), headers: headers);
    final List<dynamic> resData = jsonDecode(res.body);

    setState(() {
      details = resData.cast<Map<String, dynamic>>();
    });
  }

  @override
  void initState(){
    super.initState();
    fetchDetails(widget.chassisNum);
  }

  List<Map<String, dynamic>> generateTableData() {
    return details?.map((item) {
      return{
        'Scope of Work': item["scopeOfWork"] ?? '',
        'Frequency': item["frequency"].toString() ?? '',
        'Details': item["details"] ?? '',
      };
    }).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.warrantyStart);
    print(widget.warrantyEnd);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Warranty Details', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,),),
          const SizedBox(height: 15),
          Text(
            'CHASSIS NUMBER: ${widget.chassisNum}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          Text(
            'WARRANTY START: ${widget.warrantyStart}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          Text(
            'WARRANTY END: ${widget.warrantyEnd}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade300),
              dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
              headingTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              dataTextStyle: TextStyle(
                color: Colors.black,
              ),
              columnSpacing: 20.0,
              dataRowMaxHeight: 100,
              columns: const <DataColumn>[
                DataColumn(label: Text('Scope of Work', style: TextStyle(fontSize: 18),)),
                DataColumn(label: Text('Frequency', style: TextStyle(fontSize: 18),)),
                DataColumn(label: Text('Details', style: TextStyle(fontSize: 18),)),
              ],
              rows: List<DataRow>.generate(
                generateTableData().length,
                    (index) => DataRow(
                  cells: [
                    DataCell(
                      Padding(padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(generateTableData()[index]['Scope of Work']!),),),
                    DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(generateTableData()[index]['Frequency']!),
                        )),
                    DataCell(Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(generateTableData()[index]['Details']!),
                    )),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
