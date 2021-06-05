import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:word_quest/Home.dart';
import 'package:word_quest/theme/colors.dart';
import 'package:word_quest/index.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(primaryColor: primary),
      home: IndexPage(),
    ));
// void main() async {
//   runApp(LeaderHome(
//     Theme: ThemeData(primaryColor: primary),
//     Home: IndexPage(),
//   ));
// }
// class LeaderBoard {
//   string body;
//   string userName;
//   int score;

//   LeaderBoard(this.body, this.userName, this.score);
// }

// class LeaderHome extends StatefulWidget {
//   @override
//   _LeaderBoardState createState() => _LeaderBoardState();
// }

// class _LeaderBoardState extends State<LeaderHome> {
//   final CollectionReference users =
//       FirebaseFirestore.instance.collection("users");
//   final CollectionReference scores =
//       FirebaseFirestore.instance.collection("scores");
//   List<LeaderBoard> newScores = [];

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }

