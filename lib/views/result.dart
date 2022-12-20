import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: const Text("Results"),
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body:  Padding(
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
                        expanded: SizedBox(
                          height: 300,
                          child: DChartBar(
                            data: [
                              {
                                'id': 'Bar',
                                'data': poll.map((e) {
                                  return {'domain': e['party'],
                                    'measure': e['result']};
                                }).toList(),
                              },
                            ],
                            domainLabelPaddingToAxisLine: 16,
                            axisLineTick: 2,
                            axisLinePointTick: 2,
                            axisLinePointWidth: 10,
                            axisLineColor: Colors.green,
                            measureLabelPaddingToAxisLine: 16,
                            barColor: (barData, index, id) => Colors.green,
                            showBarValue: true,
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

}
