import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_account/models/account_tab.model.dart';

class AccountTabSelector extends StatelessWidget {
  final AccountTab activeTab;
  final Function(AccountTab) onTabSelected;

  AccountTabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tabs
    final tabs = const Key('__tabs__');

    return BottomNavigationBar(
      key: tabs,
      currentIndex: AccountTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AccountTab.values[index]),
      items: AccountTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            _mapTabToIcon(tab),
            key: _mapTabToKey(tab)
          ),
          title: Text(_mapTabToTitle(tab)),
        );
      }).toList(),
    );
  }

  IconData _mapTabToIcon(tab) {
    IconData icon;
    switch (tab) {
      case AccountTab.Account:
        icon = Icons.account_circle;
        break;
      case AccountTab.Connect:
        icon = Icons.link;
        break;
      case AccountTab.Preferences:
        icon = Icons.settings;
        break;
      default:
    }
    return icon;
  }

  String _mapTabToTitle(tab) {
    String title;
    switch (tab) {
      case AccountTab.Account:
        title = 'Account';
        break;
      case AccountTab.Connect:
        title = 'Connect';
        break;
      case AccountTab.Preferences:
        title = 'Preferences';
        break;
      default:
    }
    return title;
  }

  Key _mapTabToKey(tab) {
    final accountTab = const Key('__accountTab__');
    final connectTab = const Key('__connectTab__');
    final preferencesTab = const Key('__preferencesTab__');
    Key key;
    switch (tab) {
      case AccountTab.Account:
        key = accountTab;
        break;
      case AccountTab.Connect:
        key = connectTab;
        break;
      case AccountTab.Preferences:
        key = preferencesTab;
        break;
      default:
    }
    return key;
  }
}
