import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_account/blocs/account_tab/account_tab_bloc.dart';
import 'package:flutter_auth_account/blocs/account_tab/bloc.dart';
import 'package:flutter_auth_account/blocs/authentication/bloc.dart';
import 'package:flutter_auth_account/models/account_tab.model.dart';
import 'package:flutter_auth_account/widgets/account/tab_selector.dart';
import 'package:flutter_auth_account/widgets/side_drawer.dart/side_drawer.dart';

import './account_setting.screen.dart';
import './connect.screen.dart';
import './preferences.screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountScreenState();
  }
}

class _AccountScreenState extends State<AccountScreen> {
  final _accountTabBloc = AccountTabBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      listener: (BuildContext context, AuthenticationState state) {
        // note: listen to the authentication state and auto-login/out
        // todo: error screen shown when logout from this page (auto-logout does not have this bug)
        if (state is! Authenticated) {
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
            ],
          ),
        ),
        drawer: BlocBuilder(
            bloc: BlocProvider.of<AuthenticationBloc>(context),
            builder: (BuildContext context, AuthenticationState state) {
              if (state is Authenticated) {
                return SideDrawer();
              }
            }),
        body: BlocBuilder(
          bloc: _accountTabBloc,
          builder: (BuildContext context, AccountTab activeTab) {
            switch (activeTab) {
              case AccountTab.Account:
                return AccountSettingScreen();
                break;
              case AccountTab.Connect:
                return ConnectScreen();
                break;
              case AccountTab.Preferences:
                return PreferencesScreen();
                break;
              default:
            }
          },
        ),
        bottomNavigationBar: BlocBuilder(
          bloc: _accountTabBloc,
          builder: (BuildContext context, AccountTab activeTab) {
            return AccountTabSelector(
              activeTab: activeTab,
              // -- dispatch
              onTabSelected: (tab) =>
                  _accountTabBloc.dispatch(ChangeAccountTab(tab)),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountTabBloc.dispose();
    super.dispose();
  }
}
