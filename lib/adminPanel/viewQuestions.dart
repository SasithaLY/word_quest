import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:word_quest/adminPanel/updateQuestion.dart';
import 'configNames.dart';

class ViewQuestions extends StatefulWidget {
  @override
  _ViewQuestionsState createState() => _ViewQuestionsState();
}

class _ViewQuestionsState extends State<ViewQuestions> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var questionsArray = [];

  _ViewQuestionsState() {
    getAllQuestions();
  }

  Future<void> getAllQuestions() async {
    try {
      firestore
          .collection(ConfigNames.DATABASE_NAME)
          .limit(10)
          .snapshots()
          .listen((event) {
        questionsArray.clear();
        event.docs.forEach((element) {
          var infor = {'id': element.id, 'data': element.data()};

          try {
            setState(() {
              questionsArray.insert(0, infor);
            });
          } catch (e) {
            print('');
          }
        });
      });

      questionsArray.forEach((element) {
        // print(element);
      });
      // print(questionsArray);

    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteQuestion(i) async {
    await firestore.collection(ConfigNames.DATABASE_NAME).doc(i).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Current Questions'),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                if (questionsArray.length > 0)
                  for (var i in questionsArray)
                    Column(
                      children: [
                        Card(
                          //https://material.io/components/cards/flutter#theming-a-card
                          margin: EdgeInsets.all(15),
                          color: Colors.white70,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  i['data']['question'].toString(),
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  i['data']['correctAnswer'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  i['data']['answer2'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  i['data']['answer3'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  i['data']['answer4'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateQuestion(i)),
                                      );
                                    },
                                    child: Text('Edit'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => showDialog<String>(
                                      //https://api.flutter.dev/flutter/material/AlertDialog-class.html
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Are yor sure?'),
                                        content: const Text(
                                            'You will be not able to recover this data.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteQuestion(i['id']);
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                else
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'No questions yet..',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
              ],
            )
          ],
        ));
  }
}
