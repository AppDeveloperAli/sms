import 'package:flutter/material.dart';
import 'package:student_mentogin_system/pages/student/pages/student_doubts.dart';
import 'package:student_mentogin_system/pages/student/pages/view_answer.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final studentDetail = route?.settings.arguments;
    List pages = [StudentDoubts(studentDetail), ViewAnswer(studentDetail)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Signed Out"),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Doubts Form",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: "View Answer",
          ),
        ],
      ),
    );
  }
}
