import 'package:flutter/material.dart';

class AmcDetailsPopup extends StatelessWidget {
  final String chassisNum;

  AmcDetailsPopup({required this.chassisNum});

  List<Map<String, String>> generateTableData() {
    return [
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
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CHASSIS NUMBER: \n$chassisNum',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Scope of Work')),
                      DataColumn(label: Text('Frequency')),
                      DataColumn(label: Text('Details')),
                    ],
                    rows: List<DataRow>.generate(
                      generateTableData().length,
                      (index) => DataRow(
                        cells: [
                          DataCell(
                              Text(generateTableData()[index]['Scope of Work']!)),
                          DataCell(
                              Text(generateTableData()[index]['Frequency']!)),
                          DataCell(Text(generateTableData()[index]['Details']!)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade400,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK", style: TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
