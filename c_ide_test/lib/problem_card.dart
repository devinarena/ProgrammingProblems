import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/save_data.dart';
import 'package:c_ide_test/solve_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProblemCard extends StatefulWidget {
  final Problem problem;
  final void Function()? onTap;

  const ProblemCard({required this.problem, required this.onTap});

  @override
  State<ProblemCard> createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${widget.problem.number}. ${widget.problem.title}",
            style: TextStyle(
                fontSize: 20,
                color: (SaveData.getSave["problemsSolved"] != null &&
                        SaveData.getSave["problemsSolved"]
                            .contains(widget.problem.id))
                    ? Colors.green
                    : null)),
        subtitle: Text(widget.problem.shortDesc,
            style: const TextStyle(fontSize: 20)),
        trailing: Column(children: [
          Icon(Icons.stars, color: Colors.yellow[800]),
          Text("${widget.problem.points} pts",
              style: TextStyle(fontSize: 20, color: Colors.yellow[800]))
        ]),
        onTap: widget.onTap,
      ),
    );
  }
}
