import 'package:clock/views/preset_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Clock',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFF2b2b2b),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            height: 2.0,
          ),
          border: InputBorder.none,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: PresetView(title: 'Animated Chess Clock'),
    );
  }
}
