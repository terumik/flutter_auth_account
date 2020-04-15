import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_auth_account/models/account_tab.model.dart';
import './bloc.dart';

class AccountTabBloc extends Bloc<AccountTabEvent, AccountTab> {
  @override
  AccountTab get initialState => AccountTab.Account;

  @override
  Stream<AccountTab> mapEventToState(
    AccountTabEvent event,
  ) async* {
    if (event is ChangeAccountTab) {
      yield event.tab;
    }
  }
}
