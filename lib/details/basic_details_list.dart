import 'package:amcdemo/constants.dart';
import 'package:flutter/material.dart';

class TechSpecPopup extends StatelessWidget {
  const TechSpecPopup({super.key});
  @override
  Widget build(BuildContext context) {
    // Placeholder data
    List<Map<String, String>> techSpecsLeft = [
      {"title": "Rated Power", "value": "100W"},
      {"title": "Peak Power", "value": "120W"},
      {"title": "Seat Height", "value": "75 cm"},
      {"title": "Loading Capacity", "value": "150 kg"},
      {"title": "Speedometer", "value": "Digital"},
      {"title": "Battery Type", "value": "Lithium-ion"},
      {"title": "Controller", "value": "Integrated"},
    ];

    List<Map<String, String>> techSpecsRight = [
      {"title": "Brake System", "value": "Disc brake"},
      {"title": "Dimensions", "value": "1200 x 700 x 1000 mm"},
      {"title": "Tyre", "value": "Tubeless"},
      {"title": "Charging Time", "value": "4-6 hours"},
      {"title": "Charger Spec", "value": "48V, 20A"},
      {"title": "Voltage", "value": "48V"},
      {"title": "Suspension", "value": "Front and rear"},
    ];

    List<Map<String, String>> performanceSpecsLeft = [
      {"title": "Range/Charge", "value": "60 km"},
      {"title": "Ground Clearance", "value": "150 mm"},
      {"title": "ARAI/ICAT Approved", "value": "Yes"},
      {"title": "Floor Mat", "value": "Rubber"},
      {"title": "Top Speed", "value": "45 km/h"},
      {"title": "Wheel", "value": "Alloy"},
      {"title": "Headlight", "value": "LED"},
    ];

    List<Map<String, String>> performanceSpecsRight = [
      {"title": "Back Light", "value": "LED"},
      {"title": "Brake Lever", "value": "Alloy"},
      {"title": "Battery Warranty", "value": "2 years"},
    ];

    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Technical Specifications
            const Text(
              "Technical Specifications",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                color: kPrimaryColor
              ),
            ),
            const SizedBox(height: 20),
            // Tech Specs
            ...techSpecsLeft.map((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item["value"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
            ...techSpecsRight.map((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item["value"]!,
                    style: const TextStyle(
                      fontSize: 12,
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Performance Specs
            ...performanceSpecsLeft.map((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item["value"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
            ...performanceSpecsRight.map((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item["value"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        )
    );
  }
}
