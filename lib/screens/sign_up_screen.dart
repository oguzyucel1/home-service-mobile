import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_hub/main.dart';
import 'package:home_hub/screens/sign_in_screen.dart';
import 'package:home_hub/screens/splash_screen.dart';
import 'package:home_hub/utils/constant.dart';
import 'package:home_hub/utils/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../custom_widget/space.dart';
import '../utils/colors.dart';
import 'package:crypto/crypto.dart'; // For sha256

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final supabase = Supabase.instance.client;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  // ignore: unused_field
  bool _isPasswordVisible = false;
  bool agreeWithTeams = false;
  bool _securePassword = true;
  bool _secureConfirmPassword = true;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  bool? checkBoxValue = false;

  Future<void> _showAlertDialog(String message) async {
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

  Future<bool> checkUserExists(String email) async {
    final response = await supabase.from('users').select().eq('email', email);
    return response != null && response.length > 0;
  }

  Future<bool> createUser({
    required final String email,
    required final String password,
  }) async {
    try {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final session = response.session;
      final error = response;

      // ignore: unnecessary_null_comparison
      if (error != null) {
        await _showAlertDialog(error.toString());
        return false;
      }
      if (session != null) {
        return true;
      } else {
        await _showAlertDialog('Unknown error occurred');
        return false;
      }
    } catch (e) {
      print('Error during sign-up: $e');
      await _showAlertDialog('An error occurred during sign-up: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hashing function
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert string to bytes
    var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
    return digest.toString(); // Convert hash to string
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                      fontSize: mainTitleTextSize, fontWeight: FontWeight.bold),
                ),
              ),
              Space(60),
              Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.text,
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
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      style: TextStyle(fontSize: 20),
                      decoration:
                          commonInputDecoration(hintText: "Mobile Number"),
                    ),
                    Space(16),
                    TextFormField(
                      controller: _passController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _securePassword,
                      style: TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(
                        hintText: "Password",
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: IconButton(
                            icon: Icon(
                                _securePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18),
                            onPressed: () {
                              setState(() {
                                _securePassword = !_securePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Space(16),
                    TextFormField(
                      controller: _confirmPassController,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: _secureConfirmPassword,
                      style: TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(
                        hintText: "Re-enter Password",
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: IconButton(
                            icon: Icon(
                                _secureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18),
                            onPressed: () {
                              setState(() {
                                _secureConfirmPassword =
                                    !_secureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Space(16),
                    Theme(
                      data: ThemeData(
                          unselectedWidgetColor:
                              appData.isDark ? Colors.white : blackColor),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        activeColor: Colors.black,
                        title: Text("I agree to the Terms and Conditions",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        value: checkBoxValue,
                        dense: true,
                        onChanged: (newValue) {
                          setState(() {
                            checkBoxValue = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Space(16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_signUpFormKey.currentState!.validate()) {
                            if (checkBoxValue == true) {
                              final email = _emailController.text;
                              final password = _passController.text;
                              if (password == _confirmPassController.text) {
                                final userExists = await checkUserExists(email);
                                if (!userExists) {
                                  final isSuccess = await createUser(
                                      email: email, password: password);

                                  String hashedPassword =
                                      hashPassword(_passwordController.text);

                                  final response =
                                      await supabase.from('users').insert([
                                    {
                                      'phone_number':
                                          _phoneNumberController.text,
                                      'name': _fullNameController.text,
                                      'email': _emailController.text,
                                      'password': hashedPassword,
                                    }
                                  ]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplashScreen()),
                                  );
                                } else {
                                  await _showAlertDialog(
                                      'User with this email already exists');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()),
                                  );
                                }
                              } else {
                                _showAlertDialog('Passwords do not match');
                              }
                            } else {
                              _showAlertDialog(
                                  'Please agree to the terms and conditions');
                            }
                          }

                          // Şifreyi hashle

                          // Kullanıcı verisini Supabase'e ekle

                          /* final response = await supabase.from('users').insert([
                            {
                              'phone_number': _phoneNumberController.text,
                              'name': _fullNameController.text,
                              'email': _emailController.text,
                              'password': hashedPassword,
                            }
                          ]);

                          if (response.error == null) {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()));
                            });
                          } else {
                            // Hata durumu
                            print(
                                'Error signing up: ${response.error!.message}');
                          } */
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                          textStyle: TextStyle(fontSize: 25),
                          shape: StadiumBorder(),
                          backgroundColor: appData.isDark
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.black,
                        ),
                        child: Text("Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
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
                    )
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
