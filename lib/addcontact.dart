import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'dart:ui';
import 'Model/contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AddContact extends StatefulWidget {
  final String uid;
  AddContact(this.uid);

  @override
  _AddContactState createState() => _AddContactState(uid);
}

class _AddContactState extends State<AddContact> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  //Contact _contact;
  String uid;
  _AddContactState(this.uid);
  String _firstname = '';
  String _lastname = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _photoUrl = 'empty';
  //String _uid = uid;

  saveContact(BuildContext context) async {
    if (_firstname.isNotEmpty &&
        _lastname.isNotEmpty &&
        _phone.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty) {
      Contact contact = Contact(this._firstname, this._lastname, this._phone,
          this._email, this._address, this._photoUrl, uid);

      await _databaseReference.push().set(contact.toJason());
      NavigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
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
    //File imageFile = File(_file.toString());
    String filename = basename(_file.path);
    print('$filename');
    //uploadImage(file, filename);

    print("imageset");

    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(filename);

    // StorageUploadTask uploadTask = _storageReference.putFile(imageFile);
    // await uploadTask.onComplete;
    // print("File Uploaded");
    _storageReference.putFile(_file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        _photoUrl = downloadUrl;
        print("imageset");
      });
    });
    // _storageReference.getDownloadURL().then((fileUrl) {
    //   setState(() {
    //     _photoUrl = fileUrl;
    //   });
    // });
  }

  void uploadImage(file, String filename) async {
    print("imageset");
    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = _storageReference.putFile(file);
    await uploadTask.onComplete;
    print("File Uploaded");
    _storageReference.getDownloadURL().then((fileUrl) {
      setState(() {
        _photoUrl = fileUrl;
      });
    });
    // _storageReference.putFile(file).onComplete.then((firebaseFile) async {
    //   var downloadUrl = await firebaseFile.ref.getDownloadURL();
    //   setState(() {
    //     _photoUrl = downloadUrl;
    //     print("imageset");
    //   });
    // });
  }

  NavigateToLastScreen(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    this.pickImage();
                    // File file = await ImagePicker.pickImage(
                    //     source: ImageSource.gallery,
                    //     maxHeight: 200.0,
                    //     maxWidth: 200.0);
                    // String filename = basename(file.path);
                    // uploadImage(file, filename);
                  },
                  child: Center(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _photoUrl == "empty"
                                ? AssetImage("assets/photo.png")
                                : NetworkImage(_photoUrl),
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _firstname = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'First Name', border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _lastname = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Last Name', border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Phone', border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Address', border: OutlineInputBorder()),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    onPressed: () {
                      saveContact(context);
                    },
                    color: Colors.blue,
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
