import 'dart:convert';

import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ReportToParents extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var data;
  ReportToParents(this.data, {super.key});

  @override
  State<ReportToParents> createState() => _ReportToParentsState();
}

class _ReportToParentsState extends State<ReportToParents> {
  var db = FirebaseFirestore.instance;
  var emailController = TextEditingController();
  var messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void reportHandler(setState) async {
    if (formKey.currentState!.validate()) {
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      var navigator = Navigator.of(context);
      var theme = Theme.of(context);

      // Send Email
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      const serviceId = 'service_egap2qu';
      const templateId = 'template_knfmycs';
      const userId = 'Br1fuTjchCKbsSrKu';
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        }, //This line makes sure it works for all platforms.
        body: json.encode(
          {
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'mentor_name': widget.data["data"]["username"],
              'parent_email': emailController.text,
              'message': messageController.text,
            }
          },
        ),
      );

      navigator.pop();

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text("Report Sent to Parent's Email"),
            backgroundColor: theme.primaryColor,
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Unknown Error"),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        emailController.clear();
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: db
              .collection("users")
              .where("role", isEqualTo: "Student")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No Student Found"),
              );
            } else {
              var doc = [
                ...snapshot.data!.docs.map(
                  (x) => {
                    ...x.data(),
                    "id": x.id,
                  },
                )
              ];
              return ListView.builder(
                itemCount: doc.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                    reportModal(context);
                                  },
                                  child: const Text("Report To Parents"),
                                )
                              ],
                            ),
                            Image.network(doc[index]["photo"], height: 125)
                          ]),
                    ),
                  );
                },
              );
            }
          },
        ));
  }

  Future<dynamic> reportModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            height: 300,
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Parent's Email"),
                      border: OutlineInputBorder(),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Input Parent's Email";
                      } else if (!value.contains("@")) {
                        return "Input Valid Email";
                      } else if (value.length < 6) {
                        return "Minimum 6 Characters Length";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    minLines: 3,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: "Message",
                      labelText: "Message",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: messageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Input Your Message";
                      } else if (value.length < 6) {
                        return "Minimum 6 Characters Length";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => reportHandler,
                          child: const Text("Report"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
