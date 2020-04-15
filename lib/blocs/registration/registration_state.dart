import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';

@immutable
abstract class RegistrationState extends Equatable {
  RegistrationState([List props = const []]) : super(props);
}

// -- Loading, Success, Failure
class RegistrationLoading extends RegistrationState {
  @override
  String toString() => 'Registration: Loading';
}

class RegistrationSuccess extends RegistrationState {
  final ResInfo resInfo;
  RegistrationSuccess({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Registration: Success';
}

class RegistrationFailure extends RegistrationState {
  final ResInfo resInfo;
  RegistrationFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Registration: Failure';
}
