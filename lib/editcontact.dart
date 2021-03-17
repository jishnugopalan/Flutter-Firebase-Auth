import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'Model/contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditContact extends StatefulWidget {
  final String id, uid;
  EditContact(this.id, this.uid);
  @override
  _EditContactState createState() => _EditContactState(id, uid);
}

class _EditContactState extends State<EditContact> {
  String id, uid;
  _EditContactState(this.id, this.uid);

  String _firstname = '';
  String _lastname = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _photoUrl;

  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _poController = TextEditingController();
  TextEditingController _emController = TextEditingController();
  TextEditingController _adController = TextEditingController();

  bool isLoading = true;

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  getContact(id) async {
    Contact contact;
    _databaseReference.child(id).onValue.listen((event) {
      contact = Contact.fromSnapshot(event.snapshot);
      _fnController.text = contact.firstname;
      _lnController.text = contact.lastname;
      _poController.text = contact.phone;
      _emController.text = contact.email;
      _adController.text = contact.address;

      setState(() {
        _firstname = contact.firstname;
        _lastname = contact.lastname;
        _phone = contact.phone;
        _email = contact.email;
        _address = contact.address;
        _photoUrl = contact.photoUrl;
        isLoading = false;
      });
    });
  }

//update Contact
  updateContact(BuildContext context) async {
    if (_firstname.isNotEmpty &&
        _lastname.isNotEmpty &&
        _phone.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty) {
      Contact contact = Contact.withId(this.id, this._firstname, this._lastname,
          this._phone, this._email, this._address, this._photoUrl, this.uid);

      await _databaseReference.child(id).set(contact.toJason());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Field required"),
              content: Text("All fields are required"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  Future<void> pickImage() async {
    File _file;
    _file = File(await ImagePicker()
        .getImage(
            source: ImageSource.gallery, maxHeight: 200.0, maxWidth: 200.0)
        .then((pickedFile) => pickedFile.path));

    String filename = basename(_file.path);
    print('$filename');

    print("imageset");

    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(filename);

    //upload image

    _storageReference.putFile(_file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        _photoUrl = downloadUrl;
        print("imageset");
      });
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    print("init 2");
    this.getContact(id);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("assets/photo.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstname = value;
                          });
                        },
                        controller: _fnController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastname = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _poController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _adController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        onPressed: () {
                          updateContact(context);
                        },
                        color: Colors.red,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
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
