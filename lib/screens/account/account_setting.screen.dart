import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_auth_account/blocs/account/avatar/bloc.dart';
import 'package:flutter_auth_account/blocs/account/email/bloc.dart';
import 'package:flutter_auth_account/blocs/account/password/bloc.dart';
import 'package:flutter_auth_account/blocs/account/username/bloc.dart';
import 'package:flutter_auth_account/models/firm_item.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import 'package:flutter_auth_account/widgets/account/form_item_builders.dart';
import 'package:flutter_auth_account/widgets/custom_ui_functions.dart';

class AccountSettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccountSettingScreenState();
  }
}

class AccountSettingScreenState extends State<AccountSettingScreen> {
  UserRepository _userRepository;
  UsernameBloc _usernameBloc;
  EmailBloc _emailBloc;
  PasswordBloc _passwordBloc;
  AvatarBloc _avatarBloc;

  GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  bool _obscureText = true;
  final TextEditingController _passwordTextController = TextEditingController();

  bool _toggleUpdateImageMode = false;
  File _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  List<FormItem> _formItems;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _usernameBloc = UsernameBloc(userRepository: _userRepository);
    _emailBloc = EmailBloc(userRepository: _userRepository);
    _passwordBloc = PasswordBloc(userRepository: _userRepository);
    _avatarBloc = AvatarBloc(userRepository: _userRepository);
    _usernameBloc.dispatch(LoadInitialUsername());
    _emailBloc.dispatch(LoadInitialEmail());
    _passwordBloc.dispatch(CheckPasswordIsSet());
    _avatarBloc.dispatch(LoadAvatar());

    _formItems = [
      // -- avatar
      FormItem(
        key: 'avatar',
        title: 'Avatar',
        subtitleBuilder: _buildEmptySubtitle,
        formBuilder: () => Container(),
      ),
      // -- email
      FormItem(
        key: 'title',
        title: 'Email',
        subtitleBuilder: _buildEmailSubtitle,
        formBuilder: _emailFormBuilder,
      ),
      // -- username
      FormItem(
        key: 'username',
        title: 'Username',
        subtitleBuilder: _buildUsernameSubtitle,
        formBuilder: _usernameFormBuilder,
      ),
      // -- password
      FormItem(
        key: 'password',
        title: 'Password',
        subtitleBuilder: _buildEmptySubtitle,
        formBuilder: _passwordFormBuilder,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // -- display alart
    return BlocListenerTree(
      blocListeners: [
        BlocListener<UsernameEvent, UsernameState>(
          bloc: _usernameBloc,
          listener: (BuildContext context, UsernameState state) {
            if (state is UpdateUsernameFailure) {
              CustomUI.displayDialog(context, state.resInfo);
            }
            if (state is UpdateUsernameSuccess) {
              CustomUI.displayDialog(context, state.resInfo);
              _usernameFormKey.currentState.reset();
            }
          },
        ),
        BlocListener<EmailEvent, EmailState>(
          bloc: _emailBloc,
          listener: (BuildContext context, EmailState state) {
            if (state is UpdateEmailFailure) {
              CustomUI.displayDialog(context, state.resInfo);
            }
            if (state is UpdateEmailSuccess) {
              CustomUI.displayDialog(context, state.resInfo);
              _emailFormKey.currentState.reset();
            }
          },
        ),
        BlocListener<PasswordEvent, PasswordState>(
          bloc: _passwordBloc,
          listener: (BuildContext context, PasswordState state) {
            if (state is UpdatePasswordFailure) {
              CustomUI.displayDialog(context, state.resInfo);
            }
            if (state is UpdatePasswordSuccess) {
              CustomUI.displayDialog(context, state.resInfo);
              _passwordFormKey.currentState.reset();
              _passwordTextController.clear();
            }
            if (state is SetPasswordFailure) {
              CustomUI.displayDialog(context, state.resInfo);
            }
            if (state is SetPasswordSuccess) {
              CustomUI.displayDialog(context, state.resInfo);
              _passwordFormKey.currentState.reset();
              _passwordTextController.clear();
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(_formItems[index].title),
                    subtitle: _formItems[index].subtitleBuilder(context),
                    trailing: _formItems[index].key == 'avatar'
                        ? Container(width: 1)
                        : _buildEditButton(context, index, _formItems),
                  ),
                  _formItems[index].key == 'avatar'
                      ? _buildAvatarForm()
                      : Container(),
                  _formItems[index].displayForm
                      ? _formItems[index].formBuilder()
                      : Container(),
                  Divider(color: Colors.black87),
                ],
              );
            },
            itemCount: _formItems.length,
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(
      BuildContext context, int index, List<FormItem> item) {
    Function onPressed = () {
      setState(() {
        item[index].displayForm = !item[index].displayForm;
      });
    };
    return FormItemBuilders.buildEditButton(context, index, item, onPressed);
  }

  @override
  void dispose() {
    _usernameBloc.dispose();
    _emailBloc.dispose();
    _passwordBloc.dispose();
    super.dispose();
  }

  // -- Subtitles
  Widget _buildUsernameSubtitle(BuildContext context) {
    return FormItemBuilders.buildUsernameSubtitle(context, _usernameBloc);
  }

  Widget _buildEmailSubtitle(BuildContext context) {
    return FormItemBuilders.buildEmailSubtitle(context, _emailBloc);
  }

  Widget _buildEmptySubtitle(BuildContext context) {
    return Container();
  }

  // -- Forms
  Widget _emailFormBuilder() {
    return FormItemBuilders.buildEmailForm(_emailFormKey, _emailBloc);
  }

  Widget _usernameFormBuilder() {
    return FormItemBuilders.buildUsernameForm(_usernameFormKey, _usernameBloc);
  }

  Widget _passwordFormBuilder() {
    Function onSetState = () {
      setState(() {
        _obscureText = !_obscureText;
      });
    };
    return FormItemBuilders().buildPasswordForm(
      _passwordFormKey,
      _passwordBloc,
      _obscureText,
      onSetState,
      _passwordTextController,
    );
  }

  // -- Avatar related
  // todo: move to external file
  Widget _buildAvatarForm() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          // todo: display avatar or placeholder
          _previewImage(),
          SizedBox(width: 10),
          _toggleUpdateImageMode ? Container() : _buildAvatarOptionsWidget(),
          _toggleUpdateImageMode ? _buildUploadImageWidget() : Container()
        ],
      ),
    );
  }

  Widget _buildAvatarOptionsWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            child: Text('Select Image'),
            onPressed: () {
              setState(() {
                _toggleUpdateImageMode = !_toggleUpdateImageMode;
              });
              _onSelectImage(ImageSource.gallery);
            },
          ),
          SizedBox(width: 10),
          RaisedButton(
            child: Text('Delete'),
            onPressed: () {
              // todo: dispatch delete file
              print('delete tapped');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadImageWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Upload'),
            onPressed: () {
              print('upload tapped');
              // todo: dispach upload
              _avatarBloc.dispatch(SubmitNewAvatar(newAvatar: _imageFile));
            },
          ),
          RaisedButton(
            child: Text('Cancel'),
            onPressed: () {
              setState(() {
                _toggleUpdateImageMode = !_toggleUpdateImageMode;
                _imageFile = null;
              });
            },
          ),
        ],
      ),
    );
  }

  void _onSelectImage(ImageSource source) async {
    try {
      File imageFile = await ImagePicker.pickImage(source: source);
      setState(() {
        _imageFile = imageFile;
      });
    } catch (e) {
      _pickImageError = e;
    }
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return ClipRect(
        child: Image.file(
          _imageFile,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Select an Avatar',
        textAlign: TextAlign.center,
      );
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

