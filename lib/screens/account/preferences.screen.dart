import 'package:flutter/material.dart';

class PreferencesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(child: Text('Preferences Screen')),
      ),
    );
  }
}
