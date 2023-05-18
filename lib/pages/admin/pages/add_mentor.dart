import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddMentor extends StatefulWidget {
  const AddMentor({super.key});

  @override
  State<AddMentor> createState() => _AddMentorState();
}

class _AddMentorState extends State<AddMentor> {
  var mentorController = TextEditingController();
  // var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var genderController = TextEditingController();
  var birthdateController = TextEditingController();
  var departmentController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  String photoImage = "";
  bool loading = false;

  final formKey = GlobalKey<FormState>();

  void pickImageHandler() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        photoImage = image.path;
      });
    }
  }

  int generateRandomNumber() {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    return code;
  }

  void submitHandler() async {
    if (formKey.currentState!.validate()) {
      if (photoImage != "") {
        var scaffoldMessenger = ScaffoldMessenger.of(context);
        var theme = Theme.of(context);
        setState(() {
          loading = true;
        });
        try {
          var db = FirebaseFirestore.instance;
          var storage = FirebaseStorage.instance;
          var storageRef = storage.ref(
              'mentors/${mentorController.text + DateTime.now().toString()}');
          await storageRef.putFile(File(photoImage));
          var imageURL = await storageRef.getDownloadURL();
          var generatedPassword = generateRandomNumber();
          await db.collection('users').add({
            "username": mentorController.text.trim(),
            "password": generatedPassword.toString(),
            "role": "Mentor",
            "phoneNumber": phoneController.text,
            "email": emailController.text,
            "gender": genderController.text,
            "birthDate": birthdateController.text,
            "department": departmentController.text,
            "state": stateController.text,
            "country": countryController.text,
            "photo": imageURL,
          });
          // await sendEmail(generatedPassword.toString());

          // Send Email
          final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
          const serviceId = 'service_egap2qu';
          const templateId = 'template_htyu37v';
          const userId = 'Br1fuTjchCKbsSrKu';
          await http.post(
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
                  'email': emailController.text,
                  'role': "Mentor",
                  'username': mentorController.text,
                  'password': generatedPassword,
                }
              },
            ),
          );
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: const Text("Mentor Created Successfully"),
              backgroundColor: theme.primaryColor,
            ),
          );
          setState(() {
            loading = false;
            mentorController.clear();
            phoneController.clear();
            emailController.clear();
            genderController.clear();
            birthdateController.clear();
            departmentController.clear();
            stateController.clear();
            countryController.clear();
            photoImage = "";
          });
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            loading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload Image"),
            duration: Duration(
              milliseconds: 300,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Mentor Name (Username)"),
                  suffixIcon: Icon(Icons.tag),
                ),
                controller: mentorController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Mentor Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Phone Number"),
                  suffixIcon: Icon(Icons.phone),
                ),
                controller: phoneController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Phone Number";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Email"),
                  suffixIcon: Icon(Icons.email_outlined),
                ),
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Email Address";
                  } else if (!value.contains("@")) {
                    return "Input Valid Email";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Gender ( Male or Female )"),
                  suffixIcon: Icon(Icons.male),
                ),
                controller: genderController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Your Gender";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                onTap: () async {
                  var pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    birthdateController.text = DateFormat("EEEE dd-MM-yyy")
                        .format(pickedDate)
                        .toString();
                  }
                },
                controller: birthdateController,
                decoration: const InputDecoration(
                  label: Text("Birth Date"),
                  suffixIcon: Icon(Icons.date_range),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Your Birth Date";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Department"),
                  suffixIcon: Icon(Icons.apartment),
                ),
                controller: departmentController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Department Name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("State"),
                  suffixIcon: Icon(Icons.place),
                ),
                controller: stateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input State";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Country"),
                  suffixIcon: Icon(Icons.flag),
                ),
                controller: countryController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Country";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  pickImageHandler();
                },
                child: Ink(
                  color: Colors.white,
                  width: double.infinity,
                  height: 200,
                  child: photoImage != ""
                      ? Image.file(
                          File(photoImage),
                          height: 200,
                        )
                      : const Center(child: Text("Upload Image")),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ElevatedButton(
                            onPressed: submitHandler,
                            child: const Text("Add New Mentor"),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
