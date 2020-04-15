import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/authentication/bloc.dart';
import 'package:flutter_auth_account/blocs/registration/bloc.dart';
import 'package:flutter_auth_account/blocs/registration/registration_bloc.dart';
import 'package:flutter_auth_account/models/auth_mode.model.dart';
import 'custom_ui_functions.dart';

class AuthForm extends StatefulWidget {
  final RegistrationBloc registrationBloc;
  final AuthenticationBloc authenticationBloc;
  final AuthMode authMode;
  final TextEditingController passwordTextController;
  const AuthForm(
      {Key key,
      this.registrationBloc,
      this.authenticationBloc,
      this.authMode,
      this.passwordTextController})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'username': null,
    'email': null,
    'password': null,
    'passwordConfirm': null
  };
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // for alert dialog
    return BlocListenerTree(
      blocListeners: [
        BlocListener<RegistrationEvent, RegistrationState>(
          bloc: widget.registrationBloc,
          listener: (BuildContext context, RegistrationState state) {
            if (state is RegistrationSuccess) {
              CustomUI.displayDialog(context, state.resInfo);
            }
            if (state is RegistrationFailure) {
              CustomUI.displayDialog(context, state.resInfo);
            }
          },
        ),
        BlocListener<AuthenticationEvent, AuthenticationState>(
          bloc: widget.authenticationBloc,
          listener: (BuildContext context, AuthenticationState state) {
            if (state is Authenticated) {
              BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
            }
            if (state is AuthenticationFailure) {
              CustomUI.displayDialog(context, state.resInfo);
            }
          },
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  widget.authMode == AuthMode.Login
                      ? 'SIGN-IN'
                      : 'CREATE ACCOUNT',
                  style: TextStyle(fontSize: 25.0, color: Colors.teal),
                ),
              ),
            ),
            widget.authMode == AuthMode.Login
                ? Container()
                : _buildUsernameTextField(),
            _buildEmailTextField(),
            _buildPasswordTextField(),
            widget.authMode == AuthMode.Login
                ? Container()
                : _buildConfirmPasswordTextField(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: widget.authMode == AuthMode.Login
                        ? Text('SIGN-IN')
                        : Text('REGISTER'),
                    onPressed: () {
                      _submitForm();
                    }),
                widget.authMode == AuthMode.Login
                    ? FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Text('Forgot Password?'))
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    if (widget.authMode == AuthMode.Registration) {
      widget.registrationBloc.dispatch(RegistrationSubmitted(
          email: _formData['email'],
          username: _formData['username'],
          password: _formData['password'],
          passwordConfirm: _formData['passwordConfirm']));
    } else {
      widget.authenticationBloc.dispatch(AuthPressed(
        email: _formData['email'],
        password: _formData['password'],
      ));
    }
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Username', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      validator: (String value) {
        // done: required,min=3,max=255,username,usernameUnique
        if (widget.authMode == AuthMode.Registration && value.isEmpty) {
          return 'Username is required.';
        } else if (widget.authMode == AuthMode.Registration &&
            (value.length < 3 || value.length > 255)) {
          return 'Username must be between 3 and 255 characters long.';
        }
      },
      onSaved: (String value) {
        _formData['username'] = value;
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        // done: (create) required,email,emailUnique, (login) required
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
        suffixIcon: _toggleObscureText(),
      ),
      obscureText: _obscureText,
      controller: widget.passwordTextController,
      validator: (String value) {
        // done: (create) required,min=6,eqfield=PasswordConfirmation, (login) required
        if (widget.authMode == AuthMode.Login &&
            (value.isEmpty || value.length < 6)) {
          return 'Invalid password.';
        } else if (widget.authMode == AuthMode.Registration &&
            value.length < 6) {
          return 'Password must be more than 6 characters long.';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        // done: required,min=6
        labelText: 'Confirm Password',
        filled: true,
        fillColor: Colors.white,
        suffixIcon: _toggleObscureText(),
      ),
      obscureText: _obscureText,
      validator: (String value) {
        if (widget.authMode == AuthMode.Registration &&
            widget.passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
      },
      onSaved: (String value) {
        _formData['passwordConfirm'] = value;
      },
    );
  }

  GestureDetector _toggleObscureText() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      child: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
        semanticLabel: _obscureText ? 'show password' : 'hide password',
      ),
    );
  }
}
