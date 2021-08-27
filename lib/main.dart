import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_message/ui/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Message',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.teal,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
