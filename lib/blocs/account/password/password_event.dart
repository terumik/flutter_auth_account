import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PasswordEvent extends Equatable {
  PasswordEvent([List props = const []]) : super(props);
}

// -- Check Password is Set
class CheckPasswordIsSet extends PasswordEvent {
  @override
  String toString() {
    return 'Set Password: CheckPasswordIsSet';
  }
}

// -- Submitted Set Password
class SubmitSetPassword extends PasswordEvent {
  final String password;
  final String passwordConfirm;
  SubmitSetPassword({@required this.password, @required this.passwordConfirm})
      : super([password, passwordConfirm]);

  @override
  String toString() {
    return 'Set Password: Submitted';
  }
}

// -- Submitted Update Password
class SubmitUpdatePassword extends PasswordEvent {
  final String password;
  final String passwordNew;
  final String passwordNewConfirm;
  SubmitUpdatePassword(
      {@required this.password,
      @required this.passwordNew,
      @required this.passwordNewConfirm})
      : super([password, passwordNew, passwordNewConfirm]);

  @override
  String toString() {
    return 'Update Password: Submitted';
  }
}
