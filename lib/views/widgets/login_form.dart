import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news_app/blocs/login/bloc/login_bloc.dart';
import 'package:news_app/views/screens/sign_up_screen.dart';
import 'package:news_app/views/widgets/colors.dart';
import 'package:news_app/views/widgets/common_widget.dart';
import 'package:news_app/views/widgets/styles.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('Authentication Failed!',
                  style:Styles.mediumTextStyle(size: 16,color: ColorConstants.primaryDark)),
              ));
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CommonWidget.rowHeight(),
                  _UsernameInput(),
                  _PasswordInput(),
                  _forgotPasswordText(context),
                ],
              ),
              CommonWidget.rowHeight(height: 250,),
              Column(
                children: [
                  _LoginButton(),
                  const SizedBox(height: 15),
                  _doNotHaveAccountText(context),
                ],
              ),
            ],
          ),
        ));
  }

  _forgotPasswordText(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 12,
      ),
      width: MediaQuery.of(context).size.width,
      child: Text(
        "Forgot Password",
        textAlign: TextAlign.end,
        style: Styles.semiBoldTextStyle(color: ColorConstants.primaryDark, size: 16)
      ),
    );
  }

  _doNotHaveAccountText(BuildContext context) {
    return InkWell(
      onTap: () =>Navigator.push(context, SignUpScreen.route()),
      child: Text(
        "You don't have an account? Sign Up",
        style:Styles.mediumTextStyle(size: 16,color: ColorConstants.primaryDark),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
          child: TextField(
            key: const Key('loginForm_usernameInput_textField'),
            onChanged: (username) =>
                context.read<LoginBloc>().add(LoginUsernameChanged(username)),
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderRadius:  BorderRadius.all(Radius.circular(5.0)),
                    borderSide:  BorderSide(color: Colors.black54)),
                labelText: 'username',
                labelStyle: Styles.regularTextStyle(color: ColorConstants.black),
                errorText: state.username.invalid ? 'Invalid username' : null),
            style:  Styles.regularTextStyle(color: ColorConstants.black),
          ),

        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(5.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.black54)),
              labelText: 'password',
              labelStyle: Styles.regularTextStyle(color: ColorConstants.black),
              errorText: state.password.invalid ? 'Invalid password' : null,
            ),
            style:  Styles.regularTextStyle(color: ColorConstants.black),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: Text(
                  'Sign In',
                  style: Styles.semiBoldTextStyle(size: 16, color: state.status.isValidated ? Colors.white : Colors.grey)),
                onPressed: state.status.isValidated
                    ? () => context.read<LoginBloc>().add(const LoginSubmitted())
                    : null,
              );
      },
    );
  }
}
