import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountApi {
  _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    // print(token);
    return token;
  }

  // -- Get Avatar
  void getProfileAvatar() async {
    final String token = await _getToken();
    final http.Response res =
        await http.get('http://10.0.2.2:9002/v1/profile/avatar', headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      'Authorization': token
    });

    print('account_api, get avatar');
    print(res);
  }

  // -- Create/Update Avatar
  Future<Map<String, dynamic>> uploadProfileAvatar({File file}) async {
    final String token = await _getToken();
    Uri uri = Uri.parse('http://10.0.2.2:9002/v1/profile/avatar/upload');

    final imageUploadRequest = http.MultipartRequest('POST', uri);

    ByteStream stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    int length = await file.length();
    MultipartFile multipartFile = http.MultipartFile('File', stream, length,
        filename: basename(file.path));

    MapEntry<String, String> xOffset = MapEntry('XOffset', '20');
    MapEntry<String, String> yOffset = MapEntry('YOffset', '20');
    MapEntry<String, String> width = MapEntry('Width', '100');
    MapEntry<String, String> height = MapEntry('Height', '100');
    
    Iterable<MapEntry<String, String>> entry = [xOffset, yOffset, width, height];

    imageUploadRequest.headers['Content-Type'] = 'multipart/form-data; charset=utf-8';
    imageUploadRequest.headers['Authorization'] = token;

    imageUploadRequest.files.add(multipartFile);
    imageUploadRequest.fields.addEntries(entry);

    StreamedResponse response = await imageUploadRequest.send();
    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value); // {"Success":true,"Result":{"Code":2,"Data":7.5}}
    });

  }

  // -- Delete Avatar

  // -- Update Username
  Future<Map<String, dynamic>> updateUsername({String newUsername}) async {
    final input = {
      'Username': newUsername,
    };
    final String token = await _getToken();

    final http.Response res = await http
        .post('http://10.0.2.2:9002/v1/username/update', body: input, headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      'Authorization': token
    });

    if (res.statusCode != 200) {
      print(res.statusCode);
      throw Exception('Error: Change username');
    }

    final resData = json.decode(res.body);

    // print(resData);
    // {Success: true, Result: {Code: 2, Data: 1.1}}
    return resData;
  }

  // -- Update Email
  Future<Map<String, dynamic>> updateEmail({String newEmail}) async {
    final input = {
      'Email': newEmail,
    };
    final String token = await _getToken();

    final http.Response res = await http
        .post('http://10.0.2.2:9002/v1/email/update', body: input, headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      'Authorization': token
    });

    if (res.statusCode != 200) {
      print(res.statusCode);
      throw Exception('Error: Change email');
    }

    final resData = json.decode(res.body);

    print(resData);
    // todo: email is not updated after sending a request
    // {Success: true, Result: {Code: 1, Data: true}}
    return resData;
  }

  // -- Set Password (for 3rd-party autheed user)
  Future<Map<String, dynamic>> setPassword(
      {String password, String passwordConfirm}) async {
    final input = {'Password': password, 'PasswordConfirm': passwordConfirm};
    final String token = await _getToken();

    final http.Response res = await http
        .post('http://10.0.2.2:9002/v1/password/set', body: input, headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      'Authorization': token
    });

    if (res.statusCode != 200) {
      print(res.statusCode);
      throw Exception('Error: Set Password');
    }

    final resData = json.decode(res.body);
    print(resData);

    return resData;
  }

  // -- Update Password
  Future<Map<String, dynamic>> updatePassword(
      {String password, String passwordNew, String passwordNewConfirm}) async {
    final input = {
      'Password': password,
      'PasswordNew': passwordNew,
      'PasswordNewConfirm': passwordNewConfirm
    };
    final String token = await _getToken();

    final http.Response res = await http
        .post('http://10.0.2.2:9002/v1/password/update', body: input, headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      'Authorization': token
    });

    if (res.statusCode != 200) {
      print(res.statusCode);
      throw Exception('Error: Change password');
    }

    final resData = json.decode(res.body);
    print(resData);

    return resData;
  }

  // -- Connect

}
