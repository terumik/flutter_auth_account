import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';

@immutable
abstract class UsernameState extends Equatable {
  UsernameState([List props = const []]) : super(props);
}

// -- Update Username
class UpdateUsernameInitial extends UsernameState {
  final String oldUsername;
  UpdateUsernameInitial({@required this.oldUsername}) : super([oldUsername]);

  @override
  String toString() => 'Update Username: Initial';
}

class UpdateUsernameLoading extends UsernameState {
  @override
  String toString() => 'Update Username: Loading';
}

class InitialUsernameLoaded extends UsernameState {
  final String oldUsername;
  InitialUsernameLoaded({@required this.oldUsername}) : super([oldUsername]);
  @override
  String toString() => 'Update Username: Username Loaded';
}

class UpdateUsernameSubmitted extends UsernameState {
  @override
  String toString() => 'Update Username: Username Submitted';
}

class UpdateUsernameSuccess extends UsernameState {
  final ResInfo resInfo;
  final String newUsername;
  UpdateUsernameSuccess({@required this.resInfo, @required this.newUsername})
      : super([resInfo, newUsername]);

  @override
  String toString() => 'Update Username: Success';
}

class UpdateUsernameFailure extends UsernameState {
  final ResInfo resInfo;
  UpdateUsernameFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Update Username:Failure';
}
