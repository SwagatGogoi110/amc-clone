import 'package:amcdemo/details/basic_details_list.dart';
import 'package:amcdemo/screens/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:amcdemo/constants.dart';

class BasicDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: kDefaultPadding),
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailsScreen()));
          },
        ),
        centerTitle: false,
        title: Text("Back".toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium),
      ),
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgYellow.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: size.height * 0.8,
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
                height: size.height * 0.75,
                width: size.width,
                //color: Colors.black,
                child: TechSpecPopup(),
              )
            ],
          ),
        )
      ],
    );
  }
}