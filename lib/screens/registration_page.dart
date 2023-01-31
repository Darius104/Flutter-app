import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_front_end/screens/login_page.dart';
import 'package:flutter_front_end/screens/main_page.dart';
import 'package:flutter_front_end/services/flutter_secure_storage_class.dart';
import 'package:flutter_front_end/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_data.dart';
import '../services/api_request.dart';
import '../utils/utils.dart';
import './login_page.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void registrationFunction(context) async {
    if (_emailController.text == "" ||
        _passwordController.text == "" ||
        _nameController.text == "") {
      showAlert(
          context: context,
          messageErr: "Please enter all the field",
          title: "Warning");
      return;
    }
    final bool isValid = EmailValidator.validate(_emailController.text);
    if (!isValid) {
      showAlert(
          context: context,
          messageErr: "Email format is invalid, Please enter a valid email",
          title: "Warning");
      return;
    }

    String response = await ApiRequest.register(
        _nameController.text, _emailController.text, _passwordController.text);

    if (response.startsWith("error:")) {
      showAlert(
          context: context,
          messageErr: "Something went wrong try again",
          title: "Error");
      return;
    }
    final String token = await ApiRequest.login(
        _nameController.text, _emailController.text, _passwordController.text);

    if (token.startsWith("error:")) {
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
        builder: (context) => MainPage(),
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
                  child: Container(),
                  flex: 2,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('REGISTER',
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
                    registrationFunction(context);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent)),
                  child: const Text('Register'),
                ),
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Alredy have an account? Login",
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
