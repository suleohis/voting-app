import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';

class CandidatesPage extends StatefulWidget {
  const CandidatesPage({Key? key}) : super(key: key);

  @override
  State<CandidatesPage> createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  List poll = ['Peter obi', 'attiku'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidates'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance.collection('election').snapshots(), builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasData) {

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  List poll = doc['candidates'];
                  return ExpandablePanel(
                    header: Text(doc['type'], style: const TextStyle(fontSize: 18),),
                    collapsed: const Text(
                      '',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(children: poll.map(
                          (option) {
                        return ListTile(
                          title: AutoSizeText(option['name']),
                        );
                      },
                    ).toList(),),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },

          )
        // Column(
        //   children: [
        //     Row(
        //       children: [
        //         AutoSizeText('Type of election'),
        //         AutoSizeText('State')
        //       ],
        //     ),
        //     const SizedBox(height: 10,),
        //
        //     ExpandablePanel(
        //       header: const Text('Type of Election'),
        //       collapsed: const Text(
        //         '',
        //         softWrap: true,
        //         maxLines: 2,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //       expanded: Column(children: poll.map(
        //             (option) {
        //           return ListTile(
        //             title: AutoSizeText(option),
        //           );
        //         },
        //       ).toList(),),)
        //
        //   ],
        // ),
      ),
    );
  }
}
