import 'package:flutter/material.dart';

abstract class SnackBarService {
  static void triggerSuccessSnackBar(BuildContext context, String content) {
    SnackBar successSnackBar = SnackBar(
      content: Center(child: Text(content)),
      backgroundColor: Colors.green,
    );
    _triggerSnackBar(context, successSnackBar);
  }

  static void triggerErrorSnackBar(BuildContext context, String content) {
    SnackBar successSnackBar = SnackBar(
      content: Center(child: Text(content)),
      backgroundColor: Colors.red,
    );
    _triggerSnackBar(context, successSnackBar);
  }

  static void triggerInformationSnackBar(BuildContext context, String content) {
    SnackBar successSnackBar = SnackBar(
      content: Center(child: Text(content)),
      backgroundColor: Colors.blue,
    );
    _triggerSnackBar(context, successSnackBar);
  }

  static void _triggerSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}