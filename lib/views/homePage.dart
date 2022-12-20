import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_app/views/authenationPage.dart';
import 'package:voter_app/views/candidates.dart';
import 'package:voter_app/views/result.dart';
import 'package:voter_app/views/voteNow.dart';

import '../modal/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [
    'assets/128353400.W7UQTgMo.jpg',
    'assets/afb4bc78a5f72197232c2e0b29a01f4f.jpg',
    'assets/igue.jpg'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.green, width: 2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.black,
                  ),
                  const Icon(
                    Icons.map,
                    size: 50,
                  ),
                  Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(color: Colors.black)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CarouselSlider.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index, int realIndex) {
                        return Image.asset(items[index], fit: BoxFit.fill,
                          width: 362,
                          height: 188,);
                      },
                      options: CarouselOptions(
                        height: 188,
                        aspectRatio: 4/3,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      )
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Election Commission Of M-Voting',
                    style: TextStyle(fontSize: 27),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => const VoterNowPage()))
                            .then((value) {
                          getUserDetail();
                          setState(() {});
                        }),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.fingerprint,
                              size: 80,
                            ),
                            Text(
                              'Vote now',
                              style: TextStyle(fontSize: 21),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const CandidatesPage())),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.people,
                              size: 80,
                            ),
                            Text(
                              'Candidates',
                              style: TextStyle(fontSize: 21),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ResultPage()));
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.note,
                              size: 80,
                            ),
                            Text(
                              'Result',
                              style: TextStyle(fontSize: 21),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          logOut();
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.logout,
                              size: 80,
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(fontSize: 21),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  logOut() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are You Sure?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        auth.signOut().then((value) async {
                          SharedPreferences pre =
                              await SharedPreferences.getInstance();
                          pre.clear();
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AuthenationPage()));
                        });
                      },
                      child: const Text('Confirm')),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'))
                ],
              )
            ],
          );
        });
  }
}

UserDetail? user;
getUserDetail() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid)
      .get();
  user = UserDetail.getDoc(doc);
}
