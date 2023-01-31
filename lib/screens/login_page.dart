import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_front_end/screens/main_page.dart';
import 'package:flutter_front_end/services/flutter_secure_storage_class.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import '../models/user_data.dart';
import '../services/api_request.dart';
import './registration_page.dart';
import '../utils/utils.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void loginFunction(context) async {
    if (_nameController.text == "" ||
        _emailController.text == "" ||
        _passwordController.text == "") {
      showAlert(
          context: context,
          messageErr: "Please enter all the field",
          title: "Warning");
      return;
    }
    final bool isValid = EmailValidator.validate(_emailController.text);
    if (!isValid) {
      showAlert(
          context: context, messageErr: "Email is not valid", title: "Warning");
      return;
    }

    final String token = await ApiRequest.login(
        _nameController.text, _emailController.text, _passwordController.text);

    if (token.startsWith("error:")) {
      if (token.contains("Invalid credentials")) {
        showAlert(
            context: context,
            messageErr: "Email or password are not correct",
            title: "Error");
        return;
      }
      showAlert(
          context: context,
          messageErr: "Something went wrong try again",
          title: "Error");
      return;
    }

    await FlutterSecureStorageClass().createJWT(token);
    Provider.of<UserData>(context, listen: false)
        .getUserData(email: _emailController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('LOGIN',
                        textStyle: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 35.0,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                  totalRepeatCount: 100,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(hintText: 'Name...'),
                  controller: _nameController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(hintText: 'Email...'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(hintText: 'Password...'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () {
                    loginFunction(context);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent)),
                  child: const Text('login'),
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sing up",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
