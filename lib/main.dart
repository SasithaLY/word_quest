// @dart=2.9

import 'package:flutter/material.dart';
import 'package:word_quest/Home.dart';
import 'package:word_quest/LeaderBoard.dart';
import 'package:word_quest/Login.dart';
import 'package:word_quest/Signup.dart';
import 'package:word_quest/StartPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:word_quest/adminPanel/adminPanel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Quest',
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.orange,
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: <String, WidgetBuilder>{
        "Login": (BuildContext context) => Login(),
        "Signup": (BuildContext context) => Signup(),
        "Start": (BuildContext context) => StartPage(),
        "Admin": (BuildContext context) => AdminPanel(),
        "LeaderBoard": (BuildContext context) => LeaderBoard()
      },
    );
  }
}
