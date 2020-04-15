import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/password_restoration/change_password/bloc.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import 'package:flutter_auth_account/widgets/custom_ui_functions.dart';

class ChangePasswordScreen extends StatefulWidget {
  final urlToken;
  ChangePasswordScreen(this.urlToken);

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // todo: get token somehow from main
  final Map<String, dynamic> _formData = {
    'password': null,
    'passwordConfirm': null,
    'urlToken': null // todo: not necessary in formData?
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _obscureText = true;

  UserRepository _userRepository;
  ChangePasswordBloc _changePasswordBloc;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _changePasswordBloc = ChangePasswordBloc(userRepository: _userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _changePasswordBloc,
      listener: (BuildContext context, ChangePasswordState state) {
        if (state is ChangePasswordFailure) {
          CustomUI.displayDialog(context, state.resInfo);
        }
        if (state is ChangePasswordSuccess) {
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
                        _buildForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
        suffixIcon: _toggleObscureText(),
      ),
      obscureText: _obscureText,
      controller: _passwordTextController,
      validator: (String value) {
        // done: (create) required,min=6,eqfield=PasswordConfirmation
        if (value.isEmpty || value.length < 6) {
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
        if (_passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
      },
      onSaved: (String value) {
        _formData['passwordConfirm'] = value;
      },
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildPasswordTextField(),
          _buildConfirmPasswordTextField(),
          SizedBox(
            height: 10,
          ),
          BlocBuilder(
            bloc: _changePasswordBloc,
            builder: (BuildContext context, ChangePasswordState state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text('SUBMIT'),
                      onPressed: () {
                        _submitForm();
                      }),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  // todo: functionality with real token
  void _submitForm() async {
    // done: enable this if() for validation
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    _changePasswordBloc.dispatch(ChangePasswordSubmitted(
        password: _formData['password'],
        passwordConfirm: _formData['passwordConfirm'],
        urlToken: widget.urlToken));
  }

    @override
  void dispose() {
    _changePasswordBloc.dispose();
    super.dispose();
  }
}
