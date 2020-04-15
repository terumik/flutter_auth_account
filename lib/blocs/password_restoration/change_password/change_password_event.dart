import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChangePasswordEvent extends Equatable {
  ChangePasswordEvent([List props = const []]) : super(props);
}

// -- Submitted
class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String password;
  final String passwordConfirm;
  final String urlToken;

  ChangePasswordSubmitted(
      {@required this.password,
      @required this.passwordConfirm,
      @required this.urlToken})
      : super([password, passwordConfirm, urlToken]);

  @override
  String toString() {
    return 'Change Password: Submitted';
  }
}
