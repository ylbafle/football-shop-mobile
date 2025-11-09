import 'package:flutter/material.dart';
import 'package:football_shop/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
  //         .copyWith(secondary: Colors.blueAccent[400]),
  //     ),
  //     home: MyHomePage(colorScheme: Theme.of(context).colorScheme),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(117, 167, 24, 1),
    );

    // 2. Return MaterialApp
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        fontFamily: 'Poppins',

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 14.0,
          ),
          hintStyle: TextStyle(
            fontSize: 14.0, 
          ),
        ),
      ),   
      home: MyHomePage(colorScheme: colorScheme), 
    );
  }
}