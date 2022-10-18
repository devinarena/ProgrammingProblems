import 'dart:convert';
import 'dart:io';

import 'package:c_ide_test/database.dart';
import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problem_card.dart';
import 'package:c_ide_test/solve_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      darkTheme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
          textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.25,
              decorationColor: Colors.white,
              displayColor: Colors.white70,
              bodyColor: Colors.white)),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Problem>>? problems;
  int numProblems = 0;

  @override
  void initState() {
    super.initState();
    loadProblems();
  }

  ///
  /// Loads problems and other fields from the database.
  ///
  void loadProblems() {
    setState(() {
      problems = Database.fetchProblems();
    });
    if (problems != null) {
      problems!.then((problems) => {numProblems = problems.length});
    }
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Text("Programming Problems",
                      style: TextStyle(fontSize: 30)),
                  Text("Solved: 0 / $numProblems",
                      style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: FutureBuilder<List<Problem>>(
                future: problems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Could not load problems"),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  loadProblems();
                                },
                                child: const Icon(Icons.refresh))
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ProblemCard(
                            problem: snapshot.data![index],
                          );
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Could not load problems"));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
