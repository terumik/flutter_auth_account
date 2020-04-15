import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/models/user.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import './bloc.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final UserRepository _userRepository;
  PasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  User _authenticatedUser;

  @override
  PasswordState get initialState => InitialPasswordState();

  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is CheckPasswordIsSet) {
      yield* _mapCheckPassword();
    }
    if (event is SubmitSetPassword) {
      yield* _mapSetPasswordSubmittedToState(
          password: event.password, passwordConfirm: event.passwordConfirm);
    }
    if (event is SubmitUpdatePassword) {
      yield* _mapUpdatePasswordSubmittedToState(
          password: event.password,
          passwordNew: event.passwordNew,
          passwordNewConfirm: event.passwordNewConfirm);
    }
  }

  Stream<PasswordState> _mapSetPasswordSubmittedToState(
      {@required String password, @required String passwordConfirm}) async* {
    yield InitialPasswordState();
    final ResInfo res = await _userRepository.setPassword(
        password: password, passwordConfirm: passwordConfirm);
    if (res.hasError) {
      yield SetPasswordFailure(resInfo: res);
    } else {
      _authenticatedUser = await _userRepository.getAuthenticatedUser();
      yield SetPasswordSuccess(resInfo: res);
    }
  }

  Stream<PasswordState> _mapUpdatePasswordSubmittedToState(
      {@required String password,
      @required String passwordNew,
      @required String passwordNewConfirm}) async* {
    yield InitialPasswordState();
    final ResInfo res = await _userRepository.updatePassword(
        password: password,
        passwordNew: passwordNew,
        passwordNewConfirm: passwordNewConfirm);
    if (res.hasError) {
      yield UpdatePasswordFailure(resInfo: res);
    } else {
      _authenticatedUser = await _userRepository.getAuthenticatedUser();
      yield UpdatePasswordSuccess(resInfo: res);
    }
  }

  Stream<PasswordState> _mapCheckPassword() async* {
    yield InitialPasswordState();
    _authenticatedUser = await _userRepository.getAuthenticatedUser();
    if (_authenticatedUser.passwordSet) {
      yield PasswordNotSet();
    }
  }
}
