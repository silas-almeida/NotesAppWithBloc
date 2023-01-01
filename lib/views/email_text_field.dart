import 'package:flutter/material.dart';
import 'package:testingbloc_course/strings.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailTextField({Key? key, required this.emailController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: Strings.enterYourEmailHere,
      ),
    );
  }
}