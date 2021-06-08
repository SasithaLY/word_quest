import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'configNames.dart';

class UpdateQuestion extends StatefulWidget {
  final i;

  UpdateQuestion(this.i);

  @override
  _UpdateQuestionState createState() => _UpdateQuestionState(i);
}

class _UpdateQuestionState extends State<UpdateQuestion> {
  final _formKey = GlobalKey<FormState>();
  var details;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  _UpdateQuestionState(i) {
    details = i;
    assignVariables();
  }

  String question = '';
  String correctAnswer = '';
  String answer_2 = '';
  String answer_3 = '';
  String answer_4 = '';

  void assignVariables() {
    print(details['id']);
  }

  Future<void> updateDetailsToFirebase(String question, String correctAnswer, String answer2, String answer3, String answer4) async {
    try {
      await firestore.collection(ConfigNames.DATABASE_NAME).doc(details['id']).update({
        'question': '$question',
        'correctAnswer': '$correctAnswer',
        'answer2': '$answer2',
        'answer3': '$answer3',
        'answer4': '$answer4',
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Records were Updated Successfully!')));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Question'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(40, 40, 40, 10),
                  child: Text('You can update your questions here. The correct word should be updated to the "Correct Answer"!', style: TextStyle(color: Colors.green),)
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextFormField(
                  initialValue: details['data']['question'],
                  decoration: InputDecoration(labelText: 'The Question Word'),
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
                  initialValue: details['data']['correctAnswer'],
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
                  initialValue: details['data']['answer2'],
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
                  initialValue: details['data']['answer3'],
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
                  initialValue: details['data']['answer4'],
                  decoration: InputDecoration(labelText: 'Answer 4'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else {
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
                        updateDetailsToFirebase(question, correctAnswer, answer_2, answer_3, answer_4);
                      }
                    },
                    height: 50,
                    color: Colors.green,
                    child: Text(
                      'Update',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
