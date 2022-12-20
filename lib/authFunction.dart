import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_app/views/homePage.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future signUpRequest(String email, String password, String name, String age,
    String state, String phone, String nin, String sex, BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  try {
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(( value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set({
        'id': auth.currentUser!.uid,
        'email': email,
        'age': age,
        'state': state,
        'phoneNumber': phone,
        'name': name,
        'nin': nin,
        'hasVotedForPresd': false,
        'hasVotedForGov': false,
        'sex': sex
      }).then((value) {
        pref.setString('name', name);
        pref.setString('min', nin);
        pref.setString('state', state);
        pref.setString('email', email);
        pref.setBool('logged_in', true);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
      });
    }).catchError((e) {
      String error = '[firebase_auth/email-already-in-use] The email address is already in use by another account.';
      if (e.toString().contains(error)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('This Account Already Exist')));
      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Network Problems')));
      }
      print(e);
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failure To Sign Up')));
    print(e.toString());
  }
}


