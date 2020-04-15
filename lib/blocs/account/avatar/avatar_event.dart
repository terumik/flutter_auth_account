import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AvatarEvent extends Equatable {
  AvatarEvent([List props = const []]) : super(props);
}

// -- LoadAvatar
class LoadAvatar extends AvatarEvent {
  @override
  String toString() {
    return 'LoadAvatar';
  }
}

// -- Submitted
class SubmitNewAvatar extends AvatarEvent {
  final File newAvatar;
  SubmitNewAvatar({@required this.newAvatar}) : super([newAvatar]);

  @override
  String toString() {
    return 'SubmitNewAvatar';
  }
}
