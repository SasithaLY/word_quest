import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:word_quest/Home.dart';
import 'package:word_quest/LeaderBoard.dart';
import './adminPanel/configNames.dart';
import 'package:word_quest/theme/colors.dart';

import './Question.dart';
import './Answer.dart';
import './LeaderBoard.dart';

class Quiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var questionsArray = [];
  List _questions = [];
  int _userScore = 0;
  var _userId;
  var _questionIndex = 0;
  var _totalScore = 0;

  _QuizState() {
    getAllQuestions();
    readLeadboard();
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
          setState(() {
            questionsArray.insert(0, infor);
            // print(questionsArray);
          });
        });
        try {
          questionsArray.forEach((element) {
            var individual = {
              'questionText': element['data']['question'],
              'answers': [
                {'text': element['data']['correctAnswer'], 'score': 1},
                {'text': element['data']['answer2'], 'score': 0},
                {'text': element['data']['answer3'], 'score': 0},
                {'text': element['data']['answer4'], 'score': 0},
              ]
            };
            _questions.add(individual);
            // print(_questions);
          });
        } catch (e) {
          print('');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future readLeadboard() async {
    try {
      firestore.collection('scores').snapshots().listen((event) {
        event.docs.forEach((element) {
          if (element.id == _auth.currentUser!.uid) {
            print(element.id.toString() + element.data()['score'].toString());
            var infor = {
              'id': element.id,
              'data': element.data()['score'],
            };

            setState(() {
              _userId = infor['id'];
              _userScore = infor['data'];
              // _leadboard.insert(0, infor);
            });
          }
        });
        // print(_leadboard);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addScoreToLeadboard(int score) async {
    print(score.toString() + ' and ' + _userId.toString());
    if (score > _userScore) {
      try {
        await firestore.collection('scores').doc('$_userId').update({
          'score': _totalScore,
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('New Highscore!')));
      } catch (e) {
        print(e);
      }
    }
  }

  //question data should come from the firebase db
  // final List _questions = const [
  //   {
  //     'questionText': 'What\'s the color of dark?',
  //     'answers': [
  //       {'text': 'Black', 'score': 1},
  //       {'text': 'Red', 'score': 0},
  //       {'text': 'Green', 'score': 0},
  //       {'text': 'Yellow', 'score': 0},
  //     ],
  //   },
  //   {
  //     'questionText': 'Who\'s the king of animals?',
  //     'answers': [
  //       {'text': 'Tiger', 'score': 0},
  //       {'text': 'Bear', 'score': 0},
  //       {'text': 'Lion', 'score': 1},
  //       {'text': 'Dog', 'score': 0},
  //     ],
  //   },
  //   {
  //     'questionText': 'What\'s the best private university in Sri Lanka?',
  //     'answers': [
  //       {'text': 'IIT', 'score': 0},
  //       {'text': 'NIBM', 'score': 0},
  //       {'text': 'NSBM', 'score': 0},
  //       {'text': 'SLIIT', 'score': 1},
  //     ],
  //   },
  // ];

  void _resetQuiz() {
    _addScoreToLeadboard(_totalScore);
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
                      child: Text('Restart Quiz'),
                    ),
                    ElevatedButton(
                        child: Text('Check Leaderboard'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green[600],
                            textStyle: TextStyle(
                              fontSize: 18,
                            )),
                        onPressed: () {
                          _resetQuiz();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeaderBoard()),
                          );
                        }),
                    IconButton(
                      onPressed: () {
                        _resetQuiz();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      icon: Icon(Icons.home),
                      iconSize: 35,
                      color: Colors.blue[600],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
