import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student_mentogin_system/snackBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentDoubts extends StatefulWidget {
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
        String urlDown = '';

        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
        if (result != null) {
          File file = File(result.files.single.path!);
          String fileName = result.files.single.name;
          Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
          UploadTask uploadTask = storageRef.putFile(file);

          // Wait for the upload to complete
          await uploadTask.whenComplete(() {
          });

          urlDown = await storageRef.getDownloadURL();

        }

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
              "PDF": urlDown,
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

    String _filePath = '';

    Future<String?> pickPDFFile() async {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _filePath = result.files.single.path!;
        });
        PlatformFile file = result.files.first;
        return file.path;
      } else {
        return null;
      }
    }

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
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Selected PDF File'),
              //     Text(
              //       _filePath,
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //     ElevatedButton(
              //     onPressed: () async {
              //       String? filePath = await pickPDFFile();
              //       if (filePath != null) {
              //         // Do something with the picked file path
              //         print('Picked file path: $filePath');
              //       }
              //     },
              //     child: Text('Pick PDF File'),
              //   ),
              // ],),
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
                              "Pick a PDF & Submit Doubts",
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
