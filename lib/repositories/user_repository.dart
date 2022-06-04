import 'dart:async';
import 'package:news_app/models/user.dart';

class UserRepository {
  User? _user;


  Future<User?> getUser() async {
    if (_user != null) {
      return _user;
    }
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = const User('1','Shivam Mishra','India'),
    );
  }


}
