import 'package:flutter/material.dart';
import 'package:news_app/views/widgets/common_widget.dart';
import 'package:news_app/views/widgets/login_form.dart';

import '../widgets/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.appBar(context,title:'Login'),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: LoginForm(),
      ),
    );
  }
}
