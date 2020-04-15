import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth_account/models/user.model.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/providers/account_api.dart';
import 'package:flutter_auth_account/providers/authentication_api.dart';
import 'package:flutter_auth_account/shared/utils.dart';

class UserRepository {
  final AuthenticationApi _authenticationApi = AuthenticationApi();
  final AccountApi _accountApi = AccountApi();
  User _authenticatedUser;

  // -- Get Authenticated User
  Future<User> getAuthenticatedUser() async {
    if (_authenticatedUser == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _authenticatedUser = User(
          id: prefs.getString('userId'),
          email: prefs.getString('userEmail'),
          username: prefs.getString('username'),
          token: prefs.getString('token'),
          expiryTime:
              Utils.parseTimeStringToDate(prefs.getString('expiryTime')),
          passwordSet: prefs.getBool('passwordSet'));
    }
    return _authenticatedUser;
  }

  // -- Set Authenticated User
  Future<bool> _setAuthenticatedUser({String token, String email}) async {
    // read from token and set to SharedPref, return false if token has expired

    final decodedToken = Utils.decodeJwt(token);
    final String userId = decodedToken['ID'];
    final String username = decodedToken['Username'];
    // todo?: how to set new email after update email
    final DateTime now = DateTime.now();
    final String expiryTimeString = decodedToken['ExpiresOn'];
    final DateTime expiryTime = Utils.parseTimeStringToDate(expiryTimeString);
    final bool passwordSet = decodedToken['PasswordSet'];
    if (expiryTime.isBefore(now)) {
      _authenticatedUser = null;
      return false;
    }

    _authenticatedUser = User(
        id: userId,
        username: username,
        email: email,
        token: token,
        expiryTime: expiryTime,
        passwordSet: passwordSet);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', _authenticatedUser.id);
    prefs.setString('username', _authenticatedUser.username);
    prefs.setString('userEmail', email);
    prefs.setString('token', _authenticatedUser.token);
    prefs.setString(
        'expiryTime', _authenticatedUser.expiryTime.toIso8601String());
    prefs.setBool(
        'passwordSet', _authenticatedUser.passwordSet);

    return true;
  }

  // -- Create User
  Future<ResInfo> createUser(
      {String email,
      String username,
      String password,
      String passwordConfirm}) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Something went wrong while registering your account.');

    final Map<String, dynamic> json = await _authenticationApi.createUser(
        email: email,
        username: username,
        password: password,
        passwordConfirm: passwordConfirm);
    // {Success: true, Result: {Code: 1, Data: true}}

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.message = 'Please check your email to varify your account.';
      res.hasError = false;
    } else {
      // todo: error handling
      // if(json['Success'] && json['Result']['Code'] == 2){
      //   message = 'Email does not exist.';
      // }
    }
    return res;
  }

  // -- Authenticate User (Login)
  Future<ResInfo> authenticateUser({
    String email,
    String password,
  }) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Authentication failed. Please check your credentials.',
        expiryTime: null,
        token: null);

    final json = await _authenticationApi.authenticateUser(
        email: email, password: password);
    // {Success: true, Result: {Code: 1, Data: true}}

    // todo: need to check if user has varified their account
    if (json['Success'] && json['Result']['Code'] == 1) {
      // store user info and token
      final token = json['Result']['Data'];

      _setAuthenticatedUser(token: token, email: email);

      res.message = 'Authentication success';
      res.hasError = false;
      res.expiryTime = _authenticatedUser.expiryTime;
      res.token = _authenticatedUser?.token;
    } else {
      // todo: error handling
    }

    // todo: token needed?
    return res;
  }

  // -- Logout
  Future<void> removeStoredUserInfo() async {
    // delete from keystore
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
    prefs.remove('username');
    prefs.remove('userEmail');
    prefs.remove('expiryTime');
    _authenticatedUser = null;
    print('User Repo: removed user info from keystore');
  }

  // -- Auto-login (check token)
  Future<bool> hasAuthenticatedUser() async {
    /// read from keystore
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    if (token != null) {
      final String email = prefs.getString('userEmail');
      bool isTokenValid =
          await _setAuthenticatedUser(token: token, email: email);
      return isTokenValid;
    } else {
      return false;
    }
  }

  // -- Forgot Password
  Future<ResInfo> forgotPassword({String email}) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Something went wrong while processing your request.');

    final json = await _authenticationApi.forgotPassword(email: email);

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.hasError = false;
      res.message =
          'We have sent you a restoration link. Please check your email.';
    } else {
      // todo: error handling
    }

    return res;
  }

  // -- Change Password
  Future<ResInfo> changePassword(
      {String password, String passwordConfirm, String urlToken}) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Something went wrong while changing your password.');

    final json = await _authenticationApi.changePassword(
        password: password,
        passwordConfirm: passwordConfirm,
        urlToken: urlToken);

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.hasError = false;
      res.message = 'Your password has been changed.';
    } else {
      // todo: error handling
    }

    // todo: check the data. if new token is generated, store it.
    // {Success: true, Result: {Code: 2, Data: 1.1}}
    print(json);
    return res;
  }

  // -- Set Password
  Future<ResInfo> setPassword({String password, String passwordConfirm}) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Something went wrong while update your password.');

    final json = await _accountApi.setPassword(
        password: password, passwordConfirm: passwordConfirm);

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.hasError = false;
      res.message = 'Password has been set.';
    } else {
      // todo: error handling
    }

    // print(json); // {Success: true, Result: {Code: 1, Data: true}}
    return res;
  }

  // -- Update Password
  Future<ResInfo> updatePassword(
      {String password, String passwordNew, String passwordNewConfirm}) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Something went wrong while update your password.');

    final json = await _accountApi.updatePassword(
        password: password,
        passwordNew: passwordNew,
        passwordNewConfirm: passwordNewConfirm);

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.hasError = false;
      res.message = 'Password has been updated.';
    } else {
      // todo: error handling
    }

    // print(json); // {Success: true, Result: {Code: 1, Data: true}}
    return res;
  }

  // -- Update Username
  Future<ResInfo> updateUsername({String newUsername}) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Something went wrong while changing username.');

    final json = await _accountApi.updateUsername(newUsername: newUsername);

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.hasError = false;
      res.message = 'Username has been changed.';

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String email = prefs.getString('userEmail');

      final String newToken = json['Result']['Data'];
      _setAuthenticatedUser(token: newToken, email: email);
    } else {
      // todo: error handling
    }

    // print(json); // {Success: true, Result: {Code: 2, Data: eyJhbGci(new token)}}
    return res;
  }

  // -- Update Email
  Future<ResInfo> updateEmail({String newEmail}) async {
    ResInfo res = ResInfo(
        hasError: true, message: 'Something went wrong while changing email.');

    final json = await _accountApi.updateEmail(newEmail: newEmail);

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.hasError = false;
      res.message = 'Email has been changed.';

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');

      _setAuthenticatedUser(token: token, email: newEmail);
    } else {
      // todo: error handling
    }

    // print(json);
    // {Success: true, Result: {Code: 1, Data: true}}
    return res;
  }

  // -- Upload Avatar
    Future<ResInfo> uploadAvatar({File file}) async {
    ResInfo res = ResInfo(
        hasError: true,
        message: 'Something went wrong while uploading avatar.');

    final json = await _accountApi.uploadProfileAvatar(file: file);

    if (json['Success'] && json['Result']['Code'] == 1) {
      res.hasError = false;
      res.message = 'Avatar has been changed.';

    } else {
      // todo: error handling
    }

    print(json); 
    // 
    return res;
  }
}
