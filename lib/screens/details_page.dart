import 'dart:convert';

import 'package:amcdemo/details/amc_details_list.dart';
import 'package:amcdemo/details/service_details_list.dart';
import 'package:amcdemo/provider/AuthProvider.dart';
import 'package:amcdemo/provider/chassisControllerProvider.dart';
import 'package:amcdemo/provider/vehicle_details_provider.dart';
import 'package:amcdemo/screens/booking_page.dart';
import 'package:amcdemo/screens/next_details/basic_details.dart';
import 'package:amcdemo/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'next_details/amc_details.dart';
import 'next_details/service_details.dart';
import 'next_details/warranty_details.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController chassisController;
  late ChassisControllerProvider chassisControllerProvider;

  String? jwtToken;

  bool showViewMore = true;
  bool amcValid = true;
  bool warrantyValid = true;
  bool searchButtonClicked = false;

  double deviceHeight = 0.0;
  double deviceWidth = 0.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    chassisController = TextEditingController();
    chassisControllerProvider =
        Provider.of<ChassisControllerProvider>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        deviceHeight = size.height;
        deviceWidth = size.width;
      });

      if (searchButtonClicked) {
        fetchVehicleDetails(chassisControllerProvider.controller.text);
      }
    });
  }

  Map<String, dynamic>? vehicleDetails;
  Map<String, dynamic>? initialVehicleDetails;

  Future<void> fetchVehicleDetails(String chassisNum) async {
    debugPrint(chassisNum);
    final apiUrl = 'http://192.168.1.10:8080/api/v1/vehicle/$chassisNum';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProvider.jwtToken;

    print('Jwt Token: $jwtToken');

    debugPrint(apiUrl);
    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final vehicleDetailsProvider =
          Provider.of<VehicleDetailsProvider>(context, listen: false);
      vehicleDetailsProvider.setVehicleDetails(responseData);
      setState(() {
        vehicleDetails = responseData;
        initialVehicleDetails = responseData;
      });
    } else {
      print(
          'Failed to fetch vehicle details. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    //print('API Response: ${response.body}');
    //print(response.statusCode);
  }

  bool _isBasicDetailsAvailable() {
    // Check if vehicleDetails is not null and all required properties are not null
    return vehicleDetails != null &&
        vehicleDetails?['owner'] != null &&
        vehicleDetails?['phone_num'] != null &&
        vehicleDetails?['chassis_num'] != null &&
        vehicleDetails?['reg_date'] != null &&
        vehicleDetails?['make'] != null &&
        vehicleDetails?['model'] != null &&
        vehicleDetails?['fuel_type'] != null;
  }

  bool _isAmcDetailsAvailable(String amcEndDate) {
    DateTime? endDate = DateTime.tryParse(amcEndDate ?? "");
    if (endDate == null) {
      return false;
    }
    DateTime currentDate = DateTime.now();
    return currentDate.isBefore(endDate);
  }

  bool _isWarrantyDetailsAvailable(String warrantyEndDate) {
    DateTime? endDate = DateTime.tryParse(warrantyEndDate ?? "");
    if (endDate == null) {
      return false;
    }
    DateTime currentDate = DateTime.now();
    return currentDate.isBefore(endDate);
  }

  bool _isServiceDetailsAvailable() {
    // Check if service details is not null and all required properties are not null
    return vehicleDetails != null &&
        vehicleDetails?['last_service_date'] != null &&
        vehicleDetails?['last_service_km'] != null;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    var chassisControllerProvider =
        Provider.of<ChassisControllerProvider>(context);
    if (deviceWidth == null) {
      return Container();
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bgYellow.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: deviceHeight * 0.5,
              decoration: const BoxDecoration(
                color: Color(0xFF243C63),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            top: deviceHeight * 0.1,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(deviceHeight * 0.01),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: chassisControllerProvider.controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Vehicle Chassis Number',
                            contentPadding: const EdgeInsets.all(15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              searchButtonClicked = true;
                            });
                            await fetchVehicleDetails(
                                chassisControllerProvider.controller.text);
                            if (chassisControllerProvider
                                .controller.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Fetched details: ${vehicleDetails?['owner'] ?? "N/A"}'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fetched details : N/A'),
                                ),
                              );
                            }

                            // Handle search functionality
                            debugPrint(
                                "ChassisNumber: ${chassisControllerProvider.controller.text}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                          ),
                          child: const Text(
                            'Search',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: deviceWidth * 0.8,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin: EdgeInsets.only(
                        top: deviceHeight * 0.03, bottom: deviceHeight * 0.015),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: showViewMore,
                          child: _buildDetailsBlock(
                            'Basic Details',
                            [
                              'Owner : ${vehicleDetails?['owner']}',
                              'Phone No : ${vehicleDetails?['phone_num']}',
                              'Chassis No : ${vehicleDetails?['chassis_num']}',
                              'Registration Date : ${vehicleDetails?['reg_date']}',
                              'Vehicles Make : ${vehicleDetails?['make']}',
                              'Vehicles Model : ${vehicleDetails?['model']}',
                              'Fuel Type : ${vehicleDetails?['fuel_type']}',
                            ],
                            _isBasicDetailsAvailable(),
                          ),
                        ),
                        Visibility(
                          visible: amcValid,
                          child: _buildDetailsBlock(
                              'AMC Details',
                              [],
                              _isAmcDetailsAvailable(
                                  vehicleDetails?['amc_end_date'] as String? ??
                                      '')),
                        ),
                        Visibility(
                          visible: warrantyValid,
                          child: _buildDetailsBlock(
                              'Warranty Details',
                              [],
                              _isWarrantyDetailsAvailable(
                                  vehicleDetails?['warranty_end'] as String? ??
                                      '')),
                        ),
                        Visibility(
                          visible: showViewMore,
                          child: _buildDetailsBlock(
                              'Servicing Details',
                              [
                                'Last Service Date : ${vehicleDetails?['last_service_date']}',
                                'Last Service Kilometer : ${vehicleDetails?['last_service_km']}'
                              ],
                              _isServiceDetailsAvailable()),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => BookingPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      minimumSize: Size(deviceWidth * 0.4, deviceWidth * 0.12),
                    ),
                    child: const Text(
                      'Go To Booking',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
    );
  }

  Widget _buildDetailsBlock(String title, List<String> details, bool isValid) {
    var chassisControllerProvider =
        Provider.of<ChassisControllerProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title == 'Warranty Details'
                      ? (isValid ? 'Active' : 'Expired')
                      : (isValid ? 'Valid' : 'Invalid'),
                  style: TextStyle(
                    color: isValid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    if (title == 'Basic Details') {
                      if (chassisControllerProvider
                              .controller.text.isNotEmpty &&
                          searchButtonClicked == true) {
                        chassisControllerProvider.setChassisController(
                            chassisControllerProvider.controller.text);
                        String? basicDetailsId =
                            vehicleDetails?['basic_details_id'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BasicDetailsScreen(
                              basicDetailsId: basicDetailsId,
                            ),
                          ),
                        );
                      } else {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            if (chassisControllerProvider.controller.text
                                .trim()
                                .isEmpty) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Please enter the chassis number.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(dialogContext)
                                          .pop(); // Dismiss alert dialog
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Please press enter.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(dialogContext)
                                          .pop(); // Dismiss alert dialog
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      }
                    } else if (title == 'AMC Details') {
                      if (chassisControllerProvider
                              .controller.text.isNotEmpty &&
                          searchButtonClicked == true) {
                        chassisControllerProvider.setChassisController(
                            chassisControllerProvider.controller.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AmcDetailsScreen(
                                chassisNum:
                                    chassisControllerProvider.controller.text),
                          ),
                        );
                      } else {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Please enter the chassis number.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else if (title == 'Warranty Details') {
                      if (chassisControllerProvider
                              .controller.text.isNotEmpty &&
                          searchButtonClicked == true) {
                        chassisControllerProvider.setChassisController(
                            chassisControllerProvider.controller.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WarrantyDetailsScreen(
                                chassisNum:
                                    chassisControllerProvider.controller.text,
                                warrantyStart:
                                    vehicleDetails?['warranty_start']
                                            as String? ??
                                        '',
                                warrantyEnd:
                                    vehicleDetails?['warranty_end']
                                            as String? ??
                                        ''),
                          ),
                        );
                      } else {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Please enter the chassis number.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      if (chassisControllerProvider
                              .controller.text.isNotEmpty &&
                          searchButtonClicked == true) {
                        chassisControllerProvider.setChassisController(
                            chassisControllerProvider.controller.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsScreen(
                                chassisNum:
                                    chassisControllerProvider.controller.text),
                          ),
                        );
                      } else {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Please enter the chassis number.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text('View More'),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details.map(
            (detail) {
              List<String> parts = detail.split(":");
              if (parts.length == 2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        parts[0].trim(),
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        parts[1].trim(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ).toList(),
        ),
      ],
    );
  }
}
