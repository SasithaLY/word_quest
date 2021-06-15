import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Text(
          '* Press Play Button to start the quiz \n\n * Complete all questions to get selected for the leaderboard \n\n * You can go through as many attemps as you wish \n\n * Try to compete with others and win \n\n * Happy Quizzing!!!',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
