import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../screens/login_page.dart';
import 'constants.dart';

void showAlert(
    {required context, required String title, required String messageErr}) {
  Alert(
    context: context,
    type: AlertType.error,
    title: title,
    desc: messageErr,
    style: AlertStyle(
      backgroundColor: kBackgrounColor,
      titleStyle: const TextStyle(color: Colors.white),
      descStyle: const TextStyle(color: Colors.white),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    buttons: [
      DialogButton(
        onPressed: () {
          if (title == "Unauthorized") {
            // Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
            return;
          }
          Navigator.pop(context);
        },
        width: 120,
        color: Colors.blueAccent,
        child: const Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  ).show();
}
