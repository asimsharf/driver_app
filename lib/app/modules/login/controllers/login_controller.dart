import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  void login(_) async {}

  Toast(_, msg) async {
    return Fluttertoast.showToast(msg: msg);
  }

  validation(_) {
    if (!txtEmail.text.contains("@")) {
      Toast(
        _,
        "Email address is not valid.",
      );
    } else if (txtPass.text.length < 7) {
      Toast(
        _,
        "Password must be at least 6 characters.",
      );
    } else {
      login(_);
    }
  }
}
