import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_auth_account/models/auth_mode.model.dart';
import './bloc.dart';

class AuthTabBloc extends Bloc<AuthTabEvent, AuthMode> {
  @override
  AuthMode get initialState => AuthMode.Login;

  @override
  Stream<AuthMode> mapEventToState(
    AuthTabEvent event,
  ) async* {
    if (event is ChangeAuthMode) {
      yield event.mode;
    }
  }
}
