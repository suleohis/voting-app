import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:voter_app/views/homePage.dart';

class VoterNowPage extends StatefulWidget {
  const VoterNowPage({Key? key}) : super(key: key);

  @override
  State<VoterNowPage> createState() => _VoterNowPageState();
}

class _VoterNowPageState extends State<VoterNowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Voter Now',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('election').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    List poll = doc['candidates'];

                    if (doc['type'] == 'presidential') {
                      if (user!.hasVotedForPresd == true) {
                        return SizedBox.shrink();
                      }
                    }
                    return ExpandablePanel(
                      header: Text(
                        doc['type'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      collapsed: const Text(
                        '',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      expanded: FlutterPolls(
                        pollId: doc['id'],
                        onVoted:
                            (PollOption pollOption, int newTotalVotes) async {
                          confirmVote(doc['type'], pollOption.id!);
                          print('Voted: ${pollOption.id}');
                          return true;
                        },
                        pollOptionsSplashColor: Colors.white,
                        votedProgressColor: Colors.grey[900]!.withOpacity(0.3),
                        votedBackgroundColor: Colors.grey.withOpacity(0.2),
                        // votesTextStyle: themeData.textTheme.subtitle1,
                        // votedPercentageTextStyle:
                        // themeData.textTheme.headline4?.copyWith(
                        //   color: Colors.black(),
                        // ),
                        votedCheckmark: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.black,
                          size: 18,
                        ),
                        pollTitle: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              '${doc['type']} Election',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )),
                        pollOptions: poll.map(
                          (option) {
                            return PollOption(
                              id: option['id'],
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: option['img'],
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      child: AutoSizeText(
                                        option['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AutoSizeText(
                                      option['party'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              votes: option['result'],
                            );
                          },
                        ).toList(),
                        metaWidget: Row(
                          children: const [
                            SizedBox(width: 6),
                            AutoSizeText(
                              '•',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            AutoSizeText(
                              '2 hours left',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  confirmVote(String type, int id) async {
    DocumentSnapshot docs =
        await FirebaseFirestore.instance.collection('election').doc(type).get();
    List list = docs['candidates'];
    for (int i = 0; i < list.length; i++) {
      if (id == list[i]['id']) {
        list[i]['result'] = list[i]['result'] + 1;
      }
    }
    FirebaseFirestore.instance
        .collection('election')
        .doc(type)
        .update({'candidates': list}).then((value) {
      if (type == 'presidential') {
        FirebaseFirestore.instance.collection('users').doc(user!.id)
          ..update({'hasVotedForPresd': true});
      } else {
        FirebaseFirestore.instance.collection('users').doc(user!.id)
          ..update({'hasVotedForGov': true});
      }
    });
  }
}
