import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:home_hub/components/my_scroll_behaviour.dart';
import 'package:home_hub/screens/splash_screen.dart';
import 'package:home_hub/utils/colors.dart';
import 'package:home_hub/utils/constant.dart';
import 'store/appData.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

AppData appData = AppData();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  configureDependencies();

  await Supabase.initialize(
    url: 'https://iahnabhvhgqonoxxkjbo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlhaG5hYmh2aGdxb25veHhramJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQ5OTM2MTksImV4cCI6MjAzMDU2OTYxOX0.OOSrHNrKX_CO5zsW4Qo6L3jsjQTEdJLNOmf6LOCf9S4',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

void configureDependencies() {}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return MaterialApp(
          scrollBehavior: MyScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: primaryColor,
              onPrimary: whiteColor,
              secondary: secondaryColor,
              onSecondary: secondaryColor,
              error: redColor,
              onError: redColor,
              background: whiteColor,
              onBackground: whiteColor,
              surface: whiteColor,
              onSurface: blackColor,
            ),
            primaryColor: primaryColor,
            secondaryHeaderColor: whiteColor,
            iconTheme: IconThemeData(color: primaryColor),
            tabBarTheme: TabBarTheme(labelColor: Colors.black),
            listTileTheme: ListTileThemeData(iconColor: blackColor),
            brightness: Brightness.light,
            dividerColor: transparent,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: primaryColor),
              titleTextStyle: TextStyle(color: primaryColor),
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: whiteColor,
              selectedItemColor: bottomSelectedColor,
              unselectedItemColor: bottomUnselectedColor,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Colors.black,
              onPrimary: Colors.white,
              secondary: secondaryColor,
              onSecondary: secondaryColor,
              error: redColor,
              onError: redColor,
              background: whiteColor,
              onBackground: whiteColor,
              surface: greyColor,
              onSurface: blackColor,
            ),
            primaryColor: whiteColor,
            secondaryHeaderColor: primaryColor,
            iconTheme: IconThemeData(color: whiteColor),
            brightness: Brightness.dark,
            tabBarTheme: TabBarTheme(labelColor: Colors.white),
            listTileTheme: ListTileThemeData(iconColor: whiteColor),
            dividerColor: transparent,
            dialogTheme: DialogTheme(
              backgroundColor: Colors.grey,
              titleTextStyle: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              contentTextStyle: TextStyle(color: Colors.black),
            ),
            expansionTileTheme: ExpansionTileThemeData(
                iconColor: whiteColor, textColor: whiteColor),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.shade500,
            ),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: whiteColor),
              titleTextStyle: TextStyle(color: whiteColor),
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light),
            ),
          ),
          themeMode: appData.mode,
          home: SplashScreen(),
        );
      },
    );
  }
}
