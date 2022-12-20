import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_app/views/authenationPage.dart';
import 'package:voter_app/views/homePage.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn = false;
  checkIfLogin() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('logged_in') == true) {
      setState(() {
        loggedIn = true;
      });
    }
  }
  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Voting app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:loggedIn ? const HomePage() : const AuthenationPage(),
    );
  }
}
