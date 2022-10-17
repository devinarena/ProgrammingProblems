import 'dart:convert';
import 'dart:io';

import 'package:c_ide_test/database.dart';
import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problem_card.dart';
import 'package:c_ide_test/solve_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProgrammingProblems());
}

class ProgrammingProblems extends StatelessWidget {
  const ProgrammingProblems({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programming Problems',
      theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 1.25)),
      darkTheme: ThemeData(primaryColor: Colors.red),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  late Future<List<Problem>> problems;

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.problems = Database.fetchProblems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programming Problems"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Programming Problems", style: TextStyle(fontSize: 30)),
            const Text("Solved: 0 / 1", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            FutureBuilder<List<Problem>>(
              future: widget.problems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ProblemCard(
                        problem: snapshot.data![index],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
