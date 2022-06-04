part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpUsernameChanged extends SignUpEvent {
  final String username;

  const SignUpUsernameChanged(this.username);

  @override
  List<Object> get props => [this.username];
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  const SignUpPasswordChanged(this.password);

  @override
  List<Object> get props => [this.password];
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  const SignUpEmailChanged(this.email);

  @override
  List<Object> get props => [this.email];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
