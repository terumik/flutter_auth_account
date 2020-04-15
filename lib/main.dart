import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/authentication/bloc.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import 'package:flutter_auth_account/screens/account/account.screen.dart';
import 'package:flutter_auth_account/screens/authentication/auth.screen.dart';
import 'package:flutter_auth_account/screens/authentication/change_password.screen.dart';
import 'package:flutter_auth_account/screens/authentication/forgot_password.screen.dart';
import 'package:flutter_auth_account/screens/home.screen.dart';
import 'package:flutter_auth_account/simple_bloc_delegate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    BlocSupervisor().delegate = SimpleBlocDelegate();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        title: 'App Name',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        routes: {
          // todo: show screen smoother (show circle indicator?)
          '/': (BuildContext context) {
            print('route: ' + _authenticationBloc.currentState.toString());
            return _authenticationBloc.currentState is Authenticated
                ? HomeScreen()
                : AuthScreen();
          },
          '/forgot_password': (BuildContext context) => ForgotPasswordScreen(),
          // todo: when mailer implemented, delete the line below
          '/change_password': (BuildContext context) =>
              ChangePasswordScreen('this is a dummy token'),
          '/account': (BuildContext context) {
            print('route: ' + _authenticationBloc.currentState.toString());
            return _authenticationBloc.currentState is Authenticated
                ? AccountScreen()
                : AuthScreen();
          },
        },
        // parameterized route
        onGenerateRoute: (RouteSettings settings) {
          // settings hold the name we want to navigate to
          final List<String> pathElements = settings.name.split('/');
          // '/products/1' will be split into '', 'product'. '1'

          if ((_authenticationBloc.currentState is! Authenticated) &&
              pathElements[1] == 'change_password') {
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AuthScreen());
          }

          if (pathElements[0] != '') {
            // invalid path
            return null;
          }
          if (pathElements[1] == 'change_password') {
            // todo: ChangePassword() with real token
            final String token = pathElements[2];
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ChangePasswordScreen(token));
          }

          return null;
        },
        // fallback
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (BuildContext context) {
            print(_authenticationBloc.currentState);
            return _authenticationBloc.currentState is Authenticated
                ? HomeScreen()
                : AuthScreen();
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}
