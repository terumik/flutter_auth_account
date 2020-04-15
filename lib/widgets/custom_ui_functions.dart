import 'package:flutter/material.dart';

class CustomUI {
  static Future displayDialog(BuildContext context, res) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: res.hasError ? Text('Error') : Text('Success'),
            content: Text(res.message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
