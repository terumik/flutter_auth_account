import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import './bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UserRepository _userRepository;

  RegistrationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegistrationState get initialState => RegistrationLoading();

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is RegistrationSubmitted) {
      yield* _mapFormSubmittedToState(
          event.email, event.username, event.password, event.passwordConfirm);
    }
    // if(event is RegistrationDismissDialog) {
    //   yield RegistrationLoading();
    // }
  }

  Stream<RegistrationState> _mapFormSubmittedToState(String email,
      String username, String password, String passwordConfirm) async* {
    yield RegistrationLoading();
    final ResInfo res = await _userRepository.createUser(
        email: email,
        username: username,
        password: password,
        passwordConfirm: passwordConfirm);
    if (res.hasError) {
      yield RegistrationFailure(resInfo: res);
    } else {
      yield RegistrationSuccess(resInfo: res);
    }
  }


}
