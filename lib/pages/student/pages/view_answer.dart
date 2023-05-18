import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ViewAnswer extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var data;
  ViewAnswer(this.data, {super.key});

  @override
  State<ViewAnswer> createState() => _ViewAnswerState();
}

class _ViewAnswerState extends State<ViewAnswer> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(widget.data["data"]["username"]);
    return Container(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream: db
            .collection("doubts")
            .where("reply", isNotEqualTo: "")
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshots.hasData) {
            return const Center(
              child: Text("No Answer Found"),
            );
          } else {
            var doc = [
              ...snapshots.data!.docs
                  .map(
                    (x) => {...x.data()},
                  )
                  .where(
                    (element) =>
                        element["username"] == widget.data["data"]["username"],
                  )
            ];

            if (doc.isEmpty) {
              return const Center(
                child: Text("No Answer Found"),
              );
            }

            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student Name : ${doc[index]["username"]}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Student ID : ${doc[index]["id"]}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Department : ${doc[index]["department"]}"),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: false,
                          initialValue: doc[index]["doubts"],
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: "Doubts",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Answered By : ${doc[index]["reply"]["mentorName"]}",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: false,
                          initialValue: doc[index]["reply"]["message"],
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: "Answer",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }
}
