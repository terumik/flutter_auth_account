import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/password_restoration/forgot_password/bloc.dart';
import 'package:flutter_auth_account/blocs/password_restoration/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import 'package:flutter_auth_account/widgets/custom_ui_functions.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static UserRepository _userRepository = UserRepository();
  final ForgotPasswordBloc _forgotPasswordBloc =
      ForgotPasswordBloc(userRepository: _userRepository);

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _forgotPasswordBloc,
      listener: (BuildContext context, ForgotPasswordState state) {
        if (state is ForgotPasswordFailure) {
          CustomUI.displayDialog(context, state.resInfo);
        }
        if (state is ForgotPasswordEmailExist) {
          CustomUI.displayDialog(context, state.resInfo);
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
            ],
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    _buildForm(context),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
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

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                'FORGOT PASSWORD',
                style: TextStyle(fontSize: 25.0, color: Colors.teal),
              ),
            ),
          ),
          _buildEmailTextField(),
          SizedBox(
            height: 10,
          ),
          BlocBuilder(
            bloc: _forgotPasswordBloc,
            builder: (BuildContext context, ForgotPasswordState state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text('SUBMIT'),
                      onPressed: () {
                        _submitForm(context);
                      }),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  // todo: check if email has been sent
  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(_formData['email']);

    _forgotPasswordBloc
        .dispatch(ForgotPasswordSubmitted(email: _formData['email']));
  }
}
