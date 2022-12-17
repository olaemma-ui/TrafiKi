import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trafiki/View/Destination.dart';
import 'package:trafiki/View/Onboarding.dart';
import 'package:trafiki/View/Map.dart';

void main() {
  runApp(const Route());
}

class Route extends StatefulWidget {
  const Route({Key? key}) : super(key: key);

  @override
  State<Route> createState() => _RouteState();
}

class _RouteState extends State<Route> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/": (context) => const Onboarding(),
        "/destination": (context) => const Destination(),
        "/map": (context) => const MapView()
      },
    );
  }
}
