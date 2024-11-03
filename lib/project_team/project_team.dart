import 'package:flutter/material.dart';

class project_team extends StatefulWidget {
  const project_team({super.key});

  @override
  State<project_team> createState() => _project_teamState();
}

class _project_teamState extends State<project_team> {
  
final List<String> teamMembers = List.generate(10, (index) => "Team Member ${index + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet the Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards per row
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 3 / 2, // Adjust this ratio to modify card size
          ),
          itemCount: teamMembers.length,
          itemBuilder: (context, index) {
            return teamMemberCard(teamMembers[index]);
          },
        ),
      ),
    );
  }

  Widget teamMemberCard(String name) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}