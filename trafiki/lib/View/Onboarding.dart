import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trafiki/Controller/OnboardingController.dart';
import 'package:trafiki/Utils.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage("asset/car.jfif"), fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(117, 0, 0, 0),
                  // image: DecorationImage(
                  //     image: AssetImage("asset/car.jfif"), fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      child: Text(
                        "TraffiKi",
                        style: TextStyle(
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                  color: Color.fromARGB(255, 65, 52, 52),
                                  blurRadius: 20)
                            ],
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            fontFamily: "segeo"),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Choose the right path for your trip and Monitor your trip",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "segeo",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ]),
                        SizedBox(height: 20,),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed("/destination");
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                        child: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
