import 'package:flutter/material.dart';
import 'package:student_mentogin_system/pages/mentor/pages/report_to_parents.dart';
import 'package:student_mentogin_system/pages/mentor/pages/view_doubts.dart';

class MentorHome extends StatefulWidget {
  const MentorHome({super.key});

  @override
  State<MentorHome> createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;
    List pages = [ViewDoubts(data), ReportToParents(data)];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentor Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Signed Out"),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            },
          )
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.question_answer,
            ),
            label: "View Doubts",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.campaign,
            ),
            label: "Report to Parents",
          ),
        ],
      ),
    );
  }
}
