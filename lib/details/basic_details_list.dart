import 'dart:convert';

import 'package:amcdemo/constants.dart';
import 'package:amcdemo/provider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TechSpecPopup extends StatefulWidget {
  final String? basicDetailsId;
  const TechSpecPopup({super.key, this.basicDetailsId});

  @override
  State<TechSpecPopup> createState() => _TechSpecPopupState();
}

class _TechSpecPopupState extends State<TechSpecPopup> {

  Map<String, dynamic>? specs;

  Future<void> fetchSpecs(String id) async {
    final apiUrl = 'http://192.168.1.2:8080/api/v1/basic/$id';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.jwtToken;

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final res = await http.get(Uri.parse(apiUrl), headers: headers);
    final Map<String, dynamic> resData = jsonDecode(res.body);

    setState(() {
      specs = resData;
    });

    print('API Response: ${res.body}');
    print(res.statusCode);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSpecs(widget.basicDetailsId!);
  }
  @override
  Widget build(BuildContext context) {
    print('Basic details id: ${widget.basicDetailsId}');
    // Placeholder data
    List<Map<String, String>> techSpecs = specs != null ? [
      {"title": "Rated Power", "value": specs!["rated_power"]},
      {"title": "Peak Power", "value": specs!["peak_power"]},
      {"title": "Seat Height", "value": specs!["seat_height"]},
      {"title": "Loading Capacity", "value": specs!["loading_capacity"]},
      {"title": "Speedometer", "value": specs!["speedometer"]},
      {"title": "Battery Type", "value": specs!["battery_type"]},
      {"title": "Controller", "value": specs!["controller"]},
      {"title": "Brake System", "value": specs!["brake_system"]},
      {"title": "Dimensions", "value": specs!["dimensions"]},
      {"title": "Tyre", "value": specs!["tyre"]},
      {"title": "Charging Time", "value": specs!["charging_time"]},
      {"title": "Charger Spec", "value": specs!["charger_specs"]},
      {"title": "Voltage", "value": specs!["voltage"]},
      {"title": "Suspension", "value": specs!["suspension"]},
    ] : [
      {"title": "Rated Power", "value": "null"},
      {"title": "Peak Power", "value": "null"},
      {"title": "Seat Height", "value": "null"},
      {"title": "Loading Capacity", "value": "null"},
      {"title": "Speedometer", "value": "null"},
      {"title": "Battery Type", "value": "null"},
      {"title": "Controller", "value": "null"},
      {"title": "Brake System", "value": "null"},
      {"title": "Dimensions", "value": "null"},
      {"title": "Tyre", "value": "null"},
      {"title": "Charging Time", "value": "null"},
      {"title": "Charger Spec", "value": "null"},
      {"title": "Voltage", "value": "null"},
      {"title": "Suspension", "value": "null"},
    ];

    List<Map<String, String>> performanceSpecs = specs != null ? [
      {"title": "Range/Charge", "value": specs!["mileage"]},
      {"title": "Ground Clearance", "value": specs!["ground_clearance"]},
      {"title": "ARAI/ICAT Approved", "value": specs!["icat"]},
      {"title": "Floor Mat", "value": specs!["floor_mat"]},
      {"title": "Top Speed", "value": specs!["top_speed"]},
      {"title": "Wheel", "value": specs!["wheel"]},
      {"title": "Headlight", "value": specs!["headlight"]},
      {"title": "Back Light", "value": specs!["backlight"]},
      {"title": "Brake Lever", "value": specs!["brake_lever"]},
      {"title": "Battery Warranty", "value": specs!["battery_warranty"]},
    ] : [
      {"title": "Range/Charge", "value": "null"},
      {"title": "Ground Clearance", "value": "null"},
      {"title": "ARAI/ICAT Approved", "value": "null"},
      {"title": "Floor Mat", "value": "null"},
      {"title": "Top Speed", "value": "null"},
      {"title": "Wheel", "value": "null"},
      {"title": "Headlight", "value": "null"},
      {"title": "Back Light", "value": "null"},
      {"title": "Brake Lever", "value": "null"},
      {"title": "Battery Warranty", "value": "null"},
    ];

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Technical Specifications
        const Text(
          "Technical Specifications",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: kPrimaryColor),
        ),
        const SizedBox(height: 20),
        // Tech Specs
        ...techSpecs.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["title"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item["value"]!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
        const SizedBox(height: 20),
        // Performance Specifications
        const Text(
          "Performance Specifications",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 20),
        // Performance Specs
        ...performanceSpecs.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["title"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item["value"]!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    ));
  }
}
