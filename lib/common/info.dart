import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:self_management/common/app_color.dart';

class Info {
  static failed(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColor.error,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static success(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColor.success,
      textColor: Colors.white,
      fontSize: 16,
    );
  }
}
