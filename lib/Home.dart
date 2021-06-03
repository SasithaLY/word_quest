import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'adminPanel/adminPanel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final googleSignIn = GoogleSignIn();
  User? user;
  bool isLogged = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "Start");
      } else {
        users.doc(user.uid).get().then((DocumentSnapshot userData) {
          if (userData.exists) {
            print('Document data: ${userData.data()}');
            if (userData['role'] == 'admin') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanel()),
              );
            }
          } else {
            print('Document does not exist on the database');
          }
        });
      }
    });
  }

  getUser() async {
    User? firebase_user = _auth.currentUser;
    await firebase_user?.reload();
    firebase_user = _auth.currentUser;

    if (firebase_user != null) {
      setState(() {
        this.user = firebase_user;
        this.isLogged = true;
      });
    }
  }

  logout() async {
    if (googleSignIn.isSignedIn() == false) {
      await _auth.signOut();
    } else {
      try {
        await googleSignIn.disconnect().whenComplete(() async {
          await _auth.signOut();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    this.getUser();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: !isLogged
                ? Center(child: CircularProgressIndicator())
                : Column(children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Hello ${user?.displayName}, Let's Play!",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 300,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Image(
                        image: AssetImage("images/logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: logout,
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(left: 30, right: 30),
                        ))
                  ])));
  }
}
