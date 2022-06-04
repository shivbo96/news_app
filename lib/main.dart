import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/blocs/home/bloc/home_bloc.dart';
import 'package:news_app/repositories/authentication_repository.dart';
import 'package:news_app/repositories/user_repository.dart';
import 'package:news_app/views/screens/home_screen.dart';
import 'package:news_app/views/screens/login_screen.dart';
import 'package:news_app/views/screens/news_detail_page.dart';
import 'package:news_app/views/screens/splash_screen.dart';

import 'blocs/authentication/bloc/authentication_bloc.dart';
import 'blocs/login/bloc/login_bloc.dart';
import 'blocs/sign_up/bloc/sign_up_bloc.dart';
import 'di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjections();
  runApp(MyApp(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  const MyApp(
      {Key? key,
      required this.authenticationRepository,
      required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
            authenticationRepository: authenticationRepository,
            userRepository: userRepository),
        child: MainApp(),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  MainApp({Key? key}) : super(key: key);

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) {
              return SignUpBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context));
            },
          ),
          BlocProvider(create: (context) =>HomeBloc())
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        HomeScreen.route(), (route) => false);
                    break;
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        LoginScreen.route(), (route) => false);
                    break;
                  default:
                    break;
                }
              },
              child: child,
            );
          },
          onGenerateRoute: (_) => SplashScreen.route(),
        ));
  }
}
