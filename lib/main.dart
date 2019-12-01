import 'package:clock/views/clock_view.dart';
import 'package:clock/views/preset_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Clock',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF2b2b2b),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            height: 2.0,
          ),
          border: InputBorder.none,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          subtitle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: PresetView(title: 'Animated Chess Clock'),
      // home: MyHomePage(),
      // home: ClockView(),
    );
  }
}
