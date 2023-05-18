import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_mentogin_system/pages/admin/admin_home.dart';
import 'package:student_mentogin_system/pages/login.dart';
import 'package:student_mentogin_system/pages/mentor/mentor_home.dart';
import 'package:student_mentogin_system/pages/student/student_home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const Login(),
        "/Admin": (context) => const AdminHome(),
        "/Mentor": (context) => const MentorHome(),
        "/Student": (context) => const StudentHome(),
      },
    );
  }
}
