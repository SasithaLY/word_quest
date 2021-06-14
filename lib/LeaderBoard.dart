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
  int userScore = 0;
  int userRank = 0;
  int userIndex = -1;

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
      int r = 0;
      for (var doc in querySnapshot.docs) {
        r++;

        await users.doc(doc.id).get().then((user) {
          UserScore userObj = new UserScore();
          userObj.name = user["name"].toString();
          userObj.score = doc["score"].toString();
          userObj.no = r;
          if (user["pic"] != null && user["pic"] != "") {
            userObj.pic = user["pic"];
          } else {
            userObj.pic = "";
          }

          if (doc.id == _auth.currentUser!.uid) {
            userScore = doc["score"];
            userRank = r;
            userIndex = r - 1;
          }

          items.add(userObj);
        });
      }

      setState(() {
        scoreList = items;
        isLoading = false;
      });
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

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Colors.blueGrey[100],
            child: userIndex < 0
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Your score will be displayed here once you start playing.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(80 / 2),
                            image: scoreList[userIndex].pic == ""
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("images/defaultUser.png"))
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        scoreList[userIndex].pic.toString()))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Your Score: ${userScore}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Your Rank: ${userRank}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Flexible(
              child: SizedBox(
                  child: ListView.builder(
                      itemCount: scoreList.length,
                      itemBuilder: (context, index) {
                        return getCard(scoreList[index], index);
                      })))
        ],
      ),
    );
  }

  Widget getCard(index, id) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Text(
                "${id + 1}",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                width: 20,
              ),
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
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    index.score,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
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
  int? no;
}
