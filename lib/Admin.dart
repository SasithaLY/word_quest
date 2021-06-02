import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  User? user;
  bool isLogged = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "Start");
      }
    });
  }

  getUser() async {
    User? firebase_user = await _auth.currentUser;

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
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Admin Panel",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Hello, ${user?.displayName}.",
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
