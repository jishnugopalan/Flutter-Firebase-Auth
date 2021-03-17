import 'package:firebase_database/firebase_database.dart';

class Contact {
  String _id, _firstname, _lastname, _phone, _email, _address, _photoUrl;
  String _uid;
  Contact(this._firstname, this._lastname, this._phone, this._email,
      this._address, this._photoUrl, this._uid);
  Contact.withId(this._id, this._firstname, this._lastname, this._phone,
      this._email, this._address, this._photoUrl, this._uid);

  String get id => this._id;
  String get firstname => this._firstname;
  String get lastname => this._lastname;
  String get phone => this._phone;
  String get email => this._email;
  String get address => this._address;
  String get photoUrl => this._photoUrl;

  set firstname(String firstname) {
    this._firstname = firstname;
  }

  set lastname(String lastname) {
    this._lastname = lastname;
  }

  set phone(String phone) {
    this._phone = phone;
  }

  set email(String email) {
    this._email = email;
  }

  set address(String address) {
    this._address = address;
  }

  set photoUrl(String photoUrl) {
    this._photoUrl = photoUrl;
  }

  set uid(String uid) {
    this._uid = uid;
  }

  Contact.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._firstname = snapshot.value['firstname'];
    this._lastname = snapshot.value['lastname'];
    this._phone = snapshot.value['phone'];
    this._email = snapshot.value['email'];
    this._address = snapshot.value['address'];
    this._photoUrl = snapshot.value['photoUrl'];
    this._uid = snapshot.value['uid'];
  }

  Map<String, dynamic> toJason() {
    return {
      "firstname": _firstname,
      "lastname": _lastname,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl,
      "uid": _uid
    };
  }
}
