import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StudentDetail extends StatefulWidget {
  const StudentDetail({super.key});

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
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
          content: const Text("Student Account Deleted"),
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
            .where("role", isEqualTo: "Student")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Student Found"),
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
                                    ElevatedButton(
                                      onPressed: () => deleteHandler(
                                        fetchedData[index]["id"],
                                        fetchedData[index]["photo"],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Delete Student'),
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
                          const SizedBox(height: 10),
                          Text("Email : ${fetchedData[index]["email"]}")
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
