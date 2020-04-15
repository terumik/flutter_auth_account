import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/account/username/bloc.dart';
import 'package:flutter_auth_account/blocs/account/email/bloc.dart';
import 'package:flutter_auth_account/blocs/account/password/bloc.dart';
import 'package:flutter_auth_account/models/firm_item.model.dart';

class FormItemBuilders {
  static Widget buildEditButton(BuildContext context, int index,
      List<FormItem> item, Function onPressed) {
    return IconButton(
        icon: item[index].displayForm
            ? Icon(
                Icons.edit,
                color: Theme.of(context).accentColor,
              )
            : Icon(Icons.edit),
        onPressed: onPressed);
  }

  static Widget buildUsernameSubtitle(
      BuildContext context, UsernameBloc _usernameBloc) {
    return BlocBuilder(
      bloc: _usernameBloc,
      builder: (BuildContext context, UsernameState state) {
        if (state is UpdateUsernameLoading) {
          return Text('Updating...');
        }
        if (state is InitialUsernameLoaded) {
          return Text(state.oldUsername);
        }
        if (state is UpdateUsernameSuccess) {
          return Text(state.newUsername);
        }
        return Text('N/A');
      },
    );
  }

  static Widget buildEmailSubtitle(BuildContext context, EmailBloc _emailBloc) {
    return BlocBuilder(
      bloc: _emailBloc,
      builder: (BuildContext context, EmailState state) {
        if (state is UpdateEmailLoading) {
          return Text('Updating...');
        }
        if (state is InitialEmailLoaded) {
          return Text(state.oldEmail);
        }
        if (state is UpdateEmailSuccess) {
          return Text(state.newEmail);
        }
        return Text('N/A');
      },
    );
  }

  static Widget buildUsernameForm(
      GlobalKey<FormState> _usernameFormKey, UsernameBloc _usernameBloc) {
    String _newUsername;
    return Form(
      key: _usernameFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Username', filled: true, fillColor: Colors.white),
            keyboardType: TextInputType.text,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a valid username.';
              } else if (value.length < 3 || value.length > 255) {
                return 'Username must be between 3 and 255 characters long.';
              }
            },
            onSaved: (String value) {
              _newUsername = value;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Submit'),
                  onPressed: () {
                    if (!_usernameFormKey.currentState.validate()) {
                      return;
                    }
                    _usernameFormKey.currentState.save();
                    _usernameBloc
                        .dispatch(SubmitNewUsername(newUsername: _newUsername));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildEmailForm(
      GlobalKey<FormState> _emailFormKey, EmailBloc _emailBloc) {
    String _newEmail;
    return Form(
      key: _emailFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
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
              print(value);
              _newEmail = value;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Submit'),
                  onPressed: () {
                    if (!_emailFormKey.currentState.validate()) {
                      return;
                    }
                    _emailFormKey.currentState.save();
                    print('submitted');
                    // todo: email is not updated in the database
                    _emailBloc.dispatch(SubmitNewEmail(newEmail: _newEmail));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPasswordForm(
    GlobalKey<FormState> _passwordFormKey,
    PasswordBloc _passwordBloc,
    bool _obscureText,
    Function onSetState,
    TextEditingController _passwordTextController,
  ) {
    return BlocBuilder(
      bloc: _passwordBloc,
      builder: (BuildContext context, PasswordState state) {
        Map<String, dynamic> _updatePasswordFormData = {
          'password': null,
          'passwordNew': null,
          'passwordNewConfirm': null,
        };

        Map<String, dynamic> _setPasswordFormData = {
          'passwordNew': null,
          'passwordNewConfirm': null,
        };

        if (state is PasswordNotSet) {
          return _buildPasswordForm(
              updatePasswordMode: false,
              passwordFormKey: _passwordFormKey,
              onSetState: onSetState,
              obscureText: _obscureText,
              passwordFormData: _setPasswordFormData,
              passwordBloc: _passwordBloc,
              passwordTextController: _passwordTextController);
        } else {
          return _buildPasswordForm(
              updatePasswordMode: true,
              passwordFormKey: _passwordFormKey,
              onSetState: onSetState,
              obscureText: _obscureText,
              passwordFormData: _updatePasswordFormData,
              passwordBloc: _passwordBloc,
              passwordTextController: _passwordTextController);
        }
      },
    );
  }

  Widget _buildPasswordForm({
    bool updatePasswordMode = true,
    GlobalKey<FormState> passwordFormKey,
    Function onSetState,
    bool obscureText,
    Map<String, dynamic> passwordFormData,
    PasswordBloc passwordBloc,
    TextEditingController passwordTextController,
  }) {
    return Form(
      key: passwordFormKey,
      child: Column(
        children: <Widget>[
          updatePasswordMode
              ? TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: _toggleObscureText(onSetState, obscureText),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: obscureText,
                  validator: (String value) {
                    if (value.isEmpty && updatePasswordMode) {
                      return 'Please enter a valid password.';
                    } else if (value.length < 6 && updatePasswordMode) {
                      return 'Password must be more than 6 characters long.';
                    }
                  },
                  onSaved: (String value) {
                    passwordFormData['password'] = value;
                    print('current password: ' + value);
                  },
                )
              : Container(),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'New Password',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: _toggleObscureText(onSetState, obscureText),
            ),
            keyboardType: TextInputType.text,
            obscureText: obscureText,
            controller: passwordTextController,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a valid password.';
              } else if (value.length < 6) {
                return 'Password must be more than 6 characters long.';
              }
            },
            onSaved: (String value) {
              passwordFormData['passwordNew'] = value;
              print('passwordNew: ' + value);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: _toggleObscureText(onSetState, obscureText),
            ),
            keyboardType: TextInputType.text,
            obscureText: obscureText,
            validator: (String value) {
              if (passwordTextController.text != value) {
                return 'Passwords do not match.';
              }
            },
            onSaved: (String value) {
              passwordFormData['passwordNewConfirm'] = value;
              print('passwordNewConfirm: ' + value);
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Submit'),
                  onPressed: () {
                    if (!passwordFormKey.currentState.validate()) {
                      return;
                    }
                    passwordFormKey.currentState.save();
                    print('submitted');
                    if (updatePasswordMode) {
                      passwordBloc.dispatch(
                        SubmitUpdatePassword(
                            password: passwordFormData['password'],
                            passwordNew: passwordFormData['passwordNew'],
                            passwordNewConfirm:
                                passwordFormData['passwordNewConfirm']),
                      );
                    } else {
                      passwordBloc.dispatch(
                        SubmitSetPassword(
                            password: passwordFormData['passwordNew'],
                            passwordConfirm:
                                passwordFormData['passwordNewConfirm']),
                      );
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector _toggleObscureText(Function onSetState, bool _obscureText) {
    return GestureDetector(
      onTap: onSetState,
      child: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
        semanticLabel: _obscureText ? 'show password' : 'hide password',
      ),
    );
  }
}
