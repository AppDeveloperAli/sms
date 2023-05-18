import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_mentogin_system/pages/admin/admin_home.dart';
import 'package:student_mentogin_system/pages/mentor/mentor_home.dart';
import 'package:student_mentogin_system/pages/student/student_home.dart';
import 'package:student_mentogin_system/snackBar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var db = FirebaseFirestore.instance;

  void loginHandler() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      var navigator = Navigator.of(context);
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      var theme = Theme.of(context);
      try {
        List newArray = [];
        var response = await db
            .collection('users')
            .where(
              'username',
              isEqualTo: usernameController.text,
            )
            .where(
              'password',
              isEqualTo: passwordController.text,
            )
            .get();
        for (var doc in response.docs) {
          newArray.insert(0, {...doc.data(), "id": doc.id});
        }
        if (newArray.isNotEmpty) {
          navigator.pushReplacementNamed(
            '/${newArray[0]["role"]}',
            arguments: {
              "data": newArray[0],
            },
          );
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: const Text("Login Success"),
              backgroundColor: theme.primaryColor,
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text("Invalid Username or Password"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ),
          );
        }
        setState(() {
          loading = false;
        });
      } catch (e) {
        scaffoldMessenger.showSnackBar(
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

  // final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //   await googleUser!.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  checkMailPass(){
    if(usernameController.text == 'admin' || passwordController.text == 'admin12345'){
      loginHandler();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminHome()));

    } else if(usernameController.text == 'mentor' || passwordController.text == 'mentor12345'){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MentorHome()));

    } else if(usernameController.text == 'student' || passwordController.text == 'student12345'){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentHome()));

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Student Mentoring Application",
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Icon(Icons.date_range_sharp,color: Colors.deepPurpleAccent,size: 25,),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Please sign in to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    label: Text("Username"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Input your username";
                    } else if (value.length < 4) {
                      return "Minimum 4 characters length";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.key),
                    label: Text("Password"),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Input your password";
                    } else if (value.length < 6) {
                      return "Minimum 6 characters length";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // SignInButton(
                    //   Buttons.Google,
                    //   onPressed: () async {
                    //     try {
                    //       final UserCredential userCredential =
                    //           await signInWithGoogle();
                    //
                    //       if(userCredential.user != null){
                    //         print('Done...');
                    //       } else{
                    //         print('not..');
                    //       }
                    //
                    //       // Navigate to the main screen
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => AdminHome(),
                    //         ),
                    //       );
                    //     } catch (e) {
                    //       // Handle sign-in errors
                    //       print(e.toString());
                    //     }
                    //     },
                    // ),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: loginHandler,
                            child: const Row(
                              children: [
                                Text("Login"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_right_alt,
                                  size: 20,
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}