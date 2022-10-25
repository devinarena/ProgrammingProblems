import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:c_ide_test/database.dart';
import 'package:c_ide_test/menu.dart';
import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problem_card.dart';
import 'package:c_ide_test/problems.dart';
import 'package:c_ide_test/save_data.dart';
import 'package:c_ide_test/solve_page.dart';
import 'package:c_ide_test/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/scheduler/ticker.dart';

void main() {
  runApp(const ProgrammingProblems());
}

class ProgrammingProblems extends StatefulWidget {
  static ThemeProvider? themeProvider;
  const ProgrammingProblems({super.key});

  @override
  State<ProgrammingProblems> createState() => _ProgrammingProblemsState();
}

class _ProgrammingProblemsState extends State<ProgrammingProblems> {
  @override
  Widget build(BuildContext context) {
    ProgrammingProblems.themeProvider ??= ThemeProvider(context);
    ProgrammingProblems.themeProvider!.addListener(() {
      setState(() {});
    });
    return MaterialApp(
      title: 'JavaScript Puzzles',
      theme: ProgrammingProblems.themeProvider!.light,
      darkTheme: ProgrammingProblems.themeProvider!.dark,
      themeMode: SaveData.isLoaded
          ? ThemeMode.values.firstWhere(
              (element) => element.name == SaveData.getSave["theme"])
          : ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Future<List<Problem>>? problems;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    SaveData.loadSave().then((_) => setState(() {
          ProgrammingProblems.themeProvider!
              .setTheme(SaveData.getSave["theme"]);
        }));
    loadProblems();
  }

  ///
  /// Loads problems and other fields from the database.
  ///
  void loadProblems() {
    setState(() {
      problems = Database.fetchProblems();

      if (problems != null) {
        int sum = 0;
        int length = 0;
        problems!.then((problems) {
          for (Problem problem in problems) {
            sum += problem.points;
          }
          length = problems.length;

          setState(() {
            SaveData.getSave["totalProblems"] = max(length, 1);
            SaveData.getSave["totalPoints"] = sum;
          });
        });
      }
    });
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
            Tab(icon: Icon(Icons.menu)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController!,
        children: [
          Problems(problems!, loadProblems),
          MenuPage(problems!),
        ],
      ),
    );
  }
}
