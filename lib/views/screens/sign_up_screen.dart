import 'package:flutter/material.dart';
import 'package:news_app/views/widgets/sign_up_form.dart';

import '../widgets/common_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CommonWidget.appBar(context,title: 'sign up',backIcon: Icons.arrow_back_ios),
      body: const SignUpForm(),
    );
  }
}
