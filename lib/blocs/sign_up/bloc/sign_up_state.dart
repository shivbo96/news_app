part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final FormzStatus status;
  final Username username;
  final Password password;
  final Email email;

  const SignUpState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.email = const Email.pure(),
  });

  @override
  List<Object> get props =>
      [this.status, this.username, this.password, this.email];

  SignUpState copyWith(
      {FormzStatus? status,
      Username? username,
      Password? password,
      Email? email}) {
    return SignUpState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }
}

class SignUpInitial extends SignUpState {}
