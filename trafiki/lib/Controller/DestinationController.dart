import 'dart:developer';

import 'package:get/get.dart';
import 'package:trafiki/Constant.dart';
import 'package:trafiki/Service/Api.dart';

class DestinationController extends GetxController {
  RxMap dst = {}.obs;
  RxMap src = {}.obs;
  RxDouble pos1 = 0.0.obs;
  RxDouble pos2 = 0.0.obs;
  RxBool preview = false.obs;

  DestinationController() {
    setDefault();
  }

  // Search Var
  RxBool loading = false.obs;
  RxMap locations = {}.obs;
  RxInt length = 0.obs;
  RxBool enable = true.obs;

  // Traffic var
  RxMap traffic = {}.obs;
  RxBool trafficLoading = false.obs;

  RxMap direction = {}.obs;
  RxBool directionoading = false.obs;

  setDefault() {
    dst = {"title": "Destination :", "lat": 0, "long": 0}.obs;
    src = {"title": "Source :", "lat": 0, "long": 0}.obs;
  }

  getTime(sec) {
    var min = 0, hr = 0;
    if (sec > 59) {
      min = sec ~/ 60;
      sec = sec % 60;
    }
    if (min > 60) {
      hr = min ~/ 60;
      min = min % 60;
    }
    return '${hr}h-${min}m-${sec}s';
  }

  searchAddress(address) async {
    log("address = $address");

    var response = await Api().get(
        url: '${Constant.SEARCH_API}$address.json',
        param: {"key": Constant.API_KEY}).then((value) => value);

    return response;
  }

  trafficDetails({required lat, required long}) async {
    var response = await Api().get(url: Constant.TRAFFIC_API, param: {
      'point': '$lat,$long',
      "key": Constant.API_KEY,
      "unit": 'kmph'
    }).then((value) => value);
    return response;
  }

  getDirections({required Map src, required Map dst}) async {
    var response = await Api().post(
        url:
            '${Constant.ROUTE_API}/${src['lat']},${src['long']}:${dst['lat']},${src['long']}/json',
        param: {
          "key": Constant.API_KEY,
          "routeRepresentation": "polyline",
          "routeType": "fastest",
          "traffic": 'true'
        },
        body: {
          "supportingPoints": [
            {"latitude": src['lat'], "longitude": src['long']},
            {"latitude": dst['lat'], "longitude": dst['long']}
          ],
          "avoidVignette": []   
        }).then((value) => value);
    direction.value = response;
    // log('${direction.value}');
    return response;
  }
}
