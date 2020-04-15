import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/blocs/authentication/bloc.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/models/user.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  User _authenticatedUser;
  Timer _authTimer;

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AuthPressed) {
      yield* _mapLoginPressedToState(event.email, event.password);
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  // -- AppStarted
  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final bool hasAuthenticatedUser =
        await _userRepository.hasAuthenticatedUser();

    try {
      if (hasAuthenticatedUser) {
        _authenticatedUser = await _userRepository.getAuthenticatedUser();

        // auto-logout
        final DateTime expiryTime = _authenticatedUser.expiryTime;
        final tokenLifespan = expiryTime.difference(DateTime.now()).inSeconds;
        _setAuthTimeout(tokenLifespan);

        yield Authenticated(authenticatedUser: _authenticatedUser);
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      yield Unauthenticated();
    }
  }

  // -- Auth Pressed
  Stream<AuthenticationState> _mapLoginPressedToState(
      String email, String password) async* {
    yield AuthenticationLoading();
    final ResInfo res = await _userRepository.authenticateUser(
      email: email,
      password: password,
    );
    if (res.hasError) {
      String message = res.message;
      print("login_bloc: login failed. {$message}");
      yield AuthenticationFailure(resInfo: res);
    } else {
      // auto-logout
      DateTime expiryTime = res.expiryTime;
      final tokenLifespan = expiryTime.difference(DateTime.now()).inSeconds;
      _setAuthTimeout(tokenLifespan);

      _authenticatedUser = await _userRepository.getAuthenticatedUser();

      yield Authenticated(authenticatedUser: _authenticatedUser);
    }
  }

  // -- Logged In
  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(authenticatedUser: _authenticatedUser);
  }

  // -- Logged Out
  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _userRepository.removeStoredUserInfo();
    _authTimer.cancel();
    _authenticatedUser = null;
    yield Unauthenticated();
  }

  // -- Private Methods
  void _dispatchAutoLogout() {
    this.dispatch(LoggedOut());
  }

  void _setAuthTimeout(int tokenLifespan) {
    // note: for debug auto-logout, use those two lines
    // int parsedTime = (tokenLifespan / 10000).floor() - 40;
    // _authTimer = Timer(Duration(seconds: parsedTime), _dispatchAutoLogout);
    _authTimer = Timer(Duration(seconds: tokenLifespan), _dispatchAutoLogout);
  }
}
