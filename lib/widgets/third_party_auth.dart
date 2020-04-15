import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:flutter_auth_account/models/user.model.dart';
// import 'package:flutter_auth_account/scoped_models/main.scoped_model.dart';

class ThirdPartyAuth extends StatelessWidget {
  // todo: auth with SNS
  Widget _buildThirdPartyAuth(BuildContext context) {
    // https://pub.dartlang.org/packages/google_sign_in
    // https://pub.dartlang.org/packages/flutter_facebook_login
    // https://pub.dartlang.org/packages/flutter_linkedin_login
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                'CONNECT WITH',
                style: TextStyle(fontSize: 25.0, color: Colors.teal),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: deviceWidth * 0.05,
            children: <Widget>[
              _buildButton(deviceWidth, 'Google',
                  Icon(FontAwesomeIcons.google, size: 14), _handleSignIn),
              _buildButton(deviceWidth, 'Facebook',
                  Icon(FontAwesomeIcons.facebook, size: 14), () {}),
              _buildButton(deviceWidth, 'LinkedIn',
                  Icon(FontAwesomeIcons.linkedin, size: 14), () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      double deviceWidth, String buttonText, Icon icon, Function func) {
    return ButtonTheme(
      minWidth: deviceWidth * 0.45,
      child: RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              SizedBox(
                width: 10,
              ),
              Text(buttonText)
            ],
          ),
          textColor: Colors.white,
          color: Colors.teal,
          onPressed: () {
            print('Auth with ' + buttonText);
            func();
          }),
    );
  }

  // todo: separate func from ui??
  // note: Google Auth POST -> v#/connect/google
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      final res = await _googleSignIn.signIn();
      print(res);
      // GoogleSignInAccount:{displayName: T Kusaka, email: t.kusaka3@gmail.com, id: 106832180897832021176,
      // photoUrl: https://lh3.googleusercontent.com/a-/AAuE7mB9kLMJTau6-iWliQREwXBKHOj5ued-qKqphwLN3g}

    } catch (error) {
      print(error);
    }
  }

  // note: Facebook POST -> v#/connect/facebook

  // note: LinkedIn POST -> v#/connect/linkedin

  @override
  Widget build(BuildContext context) {
    return _buildThirdPartyAuth(context);
  }
}
