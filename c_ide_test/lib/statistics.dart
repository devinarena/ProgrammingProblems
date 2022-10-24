import 'dart:convert';

import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problems.dart';
import 'package:c_ide_test/save_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Statistics page for the application
///

class Statistics extends StatefulWidget {
  final Future<List<Problem>> problems;
  const Statistics(this.problems, {super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Widget progressCard(String title, double value, Color color) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.6),
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 16.0,
          semanticsLabel: "Progress",
        ),
        trailing: Text("${(value * 100).toStringAsFixed(2)}%",
            style: TextStyle(fontSize: 28.0, color: color)),
      ),
    );
  }

  Widget fractionCard(
      String title, String subtitle, int value, int total, Color color) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text("$value / $total",
            style: TextStyle(fontSize: 28.0, color: color)),
      ),
    );
  }

  Widget counterCard(String title, String subtitle, int value, Color color) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing:
            Text("$value", style: TextStyle(fontSize: 28.0, color: color)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SaveData.isLoaded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    progressCard(
                        "Total problems solved",
                        SaveData.getSave["problemsSolved"].length /
                            SaveData.getSave["totalProblems"],
                        Theme.of(context).primaryColor),
                    progressCard(
                        "Total points",
                        SaveData.getSave["points"] /
                            SaveData.getSave["totalPoints"],
                        Colors.yellow[600]!),
                    counterCard(
                        "Submissions",
                        "Code entries submitted for any problem",
                        0,
                        Colors.black),
                    counterCard(
                      "Successful submissions",
                      "Code entries that passed all tests",
                      0,
                      Colors.green,
                    ),
                    counterCard(
                      "Failed submissions",
                      "Code entries that failed at least one test",
                      0,
                      Colors.red,
                    ),
                    counterCard(
                      "Total tests passed",
                      "Total number of tests passed",
                      0,
                      Colors.indigo,
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
