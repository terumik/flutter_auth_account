import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';

@immutable
abstract class AvatarState extends Equatable {
  AvatarState([List props = const []]) : super(props);
}

class InitialAvatarState extends AvatarState {
  final String token; // todo: token? avatarID?
  InitialAvatarState({@required this.token}) : super([token]);

  @override
  String toString() => 'InitialAvatarState';
}

class AvatarLoading extends AvatarState {
  @override
  String toString() => 'AvatarLoading';
}

class AvatarLoaded extends AvatarState {
  final String oldUsername;
  AvatarLoaded({@required this.oldUsername}) : super([oldUsername]);
  @override
  String toString() => 'AvatarLoaded';
}

class AvatarSubmitted extends AvatarState {
  @override
  String toString() => 'AvatarSubmitted';
}

class UpdateAvatarSuccess extends AvatarState {
  final ResInfo resInfo;
  final String newAvatar; // todo: get response for new avatar (check the type)
  UpdateAvatarSuccess({@required this.resInfo, @required this.newAvatar})
      : super([resInfo, newAvatar]);

  @override
  String toString() => 'UpdateAvatarSuccess';
}

class UpdateAvatarFailure extends AvatarState {
  final ResInfo resInfo;
  UpdateAvatarFailure({@required this.resInfo}) : super([resInfo]);

  @override
  String toString() => 'UpdateAvatarFailure';
}
