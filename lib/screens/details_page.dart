import 'package:amcdemo/details/amc_details_list.dart';
import 'package:amcdemo/details/service_details_list.dart';
import 'package:amcdemo/provider/chassisControllerProvider.dart';
import 'package:amcdemo/screens/next_details/basic_details.dart';
import 'package:amcdemo/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  bool showViewMore = true;
  bool amcValid = true;
  bool warrantyValid = true;

  double deviceHeight = 0.0;
  double deviceWidth = 0.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    chassisController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        deviceHeight = size.height;
        deviceWidth = size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    var chassisControllerProvider = Provider.of<ChassisControllerProvider>(context);
    if (deviceHeight == null || deviceWidth == null) {
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
                          onPressed: () {
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
                                'Owner',
                                'Phone No',
                                'Chassis No',
                                'Registration Date',
                                'Vehicles Make',
                                'Vehicles Model',
                                'Fuel Type',
                              ],
                              showViewMore),
                        ),
                        Visibility(
                          visible: amcValid,
                          child:
                              _buildDetailsBlock('AMC Details', [], !amcValid),
                        ),
                        Visibility(
                          visible: warrantyValid,
                          child: _buildDetailsBlock(
                              'Warranty Details', [], !warrantyValid),
                        ),
                        Visibility(
                          visible: showViewMore,
                          child: _buildDetailsBlock(
                              'Servicing Details',
                              ['Last Service Date', 'Last Service Kilometer'],
                              showViewMore),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle go to booking functionality
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
    var chassisControllerProvider = Provider.of<ChassisControllerProvider>(context);
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
                      if (chassisControllerProvider.controller.text.isNotEmpty) {
                        chassisControllerProvider.setChassisController(chassisControllerProvider.controller.text);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BasicDetailsScreen()));
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
                    } else if (title == 'AMC Details') {
                      if (chassisControllerProvider.controller.text.isNotEmpty) {
                        chassisControllerProvider.setChassisController(chassisControllerProvider.controller.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AmcDetailsScreen(
                                chassisNum: chassisControllerProvider.controller.text),
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
                      if (chassisControllerProvider.controller.text.isNotEmpty) {
                        chassisControllerProvider.setChassisController(chassisControllerProvider.controller.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WarrantyDetailsScreen(
                                chassisNum: chassisControllerProvider.controller.text),
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
                      if (chassisControllerProvider.controller.text.isNotEmpty) {
                        chassisControllerProvider.setChassisController(chassisControllerProvider.controller.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsScreen(
                                chassisNum: chassisControllerProvider.controller.text),
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
          children: details
              .map(
                (detail) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      detail,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
