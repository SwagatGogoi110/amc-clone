import 'package:amcdemo/widgets/webview.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPopup extends StatelessWidget {
  final String chassisNum;

  const ServiceDetailsPopup({super.key, required this.chassisNum});
  List<Map<String, String>> generateTableData() {
    return [
      {
        'Date': '23/09/2023',
        'Services': 'Repair',
        'Bill Number': 'qoyuwsgoiuwgiogdpiqwduiqwd',
        'Workshop': 'workshop01',
        'Total Cost': '500',
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
                        child: Text(generateTableData()[index]['Services']!),
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
                          onPressed: (){
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
