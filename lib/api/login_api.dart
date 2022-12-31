import 'package:flutter/foundation.dart';
import 'package:testingbloc_course/models/models.dart';

@immutable
abstract class LoginApiProtocol {
  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  //Singleton pattern
  const LoginApi._sharedInstance();
  static const LoginApi _instance = LoginApi._sharedInstance();
  factory LoginApi.instance() => _instance;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar',
      ).then((isLoggedIn) => isLoggedIn ? const LoginHandle.fooBar() : null);
}
