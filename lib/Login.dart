import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _email, _password;

  bool isSubmit = false;

  checkAuthentication() async {
    isSubmit = false;
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        users.doc(user.uid).get().then((DocumentSnapshot userData) {
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
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      isSubmit = true;
      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email.toString(), password: _password.toString());
      } on FirebaseAuthException catch (e) {
        showError(e.message.toString());
      }
    }
  }

  showError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR!'),
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

  viewSignupPage() async {
    Navigator.pushReplacementNamed(context, "Signup");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: isSubmit
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      height: 250,
                      child: Image(
                        image: AssetImage("images/login_image.png"),
                        fit: BoxFit.contain,
                        width: 250,
                      ),
                    ),
                    Text(
                      'Sign in to Continue',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Enter Email';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email)),
                                onSaved: (input) {
                                  _email = input;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Container(
                              child: TextFormField(
                                  validator: (input) {
                                    if (input == null || input.length < 6) {
                                      return 'Password should be minimum 6 characters';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock)),
                                  obscureText: true,
                                  onSaved: (input) => _password = input),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: login,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.fromLTRB(70, 10, 70, 10)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: viewSignupPage,
                                  child: Text(
                                    "Signup",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
