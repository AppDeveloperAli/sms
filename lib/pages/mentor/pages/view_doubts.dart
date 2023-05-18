import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student_mentogin_system/snackBar.dart';

// ignore: must_be_immutable
class ViewDoubts extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var data;
  ViewDoubts(this.data, {super.key});

  @override
  State<ViewDoubts> createState() => _ViewDoubtsState();
}

class _ViewDoubtsState extends State<ViewDoubts> {
  var db = FirebaseFirestore.instance;
  var replyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  void submitReplyHandler(String id) async {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    var navigator = Navigator.of(context);
    var theme = Theme.of(context);
    var db = FirebaseFirestore.instance;
    setState(() {
      loading = true;
    });
    try {
      await db.collection("doubts").doc(id).update({
        "reply": {
          "message": replyController.text,
          "mentorName": widget.data["data"]["username"],
          "mentorId": widget.data["data"]["id"],
        }
      });

      setState(() {
        loading = false;
        navigator.pop();
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text("Doubts Replied"),
          backgroundColor: theme.primaryColor,
        ),
      );
    } catch (e) {
      setState(() {
        loading = false;
        navigator.pop();
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream:
            db.collection("doubts").where("reply", isEqualTo: "").snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Doubts Found"),
            );
          } else {
            var doc = [
              ...snapshot.data!.docs.map((x) => {...x.data(), "id": x.id})
            ];
            if (doc.isEmpty) {
              return const Center(
                child: Text("No Doubts Found"),
              );
            }

            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID : ${doc[index]["id"]}'),
                                Text('Name : ${doc[index]["username"]}'),
                                Text(
                                    'Department : ${doc[index]["department"]}'),
                                Text('Gender : ${doc[index]["gender"]}'),
                                Text('Birth Date : ${doc[index]["birthDate"]}'),
                                ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Form(
                                          key: formKey,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  enabled: false,
                                                  minLines: 3,
                                                  maxLines: 10,
                                                  initialValue: doc[index]
                                                      ["doubts"],
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade300,
                                                    labelText: "Doubts",
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  minLines: 3,
                                                  maxLines: 10,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    label: Text(
                                                      "Reply Message",
                                                    ),
                                                    hintText: "Reply Message",
                                                    alignLabelWithHint: true,
                                                  ),
                                                  controller: replyController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Input Reply Message";
                                                    } else if (value.length <
                                                        10) {
                                                      return "Minimum 10 Characters Length";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                // ElevatedButton(
                                                //   onPressed: ()async{
                                                //     FilePickerResult? result = await FilePicker.platform.pickFiles();
                                                //
                                                //     if (result != null) {
                                                //       File file = File(result.files.single.path.toString());
                                                //       PlatformFile fileDetailes = await result.files.first;
                                                //       print(fileDetailes.name);
                                                //
                                                //       CustomSnackBar(context,Text('File Name : ${fileDetailes.name}'));
                                                //
                                                //     } else {
                                                //       setState(() {
                                                //         CustomSnackBar(context,Text('You cancelled picking file..'));
                                                //       });
                                                //     }
                                                //   },
                                                //   child: Text(
                                                //     'Pick a File',
                                                //   ),
                                                // ),

                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    loading
                                                        ? const CircularProgressIndicator()
                                                        : Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                submitReplyHandler(
                                                                  doc[index]
                                                                      ["id"],
                                                                );
                                                              },
                                                              child: const Text(
                                                                "Send Reply",
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Reply Doubts"),
                                )
                              ],
                            ),
                          ),
                          Image.network(
                            doc[index]["photo"],
                            height: 125,
                          )
                        ]),
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
