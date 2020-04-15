import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';

@immutable
abstract class EmailState extends Equatable {
  EmailState([List props = const []]) : super(props);
}

// -- Update Email
class UpdateEmailInitial extends EmailState {
  final String oldEmail;
  UpdateEmailInitial({@required this.oldEmail}) : super([oldEmail]);

  @override
  String toString() => 'Update Email: Initial';
}

class UpdateEmailLoading extends EmailState {
  @override
  String toString() => 'Update Email: Loading';
}

class InitialEmailLoaded extends EmailState {
  final String oldEmail;
  InitialEmailLoaded({@required this.oldEmail}) : super([oldEmail]);
  @override
  String toString() => 'Update Email: Email Loaded';
}

class UpdateEmailSubmitted extends EmailState {
  @override
  String toString() => 'Update Email: Email Submitted';
}

class UpdateEmailSuccess extends EmailState {
  final ResInfo resInfo;
  final String newEmail;
  UpdateEmailSuccess({@required this.resInfo, @required this.newEmail})
      : super([resInfo, newEmail]);

  @override
  String toString() => 'Update Email: Success';
}

class UpdateEmailFailure extends EmailState {
  final ResInfo resInfo;
  UpdateEmailFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'Update Email:Failure';
}
