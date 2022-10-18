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
  Future<List<Problem>>? problems;

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.problems = Database.fetchProblems();
    });
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
            const Expanded(
                flex: 1,
                child: Text("Programming Problems",
                    style: TextStyle(fontSize: 30))),
            Expanded(
              flex: 9,
              child: FutureBuilder<List<Problem>>(
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
