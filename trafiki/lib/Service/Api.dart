import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trafiki/Constant.dart';

class Api {
  static String baseUrl = "";

  Future<Map<String, dynamic>> get(
      {required String url, required Map<String, dynamic> param}) async {
    try {
      log("ola");

      log("${Uri.https(Constant.BASE_URL, url, param)}");
      var res = await http.get(Uri.https(Constant.BASE_URL, url, param));

      log("res = ${res.body}");
      if (res.statusCode == 200) {
        return {"connect": true, "data": jsonDecode(res.body)};
      } else {
        print(jsonDecode(res.body));
        return {"connect": false, "data": {}};
      }
    } catch (e) {
      print("ola");
      print(e);
      return {"connect": false, "data": {}};
    }
  }

  Future<Map<String, dynamic>> put(
      {required Map<String, dynamic> body, required String url}) async {
    try {
      log("url = " + url);
      var res = await http.put(Uri.parse(url),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json; charset=utf-8"});

      if (res.statusCode == 200) {
        return {"connect": true, "data": jsonDecode(res.body)};
      } else {
        print(jsonDecode(res.body));
        return {"connect": false, "data": {}};
      }
    } catch (e) {
      print("ola");
      print(e);
      return {"connect": false, "data": {}};
    }
  }

  Future<Map<String, dynamic>> post(
      {required Map<String, dynamic> body,
      required String url,
      Map<String, dynamic>? param}) async {
    try {
      log("${Uri.https(Constant.BASE_URL, url, param)}");
      var res = await http.post(Uri.https(Constant.BASE_URL, url, param ?? {}),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json; charset=utf-8"});

      if (res.statusCode == 200) {
        return {"connect": true, "data": jsonDecode(res.body)};
      } else {
        print(jsonDecode(res.body));
        return {"connect": false, "data": {}};
      }
    } catch (e) {
      print("ola");
      print(e);
      return {"connect": false, "data": {}};
    }
  }

  Future<Map<String, dynamic>> delete(
      {required Map<String, dynamic> body, required String url}) async {
    try {
      log("url = " + url);
      var res = await http.delete(Uri.parse(url),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json; charset=utf-8"});

      if (res.statusCode == 200) {
        return {"connect": true, "data": jsonDecode(res.body)};
      } else {
        return {"connect": false, "data": {}};
      }
    } catch (e) {
      print("ola");
      print(e);
      return {"connect": false, "data": {}};
    }
  }
}
