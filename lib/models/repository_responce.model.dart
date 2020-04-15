import 'package:flutter/material.dart';

class ResInfo {
	bool hasError;
	String message;
  DateTime expiryTime;
  String token;

	ResInfo({@required this.hasError, @required this.message, this.expiryTime, this.token});
}
