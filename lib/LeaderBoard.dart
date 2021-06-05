import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_quest/theme/colors.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference scores =
      FirebaseFirestore.instance.collection("scores");

  List scoreList = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leader Board"),
        leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.arrow_back)),
      ),
      body: getBody(),
    );
  }

  fetchScores() async {
    setState(() {
      isLoading = true;
    });

    List items = [];
    await scores
        .orderBy('score', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        await users.doc(doc.id).get().then((user) {
          UserScore userObj = new UserScore();
          userObj.name = user["name"].toString();
          userObj.score = doc["score"].toString();
          //print(userObj.name);
          if (user["pic"] != null && user["pic"] != "") {
            userObj.pic = user["pic"];
          } else {
            userObj.pic = "";
          }
          //userObj.pic = "";
          items.add(userObj);
        });
      }

      setState(() {
        scoreList = items;
        isLoading = false;
      });

      /* querySnapshot.docs.forEach((doc) async {
        //print(doc["first_name"]);
        await users.doc(doc.id).get().then((user) {
          UserScore userObj = new UserScore();
          userObj.name = user["name"].toString();
          userObj.score = doc["score"].toString();
          //print(userObj.name);
          if (user["pic"] != null && user["pic"] != "") {
            userObj.pic = user["pic"];
          } else {
            userObj.pic = "";
          }
          //userObj.pic = "";
          items.add(userObj);
        });
      }); */
    });
  }

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Widget getBody() {
    if (scoreList.contains(null) || scoreList.length < 0 || isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
        itemCount: scoreList.length,
        itemBuilder: (context, index) {
          return getCard(scoreList[index]);
        });
  }

  Widget getCard(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(60 / 2),
                    image: index.pic == ""
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("images/defaultUser.png"))
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(index.pic.toString()))),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    index.name,
                    style: TextStyle(fontSize: 15, color: Colors.deepOrange),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    index.score,
                    style: TextStyle(fontSize: 15, color: Colors.deepOrange),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserScore {
  String name = "";
  String score = "";
  String pic = "";
}
