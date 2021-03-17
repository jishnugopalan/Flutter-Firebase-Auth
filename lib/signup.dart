import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String name, email, password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) Navigator.pushReplacementNamed(context, "/");
    });
  }

  navigateToSigninScreen() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  Future<void> signup() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          User firebaseuser = FirebaseAuth.instance.currentUser;
          firebaseuser.updateProfile(displayName: name);
          await firebaseuser.reload();
          this.checkAuthentication();
        }
      } on FirebaseAuthException catch (e) {
        showError(e.message);
      }
    }
  }

  showError(String errorMsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMsg),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please provide a name';
                              } else if (input.length < 3) {
                                return 'Name must contain more than 2 characters';
                              } else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                )),
                            keyboardType: TextInputType.text,
                            onSaved: (input) => name = input,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            validator: (input) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern);
                              if (!regExp.hasMatch(input))
                                return "Enter a valid Email address";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                )),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => email = input,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            validator: (input) {
                              if (input.length < 6)
                                return 'Length must be morethan 6';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                )),
                            keyboardType: TextInputType.visiblePassword,
                            onSaved: (input) => password = input,
                            obscureText: true,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: RaisedButton(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                            color: Colors.blue,
                            onPressed: signup,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                        GestureDetector(
                          onTap: navigateToSigninScreen,
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
