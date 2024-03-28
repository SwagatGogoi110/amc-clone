import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../provider/AuthProvider.dart';

class Availability extends StatefulWidget {
  final String scopeOfWork;
  final String chassisNum;
  final Function (int,int) onUpdate;
  const Availability({Key? key, required this.scopeOfWork, required this.chassisNum, required this.onUpdate})
      : super(key: key); // Example string for demonstration

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  String _warrantyAvailability = '';
  String _amcAvailability = '';
  int _warrantyAvailabilityCount = 0;
  int _amcAvailabilityCount = 0;

  @override
  void initState() {
    super.initState();
    // Call API methods to fetch availability data
    _fetchWarrantyAndAMCAvailability(widget.chassisNum, widget.scopeOfWork);
  }

  @override
  void didUpdateWidget(covariant Availability oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scopeOfWork != widget.scopeOfWork) {
      _fetchWarrantyAndAMCAvailability(widget.chassisNum, widget.scopeOfWork);
    }
  }

  Future<void> _fetchWarrantyAndAMCAvailability(String chassisNum, String scope) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.jwtToken;
      final url1 = Uri.parse(
          'https://backendev.automovill.com/api/v1/warranty-availability/availability?chassis_num=$chassisNum&scope=$scope');
      final url2 = Uri.parse(
          'https://backendev.automovill.com/api/v1/amc-availability/availability?chassis_num=$chassisNum&scope=$scope');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response1 = await http.get(url1, headers: headers);
      final response2 = await http.get(url2, headers: headers);

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final Map<String, dynamic> data1 = jsonDecode(response1.body);
        final String available1 = data1['available'].toString();
        final String total1 = data1['total'].toString();
        data1['scope'] = scope;

        print("data1 : $data1");

        final Map<String, dynamic> data2 = jsonDecode(response2.body);
        final String available2 = data2['available'].toString();
        final String total2 = data2['total'].toString();
        data2['scope'] = scope;

        print("data2 : $data2");

        setState(() {
          _warrantyAvailability = '$available1 of $total1';
          _warrantyAvailabilityCount = int.parse(available1);

          _amcAvailability = '$available2 of $total2';
          _amcAvailabilityCount = int.parse(available2);
          print(_warrantyAvailabilityCount);
          print(_amcAvailabilityCount);
        });
        widget.onUpdate(_warrantyAvailabilityCount, _amcAvailabilityCount);
      } else {
        setState(() {
          _warrantyAvailability = ''; // Reset warranty availability if error occurs
          _amcAvailability = ''; // Reset warranty availability if error occurs
        });
      }
    } catch (error) {
      print('Error fetching warranty availability: $error');
    }
  }

  // Example string for demonstration
  @override
  Widget build(BuildContext context) {
    print(widget.chassisNum);
    print(widget.scopeOfWork);
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200], // Background color for the container
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Scope of Work header
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text(
                    'Scope of Work',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Warranty header
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text(
                    'Warranty',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // AMC header
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text(
                    'AMC',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(widget.scopeOfWork, textAlign: TextAlign.center),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    _warrantyAvailability,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    _amcAvailability,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
