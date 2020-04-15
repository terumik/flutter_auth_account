import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';

@immutable
abstract class ChangePasswordState extends Equatable {
  ChangePasswordState([List props = const []]) : super(props);
}

// -- Change Password
class ChangePasswordLoading extends ChangePasswordState {
  @override
  String toString() => 'Change Password: Loading';
}

class ChangePasswordPasswordSubmitted extends ChangePasswordState {
  @override
  String toString() => 'Change Password: Password Submitted';
}

class ChangePasswordSuccess extends ChangePasswordState {
  final ResInfo resInfo;
  ChangePasswordSuccess({@required this.resInfo}) : super([resInfo]);
  
  @override
  String toString() => 'Change Password: Success';
}

class ChangePasswordFailure extends ChangePasswordState {
  final ResInfo resInfo;
  ChangePasswordFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Change Password:Failure';
}
