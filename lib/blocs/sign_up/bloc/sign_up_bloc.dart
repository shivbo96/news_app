import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app/models/values.dart';
import 'package:news_app/repositories/authentication_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async*{
    if (event is SignUpUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is SignUpPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is SignUpEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is SignUpSubmitted) {
     yield* _mapSignUpSubmittedToState(event, state);
    }
  }

  SignUpState _mapUsernameChangedToState(SignUpUsernameChanged event, SignUpState state) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, state.email, username]),
    );
  }

  SignUpState _mapPasswordChangedToState(SignUpPasswordChanged event, SignUpState state) {
    final password = Password.dirty(event.password);
    return state.copyWith(
        password: password,
        status: Formz.validate([state.username, state.email, password]));
  }

  SignUpState _mapEmailChangedToState(SignUpEmailChanged event, SignUpState state) {
    final email = Email.dirty(event.email);
    return state.copyWith(
        email: email,
        status: Formz.validate([state.username, state.password, email]));
  }

  Stream<SignUpState> _mapSignUpSubmittedToState(
    SignUpSubmitted event,
    SignUpState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.signUp(
            username: state.username.value,
            password: state.password.value,
            email: state.email.value);
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
