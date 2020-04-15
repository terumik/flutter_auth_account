import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/auth_mode.model.dart';

@immutable
abstract class AuthTabEvent extends Equatable {
  AuthTabEvent([List props = const []]) : super(props);
}


class ChangeAuthMode extends AuthTabEvent {
  final AuthMode mode;
  ChangeAuthMode(this.mode) : super([mode]);

  @override
  String toString() => 'UpdateTab { tab: $mode }';
}