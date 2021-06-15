import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_quest/adminPanel/AddAdmin.dart';
import 'package:word_quest/theme/colors.dart';

class ViewAdmins extends StatefulWidget {
  const ViewAdmins({Key? key}) : super(key: key);

  @override
  _ViewAdminsState createState() => _ViewAdminsState();
}

class _ViewAdminsState extends State<ViewAdmins> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  List adminList = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Admins"),
        leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.arrow_back)),
      ),
      body: getBody(),
    );
  }

  void _navigateToAddAdmin(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAdmin()),
    );

    if (result == 'success') {
      showMessage("Success!", "Admin inserted successfully.");
      fetchAdmins();
    }
  }

  fetchAdmins() async {
    setState(() {
      isLoading = true;
    });

    List items = [];

    await users.get().then((QuerySnapshot querySnapshot) async {
      querySnapshot.docs.forEach((doc) {
        Admin userObj = new Admin();
        if (doc["role"] == "admin") {
          print("admin");
          userObj.name = doc['name'];
          userObj.pic = doc['pic'];
          userObj.email = doc['email'];
          items.add(userObj);
        }
      });

      setState(() {
        adminList = items;
        isLoading = false;
      });
    });
  }

  showMessage(
    String title,
    String message,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    fetchAdmins();
  }

  Widget getBody() {
    if (adminList.contains(null) || adminList.length < 0 || isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _navigateToAddAdmin(context);
                    },
                    child: Text(
                      'Add New Admin',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30, right: 30),
                    )),
              ],
            ),
          ),
          Flexible(
              child: SizedBox(
                  child: ListView.builder(
                      itemCount: adminList.length,
                      itemBuilder: (context, index) {
                        return getCard(adminList[index], index);
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
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    index.email,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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

class Admin {
  String name = "";
  String email = "";
  String pic = "";
}
