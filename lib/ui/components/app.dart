import 'package:cleanflutterapp/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 6, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: '4dev',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        backgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColorLight)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            alignLabelWithHint: true),
        buttonTheme: ButtonThemeData(
          colorScheme: const ColorScheme.light(primary: primaryColor),
          buttonColor: primaryColor,
          splashColor: primaryColorLight,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          textTheme: ButtonTextTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: primaryColorDark)),
      ),
    );
  }
}
