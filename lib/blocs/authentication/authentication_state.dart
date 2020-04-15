import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/models/user.model.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'Authentication: Uninitialized';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'Authentication: Loading';
}

class Authenticated extends AuthenticationState {
  final User authenticatedUser;
  Authenticated({@required this.authenticatedUser}) : super([authenticatedUser]);

  @override
  String toString() => 'Authentication: Authenticated';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Authentication: Unauthenticated';
}

class AuthenticationFailure extends AuthenticationState {
  final ResInfo resInfo;
  AuthenticationFailure({@required this.resInfo}) : super([resInfo]);
  @override
  String toString() => 'Authentication: AuthenticationFailure';
}
