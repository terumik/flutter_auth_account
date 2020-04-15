import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'Authentication: AppStarted';
}

class AuthPressed extends AuthenticationEvent {
  final String email;
  final String password;

  AuthPressed({
    @required this.email,
    @required this.password,
  }) : super([email, password]);

  @override
  String toString() => 'Authentication: LoggedIn';
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'Authentication: LoggedIn';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'Authentication: LoggedOut';
}
