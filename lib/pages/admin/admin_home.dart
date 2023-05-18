import 'package:flutter/material.dart';
import 'package:student_mentogin_system/pages/admin/pages/add_mentor.dart';
import 'package:student_mentogin_system/pages/admin/pages/add_student.dart';
import 'package:student_mentogin_system/pages/admin/pages/mentor_detail.dart';
import 'package:student_mentogin_system/pages/admin/pages/student_detail.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List pages = const [
    AddMentor(),
    AddStudent(),
    MentorDetail(),
    StudentDetail()
  ];
  int currentIndex = 0;

  List menus = [
    {
      "index": 0,
      "icon": const Icon(Icons.support_agent),
      "title": "Add Mentor",
    },
    {
      "index": 1,
      "icon": const Icon(Icons.school),
      "title": "Add Student",
    },
    {
      "index": 2,
      "icon": const Icon(Icons.cast_for_education),
      "title": "Mentor Detail",
    },
    {
      "index": 3,
      "icon": const Icon(Icons.recent_actors),
      "title": "Student Detail",
    },
  ];

  void logoutHandler() async {
    var navigator = Navigator.of(context);
    var theme = Theme.of(context);
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    navigator.pushReplacementNamed("/");
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: const Text("Signed Out"),
        backgroundColor: theme.primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 10,
          ),
          child: Column(
            children: [
              ...menus.map(
                (e) => ListTile(
                  onTap: () {
                    setState(() {
                      currentIndex = e["index"];
                    });
                    Navigator.of(context).pop();
                  },
                  leading: e["icon"],
                  title: Text(e["title"]),
                ),
              ),
              ListTile(
                onTap: logoutHandler,
                leading: const Icon(Icons.logout),
                title: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          IconButton(
            onPressed: logoutHandler,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
