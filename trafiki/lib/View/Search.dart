import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trafiki/Controller/DestinationController.dart';

class Search extends StatefulWidget {
  final String type;
  const Search({Key? key, required this.type}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = Get.put(DestinationController());
  final _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.locations.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 600,
        child: Column(
          children: [
            TextField(
              onChanged: (value) async {
                _controller.loading.value = true;
                _controller.locations.value =
                    await _controller.searchAddress(value ?? "");
                // log("location= ${_controller.locations.value}");
                _controller.loading.value = false;
              },
              decoration: const InputDecoration(
                hintText: "Search address",
                suffixIcon: Icon(Icons.search),
              ),
            ),
            Obx(() => Visibility(
                visible: _controller.loading.value,
                child: const LinearProgressIndicator())),
            Expanded(child: SingleChildScrollView(child: Obx(
              () {
                // log("location= ${_controller.locations.value}");
                return (_controller.locations.value.isNotEmpty &&
                        _controller.locations.value['connect'])
                    ? Column(
                        children: List.generate(
                            _controller.locations.value['data']['summary']
                                ['numResults'], (index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  var locDts = {
                                    'title':
                                        "${_controller.locations.value['data']['results'][index]['address']['freeformAddress']}-${_controller.locations.value['data']['results'][index]['address']['countrySubdivision']}-${_controller.locations.value['data']['results'][index]['address']['country']}",
                                    'lat': _controller.locations.value['data']
                                        ['results'][index]['position']['lat'],
                                    'long': _controller.locations.value['data']
                                        ['results'][index]['position']['lon'],
                                  };

                                  print(locDts);
                                  if (widget.type == "src") {
                                    _controller.src.forEach((key, value) {
                                      _controller.src[key] = locDts[key];
                                    });
                                    log("src ${_controller.src}");
                                  } else if (widget.type == "dst") {
                                    _controller.dst.forEach((key, value) {
                                      _controller.dst[key] = locDts[key];
                                    });
                                    log("dst ${_controller.dst}");
                                  }
                                  Navigator.of(context).pop();
                                },
                                minVerticalPadding: 4,
                                contentPadding: const EdgeInsets.all(4),
                                title: Text(
                                    "${_controller.locations.value['data']['results'][index]['address']['freeformAddress']}-${_controller.locations.value['data']['results'][index]['address']['countrySubdivision']}-${_controller.locations.value['data']['results'][index]['address']['country']}"),
                              ),
                              const Divider()
                            ],
                          );
                        }),
                      )
                    : Text("-------");
              },
            )))
          ],
        ),
      ),
    );
  }
}
