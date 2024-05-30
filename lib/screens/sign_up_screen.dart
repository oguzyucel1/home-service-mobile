import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_hub/screens/splash_screen.dart';
import 'package:supabase/supabase.dart'; // Import Supabase SDK
import 'package:home_hub/main.dart';
import 'package:home_hub/screens/otp_verification_screen.dart';
import 'package:home_hub/screens/sign_in_screen.dart';
import 'package:home_hub/utils/constant.dart';
import 'package:home_hub/utils/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../custom_widget/space.dart';
import '../utils/colors.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart'; // For sha256

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreeWithTerms = false;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert string to bytes
    var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
    return digest.toString(); // Convert hash to string
  }

  Future<void> _showAlertDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [Text(message)],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_agreeWithTerms) {
      _showAlertDialog(context, 'Please agree to the terms and conditions');
      return;
    }

    if (password != confirmPassword) {
      _showAlertDialog(context, 'Passwords do not match');
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
    final response =
        await supabase.auth.signUp(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Space(42),
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: mainTitleTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Space(60),
              Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 16),
                      decoration: commonInputDecoration(hintText: "Username"),
                    ),
                    Space(16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(hintText: "Email"),
                    ),
                    Space(16),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      style: TextStyle(fontSize: 20),
                      decoration:
                          commonInputDecoration(hintText: "Mobile Number"),
                    ),
                    Space(16),
                    TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      style: TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(
                        hintText: "Password",
                      ),
                    ),
                    Space(16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      style: TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(
                        hintText: "Re-enter Password",
                      ),
                    ),
                    Space(16),
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            appData.isDark ? Colors.white : blackColor,
                      ),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        activeColor: Colors.black,
                        title: Text(
                          "I agree to the Terms and Conditions",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        value: _agreeWithTerms,
                        dense: true,
                        onChanged: (newValue) {
                          setState(() {
                            _agreeWithTerms = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Space(16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                          textStyle: TextStyle(fontSize: 25),
                          shape: StadiumBorder(),
                          backgroundColor: appData.isDark
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.black,
                        ),
                        onPressed: _signUp,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Space(20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Have an account?",
                              style: TextStyle(fontSize: 16)),
                          Space(4),
                          Text('Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
