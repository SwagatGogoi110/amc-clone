import 'package:amcdemo/details/basic_details_list.dart';
import 'package:amcdemo/screens/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:amcdemo/constants.dart';
import '../../details/amc_details_list.dart';

class AmcDetailsScreen extends StatelessWidget {
  final String chassisNum;

  const AmcDetailsScreen({Key? key, required this.chassisNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF243C63),
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: kDefaultPadding),
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DetailsScreen()),
            );
          },
        ),
        centerTitle: false,
        title: Text(
          "Back".toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgYellow.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Body(chassisNum: chassisNum),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final String chassisNum;

  const Body({Key? key, required this.chassisNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String chassis = chassisNum;
    debugPrint('chassisNum: $chassis');
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: size.height * 0.8,
          decoration: const BoxDecoration(
            color: const Color(0xFF243C63),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: size.height * 0.75,
                width: size.width,
                child: AmcDetailsPopup(chassisNum: chassisNum),
              )
            ],
          ),
        )
      ],
    );
  }
}
