import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegPage extends StatefulWidget {
  final void Function()? onTap;
  const RegPage({super.key, this.onTap});

  @override
  State<RegPage> createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();
  Future<void> register() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      await auth.signUpWithCreds(emailController.text, passwordController.text);
    } catch (e) {
      //show error msg at bottom of screen
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Icon(
            Icons.message,
            size: 80,
          ),
          const Text(
            "Welcome",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          MyTextField(
            controller: emailController,
            hintText: "email",
            obscureText: false,
          ),
          const SizedBox(height: 10),
          MyTextField(
            controller: passwordController,
            hintText: "password",
            obscureText: true,
          ),
          MyTextField(
            controller: verifyPasswordController,
            hintText: "verify password",
            obscureText: true,
          ),
          MyButton(onTap: register, text: "Create Account"),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('already a member?'),
            SizedBox(width: 4),
            GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'Sign in now',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ])
        ],
      ),
    );
  }
}
