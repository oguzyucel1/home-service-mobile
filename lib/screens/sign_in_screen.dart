import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_hub/screens/dashboard_screen.dart';
import 'package:home_hub/screens/my_profile_screen.dart';
import 'package:home_hub/screens/service_screen.dart';
import 'package:home_hub/screens/sign_up_screen.dart';
import 'package:home_hub/screens/splash_screen.dart';
import 'package:home_hub/screens/walk_through_screen.dart';
import 'package:home_hub/utils/constant.dart';
import 'package:home_hub/utils/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../custom_widget/space.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gotrue/src/types/auth_response.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

bool _securePassword = true;

class _SignInScreenState extends State<SignInScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  // ignore: unused_field
  Country? _selectedCountry;

  final supabase = Supabase.instance.client;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCountry();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    _selectedCountry = country;
    setState(() {});
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerSheet(context);
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashBoardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<AuthResponse> _googleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '410736303703-9hve0hetius0840p10rmn0ro40ku9jo8.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '410736303703-ms3l0kgcmp15i7k8q0vffdash6pvc1fv.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness:
              appData.isDark ? Brightness.light : Brightness.dark),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Space(60),
                    Text("Welcome back!",
                        style: TextStyle(
                            fontSize: mainTitleTextSize,
                            fontWeight: FontWeight.bold)),
                    Space(8),
                    Text("Please Login to your account",
                        style: TextStyle(fontSize: 14, color: subTitle)),
                    Space(16),
                    Image.asset(splash_logo,
                        width: 100, height: 100, fit: BoxFit.cover),
                  ],
                ),
                Space(70),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 20),
                  decoration: commonInputDecoration(hintText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                Space(16),
                TextFormField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                Space(32),
                ElevatedButton(
                  onPressed: () async {
                    if (_loginFormKey.currentState!.validate()) {
                      await signIn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    textStyle: TextStyle(fontSize: 25),
                    shape: StadiumBorder(),
                    backgroundColor: appData.isDark
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.black,
                  ),
                  child: Text("Sign In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
                ),
                Space(32),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                              thickness: 1.2,
                              color: Colors.grey.withOpacity(0.2))),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Text("Or Login With",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Expanded(
                          child: Divider(
                              thickness: 1.2,
                              color: Colors.grey.withOpacity(0.2))),
                    ],
                  ),
                ),
                Space(32),
                IconButton(
                  icon: Image.asset('assets/icons/ic_google.png',
                      scale: 24,
                      color: appData.isDark ? blackColor : blackColor),
                  onPressed: () async {
                    try {
                      await _googleSignIn(); // Google Sign-In işlemini gerçekleştir
                    } catch (error) {
                      // Google Sign-In sırasında bir hata oluşursa burada işleyebilirsiniz
                      print('Google Sign-In Hatası: $error');
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUpScreen()), //  butonun çalışıp çalışmadığını görmek için
                      );*/
                    }
                  },

                  // Butona tıklanınca yapılacak işlemler buraya yazılacak
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Image.asset(icGoogle,
                        scale: 24,
                        color: appData.isDark ? blackColor : blackColor),
                    Space(40),*/
                    Image.asset(icInstagram,
                        scale: 24,
                        color: appData.isDark ? blackColor : blackColor),
                  ],
                ),
                Space(32),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?",
                          style: TextStyle(fontSize: 16)),
                      Space(4),
                      Text('Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
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
