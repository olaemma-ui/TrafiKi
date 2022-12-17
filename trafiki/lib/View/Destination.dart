import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:trafiki/Controller/DestinationController.dart';
import 'package:trafiki/Utils.dart';
import 'package:trafiki/View/Search.dart';

class Destination extends StatefulWidget {
  const Destination({Key? key}) : super(key: key);

  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  final _controller = Get.put(DestinationController());

  var icons = {
    "frc": const Icon(Icons.add_road_sharp),
    "currentSpeed": const Icon(Icons.directions_car_outlined),
    "freeFlowSpeed": const Icon(
      Icons.speed_rounded,
    ),
    "currentTravelTime": const Icon(
      Icons.av_timer_sharp,
    ),
    'roadClass': const Icon(Icons.edit_road_rounded),
    "freeFlowTravelTime": const Icon(Icons.watch_later_outlined),
    "roadClosure": const Icon(Icons.door_sliding_outlined),
    "confidence": const Icon(Icons.percent_rounded),
  };

  bool _clicked = false;

  final frc = {
    "FRC0": "Motorway, freeway or other major road",
    "FRC1": "Major road, less important than a motorway",
    "FRC2": "Other major road",
    "FRC3": "Secondary road",
    "FRC4": "Local connecting road",
    "FRC5": "Local road of high importance",
    "FRC6": "Local road",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Preview Traffic",
          style: TextStyle(fontFamily: "apple"),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 400,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.share_location_sharp,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Ink(
                              height: 60,
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
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => const Search(
                                            type: "src",
                                          ));
                                },
                                child: Ink(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Obx(
                                        () => Text(
                                          _controller.src['title'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 98, 98, 98)),
                                        ),
                                      )),
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
                            const SizedBox(
                              height: 60,
                            ),
                            SizedBox(
                              width: 400,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => const Search(
                                            type: "dst",
                                          ));
                                },
                                child: Ink(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Obx(
                                      () => Text(
                                        _controller.dst['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 107, 107, 107)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: TextButton(
                        onPressed: () async {
                          if ((_controller.src.value['lat'] != 0 &&
                                  _controller.src.value['long'] != 0) &&
                              _controller.dst.value['lat'] != 0 &&
                              _controller.dst.value['long'] != 0) {
                            _controller.preview.value = false;
                            _controller.trafficLoading.value = true;
                            // Get.toNamed("/map");
                            _controller.traffic.value = await _controller
                                .trafficDetails(
                                    lat: _controller.dst.value['lat'],
                                    long: _controller.dst.value['long'])
                                .then((value) => value);
                            _controller.trafficLoading.value = false;
                            _controller.preview.value = true;
                          } else {
                            showCupertinoDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      content: const Text(
                                          "Select choose / select source and destination"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(context);
                                            },
                                            child: const Text("OK"))
                                      ],
                                    )));
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Preview",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: Colors.black,
              thickness: 2,
              height: 0,
            ),
            Obx(() => Visibility(
                visible: _controller.trafficLoading.value,
                child: const LinearProgressIndicator(
                  minHeight: 2,
                ))),
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Obx(
              () => (_controller.traffic.isNotEmpty)
                  ? (_controller.traffic['connect'])
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.remove_road_rounded),
                                        Text((_controller.traffic.value['data']
                                                    ['flowSegmentData']
                                                ['roadClosure'])
                                            ? 'Road Status: CLOSED'
                                            : 'Road Status: OPENED')
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Ink(
                                        height: 20,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.edit_road_rounded),
                                        Text(
                                            ('Road Class: ${frc[_controller.traffic.value['data']['flowSegmentData']['frc']]}'))
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Ink(
                                        height: 20,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.speed_rounded,
                                        ),
                                        Text(
                                            'Free Flow Speed: ${_controller.traffic.value['data']['flowSegmentData']['freeFlowSpeed']} kmph')
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Ink(
                                        height: 20,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.directions_car_outlined),
                                        Text(
                                            'Current Speed: ${_controller.traffic.value['data']['flowSegmentData']['currentSpeed']} kmph')
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Ink(
                                        height: 20,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                         const Icon(Icons.watch_later_outlined),
                                        Text(
                                            'Free Flow Travel Time: ${_controller.getTime(_controller.traffic.value['data']['flowSegmentData']['freeFlowTravelTime'])}')
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Ink(
                                        height: 20,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.av_timer_sharp,
                                        ),
                                        Text(
                                            'Current Travel Time: ${_controller.getTime(_controller.traffic.value['data']['flowSegmentData']['currentTravelTime'])}')
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Ink(
                                        height: 20,
                                        width: 4,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.percent_rounded),
                                        Text(
                                            'Data Accuraccy: ${(_controller.traffic.value['data']['flowSegmentData']['confidence'] >= 1) ? '100%' : '60%'}')
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      : Text("Something went wrong")
                  : const SizedBox(),
            )))
          ],
        ),
      ),
      floatingActionButton: Obx(() => Visibility(
            visible: _controller.preview.value,
            child: SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Obx(() => AnimatedPositioned(
                      right: 4,
                      bottom: _controller.pos1.value,
                      duration: const Duration(milliseconds: 250),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: Colors.black),
                        child: IconButton(
                          onPressed: () async {
                            await Utils.loading(context,
                                action: () async => _controller.getDirections(
                                    src: _controller.src.value,
                                    dst: _controller.dst.value));
                            Get.toNamed("/map", arguments: {
                              'isTraffic': false,
                              "direction": _controller.direction.value['data']
                                  ['routes'][0]['legs'][0],
                              "src": _controller.src.value,
                              "dst": _controller.dst.value
                            });
                          },
                          color: Colors.white,
                          icon: Icon(Icons.directions_outlined),
                        ),
                      ))),
                  Obx(() => AnimatedPositioned(
                      right: 4,
                      bottom: _controller.pos2.value,
                      duration: const Duration(milliseconds: 250),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: Colors.black),
                        child: IconButton(
                          onPressed: () {
                            // log("${_controller.traffic['data']['flowSegmentData']['coordinates']['coordinate']}");
                            Get.toNamed("/map", arguments: {
                              'isTraffic': true,
                              "traffic": _controller.traffic['data']
                                      ['flowSegmentData']['coordinates']
                                  ['coordinate'],
                              "src": _controller.src.value,
                              "dst": _controller.dst.value
                            });
                          },
                          color: Colors.white,
                          icon: Icon(Icons.traffic_outlined),
                        ),
                      ))),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: FloatingActionButton(
                        onPressed: () {
                          // log("before ${_controller.pos1.value}");
                          (_clicked)
                              ? {
                                  _controller.pos1.value = 130,
                                  _controller.pos2.value = 70
                                }
                              : {
                                  _controller.pos1.value = 4,
                                  _controller.pos2.value = 4
                                };
                          _clicked = !_clicked;
                          // log("${_controller.pos.value}");
                        },
                        backgroundColor: Colors.black,
                        child: Icon(Icons.map_outlined),
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
