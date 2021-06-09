import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './adminPanel/configNames.dart';
import 'package:word_quest/theme/colors.dart';

import './Question.dart';
import './Answer.dart';

class Quiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var questionsArray = [];

  _QuizState() {
    getAllQuestions();
  }

  Future<void> getAllQuestions() async {
    try {
      firestore
          .collection(ConfigNames.DATABASE_NAME)
          .snapshots()
          .listen((event) {
        questionsArray.clear();
        event.docs.forEach((element) {
          var infor = {
            'id': element.id,
            'data': element.data(),
          };
          // print(infor);

          try {
            setState(() {
              questionsArray.insert(0, infor);
              // print(questionsArray);
            });

            questionsArray.forEach((element) {
              List individual = [
                {
                  'questionText': element['data']['question'],
                  'answers': [
                    {'text': element['data']['correctAnswer']},
                    {'text': element['data']['answer2']},
                    {'text': element['data']['answer3']},
                    {'text': element['data']['answer4']},
                  ]
                }
              ];
              print(individual);
            });
          } catch (e) {
            print('');
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  //question data should come from the firebase db
  final List _questions = const [
    {
      'questionText': 'What\'s the color of dark?',
      'answers': [
        {'text': 'Black', 'score': 1},
        {'text': 'Red', 'score': 0},
        {'text': 'Green', 'score': 0},
        {'text': 'Yellow', 'score': 0},
      ],
    },
    {
      'questionText': 'Who\'s the king of animals?',
      'answers': [
        {'text': 'Tiger', 'score': 0},
        {'text': 'Bear', 'score': 0},
        {'text': 'Lion', 'score': 1},
        {'text': 'Dog', 'score': 0},
      ],
    },
    {
      'questionText': 'What\'s the best private university in Sri Lanka?',
      'answers': [
        {'text': 'IIT', 'score': 0},
        {'text': 'NIBM', 'score': 0},
        {'text': 'NSBM', 'score': 0},
        {'text': 'SLIIT', 'score': 1},
      ],
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;

      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quest'),
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.green,
        ),
        body: _questionIndex < _questions.length
            ? Column(
                children: [
                  Question(
                    _questions[_questionIndex]['questionText'],
                  ),
                  ...(_questions[_questionIndex]['answers']).map((answer) {
                    return Answer(
                        () => _answerQuestion(answer['score']), answer['text']);
                  }).toList()
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Congratulations! You did it \n your score is \n' +
                          _totalScore.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FlatButton(
                        textColor: Colors.red,
                        hoverColor: Colors.green,
                        onPressed: _resetQuiz,
                        child: Text('Restart Quiz'))
                  ],
                ),
              ),
      ),
    );
  }
}
