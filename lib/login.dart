import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class logIn extends StatefulWidget {
  @override
  _logInState createState() => _logInState();
}

class _logInState extends State<logIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  Stream<User> get authStateChanges => _auth.authStateChanges();

  chekauthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(null);
        Navigator.pushNamed(context, '/');
      }
    });
  }

  navigateToSignupScreen() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  void initState() {
    super.initState();

    this.chekauthentication();
    //this.reloadCurrentUser();
  }

  void signin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
    } catch (e) {
      showError(e.message);
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
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Center(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide an email';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onSaved: (input) => _email = input,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Provide an password';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Passord",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onSaved: (input) => _password = input,
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
                            onPressed: signin,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                        GestureDetector(
                          onTap: navigateToSignupScreen,
                          child: Text(
                            'Create an account',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
