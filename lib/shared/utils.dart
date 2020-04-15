import 'dart:convert';

class Utils {

  static Map<String, dynamic> decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static DateTime parseTimeStringToDate(String timeString) {
  // parse string from database(2019-05-08T16:29:54.8357087Z) to datetime(2019-05-08 16:42:46.000)
  final String formattedTimeString = timeString.split('.')[0].toString();
  return DateTime.parse(formattedTimeString);
}
}
