import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/authentication/bloc.dart';
import 'package:flutter_auth_account/widgets/side_drawer.dart/side_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      listener: (BuildContext context, AuthenticationState state) {
        // note: listen to the authentication state and auto-login/out
        if (state is! Authenticated) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: BlocBuilder(
            bloc: BlocProvider.of<AuthenticationBloc>(context),
            builder: (BuildContext context, AuthenticationState state) {
              if (state is Authenticated) {
                return SideDrawer();
              }
            }),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Home Page'),
                BlocBuilder(
                  bloc: BlocProvider.of<AuthenticationBloc>(context),
                  builder: (BuildContext context, AuthenticationState state) {
                    if (state is Authenticated) {
                      return Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text('Hello, ' + state.authenticatedUser.username),
                          Text(state.authenticatedUser.email),
                          Text(state.authenticatedUser.avaterId == null
                              ? 'avater is not set'
                              : state.authenticatedUser.avaterId),
                          SizedBox(height: 20),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).dispatch(
                      LoggedOut(),
                    );
                  },
                  child: Text('Logout'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/change_password');
                  },
                  child: Text('Change Password'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
