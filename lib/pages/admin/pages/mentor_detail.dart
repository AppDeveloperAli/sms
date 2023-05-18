import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MentorDetail extends StatefulWidget {
  const MentorDetail({super.key});

  @override
  State<MentorDetail> createState() => _MentorDetailState();
}

class _MentorDetailState extends State<MentorDetail> {
  var db = FirebaseFirestore.instance;

  void deleteHandler(String id, String photoURL) async {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    var theme = Theme.of(context);
    try {
      var storage = FirebaseStorage.instance;
      var db = FirebaseFirestore.instance;
      await db.collection("users").doc(id).delete();
      await storage.refFromURL(photoURL).delete();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text("Mentor Account Deleted"),
          duration: const Duration(seconds: 1),
          backgroundColor: theme.primaryColor,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream: db
            .collection("users")
            .where("role", isEqualTo: "Mentor")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Mentor Found"),
            );
          }

          var fetchedData = [];
          for (var doc in snapshot.data!.docs) {
            fetchedData.insert(0, {...doc.data(), "id": doc.id});
          }
          return ListView.builder(
            itemCount: fetchedData.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Username : ${fetchedData[index]["username"]}',
                                    ),
                                    Text(
                                      'Department : ${fetchedData[index]["department"]}',
                                    ),
                                    Text(
                                      'Gender : ${fetchedData[index]["gender"]}',
                                    ),
                                    Text(
                                      'Birth Date : ${fetchedData[index]["birthDate"]}',
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () => deleteHandler(
                                        fetchedData[index]["id"],
                                        fetchedData[index]["photo"],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Delete Mentor'),
                                    ),
                                  ],
                                ),
                              ),
                              Image.network(
                                fetchedData[index]["photo"],
                                height: 100,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Email : ${fetchedData[0]["email"]}',
                          ),
                        ],
                      )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
