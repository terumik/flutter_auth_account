import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import './bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final UserRepository _userRepository;

  ForgotPasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ForgotPasswordState get initialState => ForgotPasswordLoading();

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ForgotPasswordSubmitted) {
      yield* _mapFormSubmittedToState(event.email);
    }
  }

  Stream<ForgotPasswordState> _mapFormSubmittedToState(String email) async* {
    yield ForgotPasswordLoading();
    final ResInfo res = await _userRepository.forgotPassword(email: email);
    if (res.hasError) {
      yield ForgotPasswordFailure(resInfo: res);
    } else {
      yield ForgotPasswordEmailExist(resInfo: res);
    }
  }
}
