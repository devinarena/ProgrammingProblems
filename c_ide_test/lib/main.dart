import 'dart:convert';
import 'dart:io';

import 'package:c_ide_test/database.dart';
import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problem_card.dart';
import 'package:c_ide_test/save_data.dart';
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
    setState(() {
      SaveData.loadSave();
    });
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
      problems!.then((problems) => setState(() {
            numProblems = problems.length;
          }));
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
                  SaveData.getSave["problemsSolved"] != null
                      ? Text(
                          "Solved: ${SaveData.getSave["problemsSolved"].length} / $numProblems",
                          style: const TextStyle(fontSize: 20))
                      : const CircularProgressIndicator(),
                  SaveData.getSave["points"] != null
                      ? Column(
                          children: [
                            Icon(Icons.stars, color: Colors.yellow[800]),
                            Text("Points ${SaveData.getSave["points"]}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.yellow[800]))
                          ],
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            ),
            Expanded(
              flex: 5,
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
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SolvePage(
                                              problem: snapshot.data![index])))
                                  .then((value) => setState(() {}));
                            },
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
