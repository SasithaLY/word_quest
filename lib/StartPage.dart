import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  bool isSubmit = false;
  viewLoginPage() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  viewSignupPage() async {
    Navigator.pushReplacementNamed(context, "Signup");
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        users.doc(user.uid).get().then((DocumentSnapshot userData) async {
          if (userData.exists) {
            print('Document data: ${userData.data()}');
            if (userData['role'] == 'admin') {
              Navigator.pushReplacementNamed(context, "Admin");
              print("admin");
            } else {
              Navigator.pushReplacementNamed(context, "/");
              print("user");
            }
          } else {
            print('Document does not exist on the database');
            _auth.currentUser!.reload();
            try {
              await users.doc(user.uid).set(
                  {"name": user.displayName, "role": "user"}).then((value) {
                Navigator.pushReplacementNamed(context, "/");
                isSubmit = false;
              });
            } catch (e) {
              print(e.toString());
            }

            //
          }
        });
      }
    });
  }

  googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: isSubmit
          ? Center(child: CircularProgressIndicator())
          : Column(children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: 300,
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Image(
                  image: AssetImage("images/logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  text: "Welcome to Word Quest",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Challenge friends with your vacabulary",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: viewLoginPage,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade600,
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ElevatedButton(
                      onPressed: viewSignupPage,
                      child: Text(
                        'SIGNUP',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade600,
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: googleLogin,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              )
            ]),
    ));
  }
}
