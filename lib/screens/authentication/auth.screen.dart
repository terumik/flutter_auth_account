import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/auth_tab/bloc.dart';
import 'package:flutter_auth_account/blocs/authentication/bloc.dart';
import 'package:flutter_auth_account/blocs/registration/bloc.dart';
import 'package:flutter_auth_account/models/auth_mode.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import 'package:flutter_auth_account/widgets/auth_form.dart';
import 'package:flutter_auth_account/widgets/third_party_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  UserRepository _userRepository;
  RegistrationBloc _registrationBloc;
  AuthTabBloc _authTabBloc = AuthTabBloc();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _registrationBloc = RegistrationBloc(userRepository: _userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      listener: (BuildContext context, AuthenticationState state) {
        // note: listen to the authentication state and auto-login/out
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                height: 42,
              ),
              BlocBuilder(
                  bloc: _authTabBloc,
                  builder: (BuildContext context, AuthMode authMode) {
                    return FlatButton(
                        child: Text(
                            'Switch to ${authMode == AuthMode.Login ? 'CREATE ACCOUNT' : 'SIGN-IN'}'),
                        textColor: Colors.white,
                        onPressed: () {
                          if (authMode == AuthMode.Login) {
                            _authTabBloc.dispatch(
                                ChangeAuthMode(AuthMode.Registration));
                          } else {
                            _authTabBloc
                                .dispatch(ChangeAuthMode(AuthMode.Login));
                          }
                          _passwordTextController.clear();
                        });
                  })
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  BlocBuilder(
                      bloc: _authTabBloc,
                      builder: (BuildContext context, AuthMode authMode) {
                        return AuthForm(
                            registrationBloc: _registrationBloc,
                            authenticationBloc:
                                BlocProvider.of<AuthenticationBloc>(context),
                            authMode: authMode,
                            passwordTextController: _passwordTextController);
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  ThirdPartyAuth(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registrationBloc.dispose();
    _authTabBloc.dispose();
    super.dispose();
  }
}
