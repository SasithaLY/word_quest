import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:word_quest/adminPanel/ViewAdmins.dart';
import 'package:firebase_core/firebase_core.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email, name, password;
  bool success = false;

  addAdmin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        FirebaseApp app = await Firebase.initializeApp(
            name: 'Admins', options: Firebase.app().options);

        UserCredential authResult = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(
                email: email.toString(), password: password.toString());

        User? user = authResult.user;

        if (user != null) {
          await user.updateProfile(displayName: name);

          await users.doc(user.uid).set({
            "name": name,
            "role": "admin",
            "pic": "",
            "email": email
          }).then((value) => Navigator.pop(context, 'success'));
          await app.delete();
          email = "";
          name = "";
          password = "";
        }
      } on FirebaseAuthException catch (e) {
        showMessage("ERROR!", e.message.toString());
      } catch (e) {
        print(e);
      }
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Admin"),
        leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 250,
                child: Image(
                  image: AssetImage("images/add_admin.png"),
                  fit: BoxFit.contain,
                  width: 300,
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
                              return 'Enter Name';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Admin Name',
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
                            onPressed: addAdmin,
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(70, 10, 70, 10)),
                          )),
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
