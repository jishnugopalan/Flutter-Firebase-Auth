import 'package:FirebaseAuth/FireStoreServices.dart';
import 'package:FirebaseAuth/Model/contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addcontact.dart';
import 'viewcontact.dart';
import 'editcontact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool issigned = false;
  Contact _contact;
  var u;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  navigateToAddContact(uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddContact(uid);
    }));
  }

  navigateToVieContact(id) {
    print(id);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewContact(id, u);
    }));
  }

  //Stream<User> get authStateChanges => _auth.authStateChanges();

  //Authentication Part Below

  Future<User> reloadCurrentUser() async {
    User oldUser = await _auth.currentUser;
    oldUser.reload();
    User newUser = await FirebaseAuth.instance.currentUser;
    // Add newUser to a Stream, maybe merge this Stream with onAuthStateChanged?
    return newUser;
  }

  chekauthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushNamed(context, "/signup");
      }
    });
  }

  getUser() async {
    //User firebaseUser = await _auth.instance.currentUser();
    User firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser?.reload();
    // firebaseUser = await _auth.currentUser();
    u = firebaseUser.uid;
    //_contact.uid = u;
    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.issigned = true;
      });
    }
    print(this.user);
  }

  Future<void> signOut() async {
    this.issigned = false;
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  navigatetoFireStore() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FireStoreServices();
    }));
  }

  navigateToSigninScreen() {
    Navigator.pushNamed(context, "/signup");
  }

  @override
  void initState() {
    super.initState();

    //this.reloadCurrentUser();
    this.chekauthentication();
    this.getUser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        actions: [
          RaisedButton(
            // padding: EdgeInsets.all(20.0),
            child: Text(
              'Sign out',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: Colors.blue,
            onPressed: signOut,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          RaisedButton(
            // padding: EdgeInsets.all(20.0),
            child: Text(
              'Fire Store',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: Colors.blue,
            onPressed: navigatetoFireStore,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ],
      ),
      body: Container(
        child: !issigned
            ? CircularProgressIndicator()
            : Container(
                child: FirebaseAnimatedList(
                  query: _databaseReference,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return GestureDetector(
                      onTap: () {
                        navigateToVieContact(snapshot.key);
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          snapshot.value['photoUrl'] == "empty"
                                              ? AssetImage("assets/photo.png")
                                              : NetworkImage(
                                                  snapshot.value['photoUrl']),
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      " ${snapshot.value['firstname']} ${snapshot.value['lastname']} ",
                                    ),
                                    Text(
                                      " ${snapshot.value['phone']} ",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(top: 20.0),
                              //   child: RaisedButton(
                              //     child: Text(
                              //       'Sign out',
                              //       style: TextStyle(
                              //           color: Colors.white, fontSize: 20.0),
                              //     ),
                              //     color: Colors.blue,
                              //     onPressed: signOut,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(5.0)),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

        // Container(
        //   padding: EdgeInsets.all(20.0),
        //   child: Text(
        //     // ,${user.displayName} you are logged in as ${user.email}
        //     "Hello,${user.displayName} you are logged in as ${user.email}",
        //     style: TextStyle(fontSize: 20.0),
        //   ),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddContact(u);
        },
        child: Icon(Icons.add),
        clipBehavior: Clip.hardEdge,
      ),
    );
  }
}
