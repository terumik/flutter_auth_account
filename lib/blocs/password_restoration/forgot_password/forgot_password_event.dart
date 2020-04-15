import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ForgotPasswordEvent extends Equatable {
  ForgotPasswordEvent([List props = const []]) : super(props);
}

// -- Submitted
class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordSubmitted({@required this.email}) : super([email]);

  @override
  String toString() {
    return 'Submitted { email: $email}';
  }
}
