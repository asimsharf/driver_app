import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  void register(_) async {}

  Toast(_, msg) async {
    return Fluttertoast.showToast(msg: msg);
  }

  validation(_) {
    if (txtName.text.length < 4) {
      Toast(
        _,
        "Name must be at least 3 characters.",
      );
    } else if (txtPhone.text.isEmpty) {
      Toast(
        _,
        "Phone number is mandatory.",
      );
    } else if (!txtEmail.text.contains("@")) {
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
      register(_);
    }
  }
}
