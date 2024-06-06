import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

customSnackBar(BuildContext context, String msg, String action,
    GlobalKey<ScaffoldState> key, int seconds) {
  final SnackBar snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(seconds: seconds),
    action: SnackBarAction(
        label: action, textColor: Colors.yellow, onPressed: () {}),
  );
  key.currentState?.showSnackBar(snackBar);
}

showToastError(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.black,
      fontSize: 15.0);
}

showToastSuccess(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.black,
      fontSize: 15.0);
}
