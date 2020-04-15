import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final DateTime expiryTime;
  final String avaterId; // todo: what is the type of avaterId?
  final bool passwordSet;

  User(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.token,
      @required this.expiryTime,
      @required this.passwordSet,
      this.avaterId});
}

  // "AvatarID": "",
  // "AvatarStatus": "notset",
  // "Confirmed": false,
  // "ConnectionFacebook": false,
  // "ConnectionGoogle": false,
  // "ConnectionLinkedIn": false,
  // "ExpiresOn": "2019-06-05T18:38:44.5234447Z",
  // "ID": "5cde6709ba20a935a43c4dc5",
  // "NotBefore": "2019-05-29T18:38:44.5234447Z",
  // "PasswordSet": true,
  // "Username": "test"