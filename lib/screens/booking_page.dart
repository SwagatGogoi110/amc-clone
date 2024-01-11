import 'package:amcdemo/screens/details_page.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late TextEditingController _amountController = TextEditingController();
  bool amcSelected = false;
  bool warrantySelected = false;

  List<String> dropDownOptions = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
    'Option 6',
    'Option 7',
    'Option 12',
  ];

  Map<String, String> optionToServiceType = {
    'Option 1': 'AMC',
    'Option 2': 'Repair',
    'Option 3': 'AMC',
    // Add more mappings as needed
  };
  String? selectedDropDownOption;

  Map<String, dynamic> vehicleDetails = {
    'Chassis Number': '123456',
    'Vehicle Make': 'Honda',
    'Vehicle Model': 'Civic',
    'Fuel Type': 'Petrol',
    'Date of booking': DateTime.now(),
  };

  String? selectedScope;
  String? scopeOfWork = '';
  double? amount;
  List<Map<String, dynamic>> serviceList = [];
  double totalAmount = 0;
  bool isExpanded = false;
  String? initialSelectedScope;

  @override
  void initState() {
    super.initState();
    initialSelectedScope = null;
    _amountController = TextEditingController();
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(),
                ),
              );
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
                                    height:
                                    200,
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
                    'AMC', style: TextStyle(color: Colors.white),),
                  value: amcSelected,
                  onChanged: (value) {
                    setState(() {
                      amcSelected = value!;
                      warrantySelected = !value;
                      //updateUnderSelection();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text(
                    'Warranty', style: TextStyle(color: Colors.white),),
                  value: warrantySelected,
                  onChanged: (value) {
                    setState(() {
                      warrantySelected = value!;
                      amcSelected = !value;
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
                          selectedScope = initialSelectedScope;
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
                  onPressed: () {},
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
        String serviceType = optionToServiceType[option] ?? '';
        return ListTile(
          title: Text('$option - $serviceType'),
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