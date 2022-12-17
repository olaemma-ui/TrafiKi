import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:trafiki/Constant.dart';
import 'package:trafiki/Controller/DestinationController.dart';
import 'package:trafiki/Utils.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = Get.put(DestinationController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: (Get.arguments['isTraffic'])
                    ? LatLng(Get.arguments["traffic"][0]['latitude'],
                        Get.arguments["traffic"][0]['longitude'])
                    : LatLng(Get.arguments["src"]['lat'],
                        Get.arguments["src"]['long']),
                zoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/olaemma4213/clbqygy18002t14ms151xzkks/tiles/256/{z}/{x}/{y}@2x?access_token=${Constant.ACCESS_TOKEN}",
                  additionalOptions: const {
                    'id': Constant.STYLE_ID,
                    'accessToken': Constant.ACCESS_TOKEN,
                  },
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      strokeWidth: 4,
                      borderColor: Colors.black,
                      points: (Get.arguments['isTraffic'])
                          ? List.generate(
                              Get.arguments['traffic'].length,
                              (index) => LatLng(
                                  Get.arguments['traffic'][index]['latitude'],
                                  Get.arguments['traffic'][index]['longitude']))
                          : List.generate(
                              Get.arguments['direction']['points'].length,
                              (i) => LatLng(
                                  Get.arguments['direction']['points'][i]
                                      ['latitude'],
                                  Get.arguments['direction']['points'][i]
                                      ['longitude'])),
                      color: (Get.arguments['isTraffic'])
                          ? Colors.redAccent
                          : Colors.blueAccent,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                        point: (Get.arguments['isTraffic'])
                            ? LatLng(Get.arguments["traffic"][0]['latitude'],
                                Get.arguments["traffic"][0]['longitude'])
                            : LatLng(Get.arguments["src"]['lat'],
                                Get.arguments["src"]['long']),
                        builder: (context) => (Get.arguments['isTraffic'])
                            ? const CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.directions_car,
                                  color: Colors.red,
                                ),
                              )
                            : const Icon(
                                Icons.location_history,
                                color: Colors.white,
                              )),
                    Marker(
                        point: (Get.arguments['isTraffic'])
                            ? LatLng(
                                Get.arguments["traffic"]
                                        [(Get.arguments["traffic"].length - 1)]
                                    ['latitude'],
                                Get.arguments["traffic"]
                                        [(Get.arguments["traffic"].length - 1)]
                                    ['longitude'])
                            : LatLng(Get.arguments["dst"]['lat'],
                                Get.arguments["dst"]['long']),
                        builder: (context) => (Get.arguments['isTraffic'])
                            ? const CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.directions_car,
                                  color: Colors.red,
                                ),
                              )
                            : const Icon(
                                Icons.home_work_rounded,
                                color: Colors.white,
                              )),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: (!Get.arguments['isTraffic'])?Container(
                padding: const EdgeInsets.all(12.0),
                width: Utils.max_min_width(context, max: 500, min: 300),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Row(
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.share_location_sharp,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 90,
                            width: 4,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                        const Icon(
                          Icons.share_location_sharp,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 400,
                            child: Ink(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "${Get.arguments['src']['title']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 107, 107, 107)),
                                ),
                              ),
                            ),
                          ),
                          // Obx(
                          //   () => Row(
                          //     children: [
                          //       Checkbox(
                          //           value: _controller.enable.value,
                          //           onChanged: (value) {
                          //             _controller.enable.value = value!;
                          //           }),
                          //       Text("Use current location"),
                          //     ],
                          //   ),
                          // ),

                          SizedBox(
                            // height: 40,
                            child: Row(
                              children: [
                                Icon(Icons.av_timer_rounded),
                                Text(
                                    "${_controller.getTime(Get.arguments['direction']['summary']['travelTimeInSeconds'])}")
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            // height: 40,
                            child: Row(
                              children: [
                                Icon(Icons.traffic_outlined),
                                Text(
                                    "${_controller.getTime(Get.arguments['direction']['summary']['trafficDelayInSeconds'])}")
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            // height: 40,
                            child: Row(
                              children: [
                                Icon(Icons.directions_outlined),
                                Text(
                                    "${(Utils.roundDouble(value: (Get.arguments['direction']['summary']['lengthInMeters'] / 1000), places: 2))}KM")
                              ],
                            ),
                          ),
                          const SizedBox(height:8),
                          SizedBox(
                            width: 400,
                            child: Ink(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "${Get.arguments['dst']['title']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 107, 107, 107)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ):const SizedBox(),
            )
          ],
        ),
      ),
    ));
  }
}
