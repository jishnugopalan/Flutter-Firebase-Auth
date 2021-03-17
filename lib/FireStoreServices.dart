import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices extends StatefulWidget {
  @override
  _FireStoreServicesState createState() => _FireStoreServicesState();
}

class _FireStoreServicesState extends State<FireStoreServices> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'email': 'jishnugopalan2000@gmail.com', // John Doe
          'name': 'jishnu goapaln', // Stokes and Sons
          'phone': '7994245510' // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(onPressed: addUser, child: Text("Add User")),
    );
  }
}
