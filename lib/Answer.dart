import 'package:flutter/material.dart';
import 'package:word_quest/theme/colors.dart';

class Answer extends StatelessWidget {
  final VoidCallback answerHandler;
  final String answerText;

  Answer(this.answerHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(answerText),
        style: ElevatedButton.styleFrom(
            primary: Colors.green,
            textStyle: TextStyle(
              fontSize: 20,
            )),
        onPressed: answerHandler,
      ),
    );
  }
}
