import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problem_card.dart';
import 'package:c_ide_test/save_data.dart';
import 'package:c_ide_test/solve_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
///
///

class Problems extends StatefulWidget {
  final Future<List<Problem>>? problems;
  final Function() loadProblems;

  const Problems(this.problems, this.loadProblems, {super.key});

  @override
  State<Problems> createState() => _ProblemsState();
}

class _ProblemsState extends State<Problems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SaveData.isLoaded
              ? Column(
                  children: [
                    const Text("JavaScript Puzzles",
                        style: TextStyle(fontSize: 30)),
                    const SizedBox(height: 10),
                    Text(
                        "Solved: ${SaveData.getSave["problemsSolved"].length} / ${SaveData.getSave["totalProblems"]} (${(SaveData.getSave["problemsSolved"].length / SaveData.getSave["totalProblems"] * 100).toStringAsFixed(2)}%)",
                        style: const TextStyle(fontSize: 20)),
                    LinearProgressIndicator(
                      value: SaveData.getSave["problemsSolved"] != null
                          ? SaveData.getSave["problemsSolved"].length /
                              SaveData.getSave["totalProblems"]
                          : 0,
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                      minHeight: 16.0,
                      semanticsLabel: "Progress",
                    ),
                    const SizedBox(height: 10),
                    SaveData.getSave["points"] != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stars, color: Colors.yellow[800]),
                              Text(
                                  "${SaveData.getSave["points"]} / ${SaveData.getSave["totalPoints"]}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.yellow[800]))
                            ],
                          )
                        : const CircularProgressIndicator(),
                  ],
                )
              : const LinearProgressIndicator(),
          Expanded(
            child: FutureBuilder<List<Problem>>(
              future: widget.problems,
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
                                widget.loadProblems();
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
    );
  }
}
