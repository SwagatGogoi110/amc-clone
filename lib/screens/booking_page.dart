import 'dart:convert';
import 'dart:io';

import 'package:amcdemo/screens/details_page.dart';
import 'package:amcdemo/widgets/invoice/api/pdf_api.dart';
import 'package:amcdemo/widgets/invoice/api/pdf_ivoice_api.dart';
import 'package:amcdemo/widgets/invoice/model/invoice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/AuthProvider.dart';

class BookingPage extends StatefulWidget {
  final String chassisNum;
  final String vehicleMake;
  final String vehicleModel;
  final String fuelType;

  final String lastServiceDate;
  final int lastServiceKm;
  const BookingPage({
    Key? key,
    required this.chassisNum,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.fuelType,
    required this.lastServiceDate,
    required this.lastServiceKm,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late String? invoiceId;
  late TextEditingController _amountController = TextEditingController();
  bool amcSelected = false;
  bool warrantySelected = false;

  void bypassSSL() {
    HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  }

  Future<void> generateInvoice(BuildContext context) async {
      bypassSSL();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.jwtToken;
      print('$token');
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      List<Map<String, dynamic>> amcItems = [];
      List<Map<String, dynamic>> warrantyItems = [];

      for (var service in serviceList) {
        if (service['Under'] == 'AMC') {
          amcItems.add({
            'name': service['Service'],
            'price': service['Amount'] as double,
          });
        } else if (service['Under'] == 'Warranty') {
          warrantyItems.add({
            'name': service['Service'],
            'price': service['Amount'] as double,
          });
        }
      }

      Map<String, dynamic> postData = {
        // 'amc_items': serviceList.map((service) {
        //   if(service['Under'] == 'AMC'){
        //     return {
        //       'name': service['Service'],
        //       'price': service['Amount'],
        //       'type': 'AMC',
        //     };
        //   }
        //   return null;
        // }).where((item) => item != null).toList(),
        'amc_items': [],
        'chassis_num': widget.chassisNum,
        'date_of_booking': formattedDate,
        'last_service_date': widget.lastServiceDate,
        'last_service_km': '${widget.lastServiceKm}',
        'services': serviceList.map((service) {
          String type = service['Under'] == 'AMC'
              ? 'AMC'
              : (service['Under'] == 'Warranty' ? 'Warranty' : 'N/A');
          return {
            'name': service['Service'],
            'price': service['Amount'],
            'type': type,
          };
        }).toList(),
        'total_cost': totalAmount,
        'warranty_items': [],
        'workshop_id': selectedWorkshopId,
      };

      // Map<String, dynamic> staticData = {
      //   'amc_items': [],
      //   'chassis_num': 'CHVH002',
      //   'date_of_booking': '2023-09-18',
      //   'last_service_date': '2023-09-18',
      //   'last_service_km': 70001,
      //   'services': [
      //     {
      //       'name': 'Speedometer',
      //       'price': 699.50,
      //       'type': 'N/A',
      //     },
      //   ],
      //   'total_cost': totalAmount,
      //   'warranty_items': [],
      //   'workshop_id': selectedWorkshopId,
      // };


      //print(jsonEncode(staticData));

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse('https://backendev.automovill.com/api/v1/invoices/addNew'),
        headers: headers,
        body: jsonEncode(postData),
      );

      if(response.statusCode == 200){
        final Map<String, dynamic> jsonRes = jsonDecode(response.body);
        invoiceId = jsonRes['invoice_id'];
      }
  }


  List<String> dropDownOptions = [
    'Axle Nut',
    'Bag Hook',
    'Battery 12V',
    'Battery Clamp',
    'Battery Wire Per Piece',
    'Bearing Set',
    'Brake Lever LH',
    'Brake Lever RH',
    'Brake Shoe SET',
    'Bulb',
    'Butterfly Glass',
    'Controller 48 - 60 V',
    'Door Lock',
    'Flasher',
    'Floor Mat',
    'Front Alloy Wheel',
    'Front Axle Spacer LH',
    'Front Axle Spacer RH',
    'Front Axle',
    'Front Center Cover Air Mess',
    'Front Nozzle',
    'Front Winker LH',
    'Front Winker RH',
    'Fuse',
    'Handle Bar Cover Air Mess',
    'Handle Bar Nut',
    'Handle Bar',
    'Handle Grip',
    'Head Light',
    'Headlight Cover BLUE',
    'Headlight Cover GOLD',
    'Headlight Cover RED',
    'Headlight Cover WHITE',
    'Headlight Decoration',
    'Headlight Switch',
    'High Low Beam Switch',
    'Horn Switch',
    'Horn',
    'Ignition Lock',
    'Inspection Charges',
    'Labour Charges',
    'Main Stand Grommet',
    'Main Stand Spring',
    'Main Stand',
    'MCB',
    'Mirror',
    'Mudguard' 'Nut M6',
    'Read Number Plate',
    'Rear Fender',
    'Rear Inner Fender',
    'Rear Nozzle',
    'Rear Suspension Bolt',
    'Rear Suspension Nut',
    'Rear Suspension Set',
    'Rectangular Reflector',
    'Relay',
    'Reverse Buzzer',
    'Round Reflector',
    'Screw M5',
    'Seat Latch',
    'Seat Lock Socket',
    'Seat Rest Cover',
    'Seat Resting Body',
    'Side Rail LH BLUE',
    'Side Rail LH GOLD',
    'Side Rail LH RED',
    'Side Rail LH WHITE',
    'Side Rail RH BLUE',
    'Side Rail RH GOLD',
    'Side Rail RH RED',
    'Side Rail RH WHITE',
    'Side Stand Spring',
    'Side Stand',
    'Speedometer',
    'Step Bolt',
    'Swing Arm Axle',
    'Swing Arm',
    'Switch',
    'Tail Light Bulb 12V 5W',
    'Tail Light',
    'Throttle',
    'Tool Box Inner LH',
    'Tool Box Inner RH',
    'Tool Box',
    'Tool Kit Bag',
    'Tool Kit',
    'T-york Assy',
    'Type 3X10 Front',
    'Type 3X10 Rear',
    'Under Cover',
    'VIN Cover',
    'Windshield Glass',
    'Winker Bulb 12V 10/5',
    'Winker Switch',
    'Wire Harness',
  ];

  String? selectedDropDownOption;

  Map<String, dynamic> vehicleDetails = {
    'Chassis Number': '',
    'Vehicle Make': '',
    'Vehicle Model': '',
    'Fuel Type': '',
    'Date of booking': DateTime.now(),
  };

  String? selectedScope;
  String? scopeOfWork = '';
  double? amount;
  List<Map<String, dynamic>> serviceList = [];
  String? selectedWorkshopId;
  List<String> workshopIds = ['workshop01', 'workshop02', 'workshop03'];
  double totalAmount = 0;
  bool isExpanded = false;
  String? initialSelectedScope;

  @override
  void initState() {
    super.initState();
    initialSelectedScope = null;
    _amountController = TextEditingController();

    vehicleDetails['Chassis Number'] = widget.chassisNum;
    vehicleDetails['Vehicle Make'] = widget.vehicleMake;
    vehicleDetails['Vehicle Model'] = widget.vehicleModel;
    vehicleDetails['Fuel Type'] = widget.fuelType;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF243C63),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF243C63),
          elevation: 0,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xFF243C63),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: vehicleDetails.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              '${entry.value}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Workshop ID',
                        style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 1.0),
                        child: DropdownButton<String>(
                          value: selectedWorkshopId,
                          items: workshopIds.map((workshopId) {
                            return DropdownMenuItem<String>(
                              value: workshopId,
                              child: Text(
                                workshopId,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedWorkshopId =
                                  value; // Update the Workshop ID in the map
                            });
                          },
                          hint: Text('Select Workshop ID'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(selectedScope ?? 'Scope of work',
                                    style: TextStyle(
                                        color: selectedScope == null
                                            ? Colors.grey
                                            : Colors.black)),
                              ),
                            ),
                            if (isExpanded)
                              Column(
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Search...',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDropDownOption = value;
                                      });
                                    },
                                  ),
                                  // ignore: sized_box_for_whitespace
                                  Container(
                                    height: 200,
                                    // Set the maximum height for the options
                                    child: ListView(
                                      children: [
                                        ..._buildMatchingOptions(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text(
                    'AMC',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: amcSelected,
                  onChanged: (value) {
                    setState(() {
                      amcSelected = value!;
                      //warrantySelected = !value;
                      //updateUnderSelection();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text(
                    'Warranty',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: warrantySelected,
                  onChanged: (value) {
                    setState(() {
                      warrantySelected = value!;
                      //amcSelected = !value;
                      //updateUnderSelection();
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _amountController,
                  onChanged: (value) {
                    amount = double.tryParse(value);
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter amount',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (amount != null) {
                        if (amcSelected) {
                          serviceList.add({
                            'Service': selectedScope,
                            'Under': 'AMC',
                            'Amount': amount!,
                          });
                        } else if (warrantySelected) {
                          serviceList.add({
                            'Service': selectedScope,
                            'Under': 'Warranty',
                            'Amount': amount!,
                          });
                        } else {
                          serviceList.add({
                            'Service': selectedScope,
                            'Under': 'N/A',
                            'Amount': amount!,
                          });
                        }
                        totalAmount += amount!;
                        selectedScope = initialSelectedScope;
                        print(_amountController.text);
                        _amountController.clear();
                      }
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Add'),
                ),
                const SizedBox(height: 20.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: serviceList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Service',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Under',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      );
                    }
                    final service = serviceList[index - 1];
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                service['Service'].toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                service['Under'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                service['Amount'].toString(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const Divider(
                  color: Colors.white,
                ),
                ListTile(
                  title: const Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: Text(
                    '$totalAmount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    generateInvoice(context);
                    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

                    final invoiceItems = serviceList.map((service) {
                      String type = service['Under'] == 'AMC' ? 'AMC' : (service['Under'] == 'Warranty' ? 'Warranty' : 'N/A');
                      return InvoiceItem(description: service['Service'], date: date, under: type, unitPrice: service['Amount'] as double);
                    }).toList();
                    final invoice = Invoice(
                        info: InvoiceInfo(number: invoiceId, date: date, chassisNum: widget.chassisNum, vMake: widget.vehicleMake, vModel: widget.vehicleModel, kmDrive: '${widget.lastServiceKm}', workshop: selectedWorkshopId, ),
                        items: invoiceItems,
                    );

                    final pdfFile = await PdfInvoiceApi.generate(invoice);
                    PdfApi.openFile(pdfFile);
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    'Generate Invoice',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMatchingOptions() {
    List<Widget> widgets = [];
    List<String> matchingOptions = [];

    for (var option in dropDownOptions) {
      if (option
          .toLowerCase()
          .contains(selectedDropDownOption?.toLowerCase() ?? '')) {
        matchingOptions.add(option);
      }
    }

    widgets.addAll(
      matchingOptions.map((option) {
        return ListTile(
          title: Text(option),
          onTap: () {
            setState(() {
              selectedScope = option;
              isExpanded = false;
            });
          },
        );
      }),
    );

    for (var option in dropDownOptions) {
      if (!matchingOptions.contains(option)) {
        widgets.add(Container(height: 0));
      }
    }

    return widgets;
  }


}
