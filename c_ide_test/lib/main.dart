import 'dart:convert';
import 'dart:io';

import 'package:c_ide_test/database.dart';
import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problem_card.dart';
import 'package:c_ide_test/save_data.dart';
import 'package:c_ide_test/solve_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/scheduler/ticker.dart';

void main() {
  runApp(const ProgrammingProblems());
}

class ProgrammingProblems extends StatelessWidget {
  const ProgrammingProblems({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JavaScript Puzzles',
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Future<List<Problem>>? problems;
  int numProblems = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text("JavaScript Puzzles"),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController!,
          indicatorColor: Colors.white,
          tabs: const <Tab>[
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(icon: Icon(Icons.star)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController!,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (SaveData.isLoaded)
                  Column(
                    children: [
                      const Text("JavaScript Puzzles",
                          style: TextStyle(fontSize: 30)),
                      const SizedBox(height: 10),
                      Text(
                          "Solved: ${SaveData.getSave["problemsSolved"].length} / $numProblems (${(SaveData.getSave["problemsSolved"].length / numProblems * 100).toStringAsFixed(2)}%)",
                          style: const TextStyle(fontSize: 20)),
                      LinearProgressIndicator(
                        value: SaveData.getSave["problemsSolved"] != null
                            ? SaveData.getSave["problemsSolved"].length /
                                numProblems
                            : 0,
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                        minHeight: 16.0,
                        semanticsLabel: "Progress",
                      ),
                      const SizedBox(height: 10),
                      SaveData.getSave["points"] != null
                          ? Column(
                              children: [
                                Icon(Icons.stars, color: Colors.yellow[800]),
                                Text("Points ${SaveData.getSave["points"]}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.yellow[800]))
                              ],
                            )
                          : const CircularProgressIndicator(),
                    ],
                  )
                else
                  const LinearProgressIndicator(),
                Expanded(
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
                                                  problem:
                                                      snapshot.data![index])))
                                      .then((value) => setState(() {}));
                                },
                              );
                            },
                          );
                        }
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text("Could not load problems"));
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Statistics coming soon...",
                style: TextStyle(fontSize: 28),
              ),
            ),
          )
        ],
      ),
    );
  }
}
