import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/account_tab.model.dart';

@immutable
abstract class AccountTabEvent extends Equatable {
  AccountTabEvent([List props = const []]) : super(props);
}

class ChangeAccountTab extends AccountTabEvent {
  final AccountTab tab;
  ChangeAccountTab(this.tab) : super([tab]);

  @override
  String toString() => 'ChangeAccountTab { tab: $tab }';
}