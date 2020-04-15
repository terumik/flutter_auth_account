import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationApi {
  // -- Create User
  Future<Map<String, dynamic>> createUser(
      {String email,
      String username,
      String password,
      String passwordConfirm}) async {
    final authInput = {
      'Email': email,
      'Username': username,
      'Password': password,
      'PasswordConfirm': passwordConfirm
    };

    final http.Response res = await http.post('http://10.0.2.2:9000/v1/create-account',
        body: authInput,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
        });

    if (res.statusCode != 200) {
      throw Exception('Error: Create a new user');
    }

    final resData = json.decode(res.body);

    // print(resData);
    // {Success: true, Result: {Code: 2, Data: 1.1}}
    return resData;
  }

  // -- Login User
  Future<Map<String, dynamic>> authenticateUser({
    String email,
    String password,
  }) async {
    final authInput = {
      'Email': email,
      'Password': password,
    };

    final http.Response res = await http.post('http://10.0.2.2:9000/v1/sign-in',
        body: authInput,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
        });

    if (res.statusCode != 200) {
      throw Exception('Error: Login');
    }

    final resData = json.decode(res.body);

    // print(resData);
    // {Success: true, Result: {Code: 2, Data: 1.1}}
    return resData;
  }

  // -- Forgot Password
  Future<Map<String, dynamic>> forgotPassword({String email}) async {
    Map<String, String> emailInput;
    emailInput = {'Email': email};

    final http.Response res = await http.post('http://10.0.2.2:9000/v1/password/forgot',
        body: emailInput,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
        });

    if (res.statusCode != 200) {
      throw Exception('Error: Forgot password');
    }

    final resData = json.decode(res.body);
    return resData;

  }

  // -- Change Password
    Future<Map<String, dynamic>> changePassword(
      // todo: implement changePassword when there is a real token
      //  (get token from url param -> pass it down from MainPage to ChangePwPage -> onSubmitForm, send those 3 data to this method)
      {String password,
      String passwordConfirm,
      String urlToken}) async {
    Map<String, String> changePasswordInput;
    changePasswordInput = {
      'Password': password,
      'PasswordConfirm': passwordConfirm,
      'Token': urlToken
    };

    final http.Response res = await http.post('http://10.0.2.2:9000/v1/password/change',
        body: changePasswordInput,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
        });

    final Map<String, dynamic> resData = json.decode(res.body);
    return resData;
  }
}
