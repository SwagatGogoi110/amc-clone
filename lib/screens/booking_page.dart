import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amcdemo/provider/WorkshopProvider.dart';
import 'package:amcdemo/screens/availablity.dart';
import 'package:amcdemo/screens/details_page.dart';
import 'package:amcdemo/widgets/invoice/api/pdf_api.dart';
import 'package:amcdemo/widgets/invoice/api/pdf_ivoice_api.dart';
import 'package:amcdemo/widgets/invoice/model/invoice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool amcSelected = true;
  bool warrantySelected = true;
  String workshopID = '';
  double selectedItemPrice = 0.0;
  Map<String, double> itemPrices = {};
  String lastSearchValue = '';
  Map<String, String> itemTaxes = {};
  String? taxForSelectedItem;
  String? selectedScope;
  String? scopeOfWork = '';
  double? amount;
  List<Map<String, dynamic>> serviceList = [];
  double totalAmount = 0;
  bool isExpanded = false;
  late int quantity = 1;
  String? initialSelectedScope;
  List<String> dropDownOptions = [];
  String? selectedDropDownOption;
  int _warrantyAvailableCount = 0;
  int _amcAvailableCount = 0;

  final TextEditingController _scopeOfWorkController = TextEditingController();
  late TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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
      'workshop_id': workshopID,
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('https://backendev.automovill.com/api/v1/invoices/addNew'),
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonRes = jsonDecode(response.body);
      invoiceId = jsonRes['invoice_id'];
    }
  }

  Future<void> fetchDropDownOptions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.jwtToken;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
        Uri.parse('https://backendev.automovill.com/api/v1/parts/allParts'),
        headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        dropDownOptions =
            data.map((item) => item['itemName'].toString()).toList();
        itemTaxes = {
          for (var item in data)
            item['itemName'].toString(): item['tax'] as String
        };
        itemPrices = {
          for (var item in data)
            item['itemName'].toString(): item['price'] as double
        };

        print(itemTaxes);
      });
    } else {
      // Handle error
      print('Failed to fetch dropdown options');
    }
  }

  Map<String, dynamic> vehicleDetails = {
    'Chassis Number': '',
    'Vehicle Make': '',
    'Vehicle Model': '',
    'Fuel Type': '',
    'Date of booking': DateTime.now(),
  };


  @override
  void initState() {
    super.initState();
    initialSelectedScope = null;
    _amountController = TextEditingController();
    fetchDropDownOptions();
    taxForSelectedItem = '';
    Future.delayed(Duration.zero, () {
      final workshopProvider =
          Provider.of<WorkshopProvider>(context, listen: false);
      workshopID = workshopProvider.subValue;
      setState(() {});
    });
    vehicleDetails['Chassis Number'] = widget.chassisNum;
    vehicleDetails['Vehicle Make'] = widget.vehicleMake;
    vehicleDetails['Vehicle Model'] = widget.vehicleModel;
    vehicleDetails['Fuel Type'] = widget.fuelType;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    _scopeOfWorkController.text = selectedScope ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _scopeOfWorkController.dispose();
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
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${entry.value}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Workshop ID',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        workshopID,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150.0,
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                    if (!isExpanded) {
                                      lastSearchValue = selectedDropDownOption ?? '';
                                      selectedDropDownOption = null;
                                    } else {
                                      selectedDropDownOption = lastSearchValue;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: isExpanded
                                      ? TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDropDownOption = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Search...',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                                      border: InputBorder.none,
                                    ),
                                  )
                                      : Row(
                                    children: [
                                      Text(
                                        selectedScope ?? 'Scope of work',
                                        style: TextStyle(
                                          color: selectedScope == null ? Colors.grey : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: isExpanded ? 200 : 0,
                              child: Visibility(
                                visible: isExpanded,
                                child: ListView(
                                  children: [
                                    ..._buildMatchingOptions(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'TAX:',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '$taxForSelectedItem %', // Replace with your actual tax percentage
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.288,
                      child: TextField(
                        controller: _amountController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            selectedItemPrice = 0.0;
                          } else {
                            selectedItemPrice = double.tryParse(value) ?? 0.0;
                          }
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.288,
                      child: TextField(
                        controller: _quantityController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            quantity = 1;
                          } else {
                            quantity = int.tryParse(value) ?? 1;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Qty',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (_amountController.text.isNotEmpty) {
                            amount = double.parse(_amountController.text);
                            String? underType;
                            serviceList.add({
                              'Service': selectedScope,
                              'Under': underType ?? 'N/A',
                              'Amount': amount! * quantity,
                              'Description': _descriptionController.text,
                            });
                            totalAmount += amount! * quantity;
                            selectedScope = initialSelectedScope;
                            _amountController.clear();
                            _quantityController.clear();
                            _descriptionController.clear();
                            amount = null;
                            quantity = 1;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Type your description (Optional)',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: serviceList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Service',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Under',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(''),
                            )
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
                                flex: 2,
                                child: Text(
                                  service['Service'].toString(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  service['Under'].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  service['Amount'].toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      totalAmount -= service['Amount'] as double;
                                      serviceList.removeAt(index - 1);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (service['Description'] != null && service['Description'].isNotEmpty)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text(
                                    '${service['Description']}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: Text(
                    '$totalAmount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Availability(
                  scopeOfWork: _scopeOfWorkController.text,
                  chassisNum: widget.chassisNum,
                  onUpdate: (warrantyCount, amcCount) {
                    _warrantyAvailableCount = warrantyCount;
                    _amcAvailableCount = amcCount;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    generateInvoice(context);
                    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    final invoiceItems = serviceList.map((service) {
                      String type = service['Under'] == 'AMC'
                          ? 'AMC'
                          : (service['Under'] == 'Warranty' ? 'Warranty' : 'N/A');
                      String itemName = '${service['Service']}';
                      if (service['Description'] != null && service['Description'].isNotEmpty) {
                        itemName += '\n${service['Description']}';
                      }
                      return InvoiceItem(
                        description: service['Service'],
                        additionalDesc : service['Description'],
                        date: date,
                        under: type,
                        unitPrice: service['Amount'] as double,
                      );
                    }).toList();
                    final invoice = Invoice(
                      info: InvoiceInfo(
                        number: invoiceId,
                        date: date,
                        chassisNum: widget.chassisNum,
                        vMake: widget.vehicleMake,
                        vModel: widget.vehicleModel,
                        kmDrive: '${widget.lastServiceKm}',
                        workshop: workshopID,
                      ),
                      items: invoiceItems,
                    );
                    final pdfFile = await PdfInvoiceApi.generate(invoice);
                    PdfApi.openFile(pdfFile);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    'Generate Invoice',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
        return SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ListTile(
              title: Text(option),
              onTap: () {
                setState(() {
                  selectedScope = option;
                  isExpanded = false;
                  selectedItemPrice = itemPrices[option] ?? 0.0;
                  _amountController.text = selectedItemPrice.toString();
                  taxForSelectedItem = itemTaxes[option] ?? '';
                });
              },
            ),
          ),
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
