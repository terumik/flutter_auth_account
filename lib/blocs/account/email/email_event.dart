import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EmailEvent extends Equatable {
  EmailEvent([List props = const []]) : super(props);
}

// -- LoadEmail
class LoadInitialEmail extends EmailEvent {
  @override
  String toString() {
    return 'Update Email: LoadInitialEmail';
  }
}

// -- Submitted
class SubmitNewEmail extends EmailEvent {
  final String newEmail;
  SubmitNewEmail({@required this.newEmail}) : super([newEmail]);

  @override
  String toString() {
    return 'Update Email: Submitted';
  }
}