import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController chassisController = TextEditingController();

  bool showViewMore = true;
  bool amcValid = true;
  bool warrantyValid = true;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _buildBottom(MediaQuery.of(context).size),
    );
  }

  Widget _buildBottom(Size mediaSize) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: mediaSize.height,
        ),
        child: Stack(
          children: [
            Container(
              height: mediaSize.height * 0.5,
              width: mediaSize.width,
              decoration: BoxDecoration(
                color: const Color(0xFF243C63),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            Container(
              height: mediaSize.height,
              width: mediaSize.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bgYellow.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaSize.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Search Container
                  Padding(
                    padding: EdgeInsets.all(mediaSize.height * 0.01),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: chassisController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Vehicle Chassis Number',
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle search functionality
                            debugPrint("ChassisNumber: ${chassisController.text}");
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Details Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: mediaSize.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: EdgeInsets.only(
                        top: mediaSize.height * 0.03, bottom: mediaSize.height * 0.015),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: showViewMore,
                            child: _buildDetailsBlock('Basic Details', [
                              'Owner',
                              'Phone No',
                              'Chassis No',
                              'Registration Date',
                              'Vehicles Make',
                              'Vehicles Model',
                              'Fuel Type',
                            ]),),
                        // Basic Details


                        // AMC Details
                        Visibility(
                          visible: amcValid, // Replace with your own condition
                          child: _buildDetailsBlock('AMC Details', []),
                        ),

                        // Warranty Details
                        Visibility(
                          visible: warrantyValid, // Replace with your own condition
                          child: _buildDetailsBlock('Warranty Details', []),
                        ),

                        // Servicing Details
                        Visibility(
                          visible: showViewMore, // Replace with your own condition
                          child: _buildDetailsBlock('Servicing Details', [
                            'Last Service Date',
                            'Last Service Kilometer',
                          ]),
                        ),
                      ],
                    ),
                  ),

                  // Go to Booking Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle go to booking functionality
                    },
                    child: Text(
                      'Go To Booking',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      minimumSize: Size(mediaSize.width * 0.4, mediaSize.width * 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDetailsBlock(String title, List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(title),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: details.map((detail) => Text(detail)).toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('View More'),
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
                  style: TextStyle(fontSize: 16),
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
