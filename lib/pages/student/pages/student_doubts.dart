import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student_mentogin_system/snackBar.dart';

// ignore: must_be_immutable
class StudentDoubts extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var data;
  StudentDoubts(this.data, {super.key});

  @override
  State<StudentDoubts> createState() => _StudentDoubtsState();
}

class _StudentDoubtsState extends State<StudentDoubts> {
  bool loading = false;
  var formKey = GlobalKey<FormState>();
  var doubtsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var studentDetail = widget.data["data"];

    void submitHandler() async {
      if (formKey.currentState!.validate()) {
        var scaffoldMessenger = ScaffoldMessenger.of(context);
        var theme = Theme.of(context);
        setState(() {
          loading = true;
        });
        try {
          var db = FirebaseFirestore.instance;
          await db.collection("doubts").add(
            {
              "studentId": studentDetail["id"],
              "username": studentDetail["username"],
              "phoneNumber": studentDetail["phoneNumber"],
              "email": studentDetail["email"],
              "gender": studentDetail["gender"],
              "birthDate": studentDetail["birthDate"],
              "department": studentDetail["department"],
              "photo": studentDetail["photo"],
              "doubts": doubtsController.text,
              "reply": ""
            },
          );
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: const Text(
                "Student Doubts Submitted",
              ),
              backgroundColor: theme.primaryColor,
              duration: const Duration(seconds: 1),
            ),
          );
          setState(() {
            loading = false;
            doubtsController.clear();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString(),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1),
            ),
          );
          setState(() {
            loading = false;
          });
        }
      }
    }

    String fileName = 'Picked File name show here...';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: studentDetail["id"],
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Student ID'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: studentDetail["username"],
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Student Name'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: studentDetail["phoneNumber"].toString(),
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Phone Number'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: studentDetail["email"],
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: studentDetail["gender"],
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Gender'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: studentDetail["birthDate"],
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Birth Date'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: studentDetail["department"],
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Department'),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  hintText: "Student Doubts",
                  labelText: "Doubts",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                controller: doubtsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Your Doubts";
                  } else if (value.length < 10) {
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
              //       fileName = fileDetailes.name;
              //
              //        CustomSnackBar(context,Text('File Name : ${fileDetailes.name}'));
              //
              //     } else {
              //       setState(() {
              //         CustomSnackBar(context,Text('You cancelled picking file..'));
              //       });
              //     }
              //   },
              //   child: Text(
              // 'Pick a File',
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ElevatedButton(
                            onPressed: submitHandler,
                            child: const Text(
                              "Submit Doubts",
                            ),
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
