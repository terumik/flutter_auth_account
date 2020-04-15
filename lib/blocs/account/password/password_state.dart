import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';

@immutable
abstract class PasswordState extends Equatable {
  PasswordState([List props = const []]) : super(props);
}

class InitialPasswordState extends PasswordState {}

// -- Check PasswordSet Status
class PasswordNotSet extends PasswordState {
  @override
  String toString() => 'Set Password: Password not set';
}

// -- Set Password
class SetPasswordSubmitted extends PasswordState {
  @override
  String toString() => 'Set Password: Submitted';
}

class SetPasswordSuccess extends PasswordState {
  final ResInfo resInfo;
  SetPasswordSuccess({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Set Password: Success';
}

class SetPasswordFailure extends PasswordState {
  final ResInfo resInfo;
  SetPasswordFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Set Password: Failure';
}

// -- Update Password
class UpdatePasswordSubmitted extends PasswordState {
  @override
  String toString() => 'Update Password: Submitted';
}

class UpdatePasswordSuccess extends PasswordState {
  final ResInfo resInfo;
  UpdatePasswordSuccess({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Update Password: Success';
}

class UpdatePasswordFailure extends PasswordState {
  final ResInfo resInfo;
  UpdatePasswordFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Update Password: Failure';
}
