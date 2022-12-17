import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static max_min_width(BuildContext context,
      {required double max, required double min}) {
    double width = MediaQuery.of(context).size.width;
    return (width < min)
        ? min
        : (width > max)
            ? max
            : width;
  }

  static max_min_height(BuildContext context,
      {required double max, required double min}) {
    double height = MediaQuery.of(context).size.height;
    return (height < min)
        ? min
        : (height > max)
            ? max
            : height;
  }

  static double roundDouble({required double value, required int places}){ 
   num mod = pow(10.0, places); 
   return ((value * mod).round().toDouble() / mod); 
}

  static loading(context, {required Function action}) async {
    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: ((context) => const AlertDialog(
            content: SizedBox(
              height: 40,
              child: Center(child: CupertinoActivityIndicator()),
            ))));
    await action();
    Navigator.of(context).pop();
  }
}
