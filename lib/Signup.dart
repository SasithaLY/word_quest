import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:word_quest/Home.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email, name, password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential authResult = await _auth.createUserWithEmailAndPassword(
            email: email.toString(), password: password.toString());

        User? user = authResult.user;

        if (user != null) {
          await user.updateProfile(displayName: name);

          await users.doc(user.uid).set({"name": name, "role": "user"});
        }
      } on FirebaseAuthException catch (e) {
        showError(e.message.toString());
      } catch (e) {
        print(e);
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

  viewLoginPage() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: 250,
                child: Image(
                  image: AssetImage("images/login_image.png"),
                  fit: BoxFit.contain,
                  width: 250,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextFormField(
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Enter Your Name';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person)),
                          onSaved: (input) {
                            name = input;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
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
                            email = input;
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
                            onSaved: (input) => password = input),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: signup,
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(70, 10, 70, 10)),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          GestureDetector(
                            onTap: viewLoginPage,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
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
