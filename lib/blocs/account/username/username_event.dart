import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UsernameEvent extends Equatable {
  UsernameEvent([List props = const []]) : super(props);
}

// -- LoadUsername
class LoadInitialUsername extends UsernameEvent {
  @override
  String toString() {
    return 'Update Username: LoadInitialUsername';
  }
}

// -- Submitted
class SubmitNewUsername extends UsernameEvent {
  final String newUsername;
  SubmitNewUsername({@required this.newUsername}) : super([newUsername]);

  @override
  String toString() {
    return 'Update Username: Submitted';
  }
}
