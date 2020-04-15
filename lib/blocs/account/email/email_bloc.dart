import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/models/user.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import './bloc.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  final UserRepository _userRepository;
  EmailBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  User _authenticatedUser;

  @override
  EmailState get initialState => UpdateEmailInitial(oldEmail: 'dummy@email.com');

  @override
  Stream<EmailState> mapEventToState(
    EmailEvent event,
  ) async* {
    if (event is LoadInitialEmail) {
      yield* _mapLoadInitialEmailToState();
    }
    if (event is SubmitNewEmail) {
      yield* _mapFormSubmittedToState(newEmail: event.newEmail);
    }
  }

  Stream<EmailState> _mapLoadInitialEmailToState() async* {
    yield UpdateEmailLoading();
    _authenticatedUser = await _userRepository.getAuthenticatedUser();
    yield InitialEmailLoaded(oldEmail: _authenticatedUser.email);
  }

  Stream<EmailState> _mapFormSubmittedToState({String newEmail}) async* {
    yield UpdateEmailLoading();
    final ResInfo res =
        await _userRepository.updateEmail(newEmail: newEmail);
    if (res.hasError) {
      yield UpdateEmailFailure(resInfo: res);
    } else {
      _authenticatedUser = await _userRepository.getAuthenticatedUser();
      yield UpdateEmailSuccess(
          resInfo: res, newEmail: _authenticatedUser.email);
    }
  }
}
