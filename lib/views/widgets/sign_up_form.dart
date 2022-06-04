import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:news_app/views/widgets/colors.dart';
import 'package:news_app/views/widgets/common_widget.dart';
import 'package:news_app/views/widgets/styles.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('Authentication Failed!',style:Styles.mediumTextStyle(size: 16,color: ColorConstants.primaryDark)),
              ));
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height-100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    _UsernameInput(),
                    _EmailInput(),
                    _PasswordInput(),
                  ],
                ),

                CommonWidget.rowHeight(height: 100,),
                Column(
                  children: [
                    _SignUpButton(),
                    const SizedBox(height: 15),
                    _doNotHaveAccountText(),
                  ],
                ),

                // SizedBox(height: MediaQuery.of(context).size.aspectRatio*900,),
              ],
            ),
          ),
        ));
  }

  _doNotHaveAccountText() {
    return Text(
      "Already member? Sign In",
      style:Styles.mediumTextStyle(size: 16,color: ColorConstants.primaryDark),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            key: const Key('SignUp_Form_usernameInput_textField'),
            onChanged: (username) =>
                context.read<SignUpBloc>().add(SignUpUsernameChanged(username)),
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all( Radius.circular(5.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all( Radius.circular(5.0)),
                    borderSide:  BorderSide(color: Colors.black54)),
                labelText: 'username',
                labelStyle: Styles.regularTextStyle(color: ColorConstants.black),
                errorText: state.username.invalid ? 'Invalid username' : null),
            style:Styles.regularTextStyle(color: ColorConstants.black),),

        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: TextField(
            key: const Key('SignUp_Form_passwordInput_textField'),
            onChanged: (password) =>
                context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(5.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all( Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.black54)),
              labelText: 'password',
              labelStyle: Styles.regularTextStyle(color: ColorConstants.black),
              errorText: state.password.invalid ? 'Invalid password' : null),
            style:Styles.regularTextStyle(color: ColorConstants.black),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: TextField(
            key: const Key('SignUp_Form_Email_Input_textField'),
            onChanged: (email) =>
                context.read<SignUpBloc>().add(SignUpEmailChanged(email)),
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.black54)),
              labelText: 'Email',
              labelStyle:Styles.regularTextStyle(color: ColorConstants.black),
              errorText: state.email.invalid ? 'Invalid Email' : null),
            style:Styles.regularTextStyle(color: ColorConstants.black),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: Text(
                  'Sign Up',
                  style: Styles.semiBoldTextStyle(size: 16, color: state.status.isValidated ? Colors.white : Colors.grey)),
                onPressed: state.status.isValidated
                    ? () =>context.read<SignUpBloc>().add(const SignUpSubmitted())
                    : null,
              );
      },
    );
  }
}
