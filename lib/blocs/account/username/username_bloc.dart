import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/models/user.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import './bloc.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  final UserRepository _userRepository;
  UsernameBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  User _authenticatedUser;

  @override
  UsernameState get initialState => UpdateUsernameInitial(oldUsername: '');

  @override
  Stream<UsernameState> mapEventToState(
    UsernameEvent event,
  ) async* {
    if (event is LoadInitialUsername) {
      yield* _mapLoadInitialUsernameToState();
    }
    if (event is SubmitNewUsername) {
      yield* _mapFormSubmittedToState(newUsername: event.newUsername);
    }
  }

  Stream<UsernameState> _mapLoadInitialUsernameToState() async* {
    yield UpdateUsernameLoading();
    _authenticatedUser = await _userRepository.getAuthenticatedUser();
    yield InitialUsernameLoaded(oldUsername: _authenticatedUser.username);
  }

  Stream<UsernameState> _mapFormSubmittedToState({String newUsername}) async* {
    yield UpdateUsernameLoading();
    final ResInfo res =
        await _userRepository.updateUsername(newUsername: newUsername);
    if (res.hasError) {
      yield UpdateUsernameFailure(resInfo: res);
    } else {
      _authenticatedUser = await _userRepository.getAuthenticatedUser();
      yield UpdateUsernameSuccess(
          resInfo: res, newUsername: _authenticatedUser.username);
    }
  }
}
