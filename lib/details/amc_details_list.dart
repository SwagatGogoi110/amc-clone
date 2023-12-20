import 'package:flutter/material.dart';

class AmcDetailsPopup extends StatelessWidget {
  final String chassisNum;

  const AmcDetailsPopup({super.key, required this.chassisNum});

  List<Map<String, String>> generateTableData() {
    return [
      {
        'Scope of Work': 'Repair of puncture (in case of non-body/no wheel damage)',
        'Frequency': '2',
        'Details': 'Puncture Repair',
      },
      {
        'Scope of Work': 'Subjected to MoU between Fujiyama and ETM bikes',
        'Frequency': '2',
        'Details': 'Battery Swapping',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work': 'Subjected to MoU between Fujiyama and ETM bikes',
        'Frequency': '2',
        'Details': 'Battery Swapping',
      },
      {
        'Scope of Work':
            'Repair of puncture (in case of non-body/no wheel damage)',
        'Frequency': '2',
        'Details': 'Puncture Repair',
      },
      {
        'Scope of Work': 'Subjected to MoU between Fujiyama and ETM bikes',
        'Frequency': '2',
        'Details': 'Battery Swapping',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work':
            'Followings will be Covered:\n- Motor, controller and Battery (AS per the warranty with OEM)\n- Brake shoes - Front and back\n- Suspension - Front and rear\n- Free overhaul (parts chargeable)',
        'Frequency': '1',
        'Details': 'Minor Repairs (Mechanical/Electrical)',
      },
      {
        'Scope of Work': 'Subjected to MoU between Fujiyama and ETM bikes',
        'Frequency': '2',
        'Details': 'Battery Swapping',
      },
      // Add more data as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CHASSIS NUMBER: \n$chassisNum',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
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
