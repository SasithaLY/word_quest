import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'configNames.dart';


class AddQuestions extends StatefulWidget {
  const AddQuestions({Key? key}) : super(key: key);

  @override
  _AddQuestionsState createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String question = '';
  String correctAnswer = '';
  String answer_2 = '';
  String answer_3 = '';
  String answer_4 = '';

  Future<void> addDetailsToFirebase(String question, String correctAnswer, String answer2, String answer3, String answer4) async {
    try {
      await firestore.collection(ConfigNames.DATABASE_NAME).add({
        'question': '$question',
        'correctAnswer': '$correctAnswer',
        'answer2': '$answer2',
        'answer3': '$answer3',
        'answer4': '$answer4',
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New Records Inserted Successfully!')));
      _formKey.currentState!.reset();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Question'),
      ),
      body: Form( //https://flutter.dev/docs/cookbook/forms/validation
          key: _formKey,
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'The Question'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      setState(() {
                        question = value.toString();
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Correct Answer'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      setState(() {
                        correctAnswer = value.toString();
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Answer 2'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      setState(() {
                        answer_2 = value.toString();
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Answer 3'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      setState(() {
                        answer_3 = value.toString();
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Answer 4'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }else {
                      setState(() {
                        answer_4 = value.toString();
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 30, 40, 30),
                alignment: Alignment.center,
                child: AnimatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addDetailsToFirebase(question, correctAnswer, answer_2, answer_3, answer_4);
                      }
                    },
                    height: 50,
                    color: Colors.amber,
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                    )),
              ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.fromLTRB(40, 30, 40, 30),
              //   alignment: Alignment.center,
              //   child: Text(question + correctAnswer + answer_2 + answer_3 + answer_4),
              // )
            ],
          )),
    );
  }
}
