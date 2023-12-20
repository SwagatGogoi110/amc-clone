import 'package:amcdemo/details/basic_details_list.dart';
import 'package:amcdemo/provider/vehicle_details_provider.dart';
import 'package:amcdemo/screens/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:amcdemo/constants.dart';
import 'package:provider/provider.dart';

class BasicDetailsScreen extends StatelessWidget {
  final String? basicDetailsId;

  const BasicDetailsScreen({Key? key, this.basicDetailsId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final vehicleDetailsProvider = Provider.of<VehicleDetailsProvider>(context);
    //final vehicleDetails = vehicleDetailsProvider.vehicleDetails;

    print(basicDetailsId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: Text("Back".toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium),
      ),
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgYellow.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Body(
          basicDetailsId: basicDetailsId,
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final String? basicDetailsId;

  const Body({Key? key, this.basicDetailsId}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: size.height * 0.8,
          decoration: const BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                height: size.height * 0.75,
                width: size.width,
                //color: Colors.black,
                child: TechSpecPopup(
                  basicDetailsId: basicDetailsId,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}