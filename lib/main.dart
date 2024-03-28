

import 'package:amcdemo/provider/AuthProvider.dart';
import 'package:amcdemo/provider/WorkshopProvider.dart';
import 'package:amcdemo/provider/chassisControllerProvider.dart';
import 'package:amcdemo/provider/vehicle_details_provider.dart';
import 'package:amcdemo/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WorkshopProvider()),
        ChangeNotifierProvider(create: (context) => ChassisControllerProvider()),
        ChangeNotifierProvider(create: (context) => VehicleDetailsProvider())
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
