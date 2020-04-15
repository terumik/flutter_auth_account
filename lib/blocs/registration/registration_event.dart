import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegistrationEvent extends Equatable {
  RegistrationEvent([List props = const []]) : super(props);
}

// -- Submitted
class RegistrationSubmitted extends RegistrationEvent {
  final String email;
  final String username;
  final String password;
  final String passwordConfirm;

  RegistrationSubmitted(
      {@required this.email,
      @required this.username,
      @required this.password,
      @required this.passwordConfirm})
      : super([email, username, password, passwordConfirm]);

  @override
  String toString() {
    return 'Submitted { email: $email, username: $username, password: $password, confirm: $passwordConfirm }';
  }
}

// // -- DismissDialog
// class RegistrationDismissDialog extends RegistrationEvent {
//   @override
//   String toString() {
//     return 'Dialog Dismissed';
//   }
// }
