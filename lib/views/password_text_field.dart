import 'package:flutter/material.dart';
import 'package:testingbloc_course/strings.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextField({Key? key, required this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: Strings.enterYourPasswordHere,
      ),
    );
  }
}
