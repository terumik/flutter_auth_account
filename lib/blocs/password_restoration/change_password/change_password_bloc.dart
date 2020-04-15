import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import './bloc.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository _userRepository;

  ChangePasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ChangePasswordState get initialState => ChangePasswordLoading();

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is ChangePasswordSubmitted) {
      yield* _mapFormSubmittedToState(
          password: event.password,
          passwordConfirm: event.passwordConfirm,
          urlToken: event.urlToken);
    }
  }

  Stream<ChangePasswordState> _mapFormSubmittedToState(
      {String password, String passwordConfirm, String urlToken}) async* {
    yield ChangePasswordLoading();
    final ResInfo res = await _userRepository.changePassword(
        password: password, passwordConfirm: passwordConfirm, urlToken: urlToken);
    if (res.hasError) {
      yield ChangePasswordFailure(resInfo: res);
    } else {
      yield ChangePasswordSuccess(resInfo: res);
    }
  }
}
