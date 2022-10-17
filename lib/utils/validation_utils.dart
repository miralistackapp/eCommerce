import 'package:flutter/material.dart';

class ValidationUtils {

  //     ======================= Regular Expressions =======================     //
  static const String emailRegExp = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$';
  static const String passwordRegexp = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{0,}$";


  //     ======================= Validation methods =======================     //
  static bool validateEmptyController(TextEditingController textEditingController) {
    return textEditingController.text.trim().isEmpty;
  }

  static bool lengthValidator(TextEditingController textEditingController, int length) {
    return textEditingController.text.trim().length < length;
  }

  static bool regexValidator(TextEditingController textEditingController, String regex) {
    return RegExp(regex).hasMatch(textEditingController.text);
  }

  static bool compareValidator(TextEditingController textEditingController, TextEditingController secondController) {
    return textEditingController.text != secondController.text;
  }
}