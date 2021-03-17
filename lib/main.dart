import 'package:FirebaseAuth/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'signup.dart';
import 'homepage.dart';
import 'FireStoreServices.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      title: 'FirebaseApp',
      home: homePage(),
      routes: <String, WidgetBuilder>{
        "/login": (BuildContext context) => logIn(),
        "/signup": (BuildContext context) => signUp(),
      },
    );
  }
}
