import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';

@immutable
abstract class ForgotPasswordState extends Equatable {
  ForgotPasswordState([List props = const []]) : super(props);
}

// -- Forgot Password
class ForgotPasswordLoading extends ForgotPasswordState {
  @override
  String toString() => 'Forgot Password: Loading';
}

class ForgotPasswordEmailSubmitted extends ForgotPasswordState {
  @override
  String toString() => 'Forgot Password: Email Submitted';
}

class ForgotPasswordEmailExist extends ForgotPasswordState {
  final ResInfo resInfo;
  ForgotPasswordEmailExist({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Forgot Password: Email Exist';
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final ResInfo resInfo;
  ForgotPasswordFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Forgot Password: Failure $resInfo ';
}