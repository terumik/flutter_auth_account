import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/account/username/bloc.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import 'package:flutter_auth_account/widgets/side_drawer.dart/logout_list_tile.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SideDrawerState();
  }
}

class SideDrawerState extends State<SideDrawer> {
  final UserRepository _userRepository = UserRepository();
  static UsernameBloc _usernameBloc;

  @override
  void initState() {
    _usernameBloc = UsernameBloc(userRepository: _userRepository);
    _usernameBloc.dispatch(LoadInitialUsername());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            leading: Container(
              margin: EdgeInsets.all(6),
              child: CircleAvatar(
                // todo: display avatar or placeholder
                backgroundImage: NetworkImage('http://placekitten.com/40/40'),
              ),
            ),
            title: _buildUsernameSubtitle(context),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/account');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  static Widget _buildUsernameSubtitle(BuildContext context) {
    return BlocBuilder(
      bloc: _usernameBloc,
      builder: (BuildContext context, UsernameState state) {
        if (state is InitialUsernameLoaded) {
          return Text(state.oldUsername);
        }
        return Text('N/A');
      },
    );
  }
}
