import 'package:c_ide_test/database.dart';
import 'package:c_ide_test/main.dart';
import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/save_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SolvePage extends StatefulWidget {
  final Problem problem;
  dynamic result;

  SolvePage({super.key, required this.problem, this.result});
  @override
  State<SolvePage> createState() => _SolvePageState();
}

class _SolvePageState extends State<SolvePage> {
  late TextEditingController _controller;
  bool _pressedSolve = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.problem.startCode);
  }

  ///
  /// Makes an HTTP request with the given code to the server.
  ///
  void submit() async {
    setState(() {
      _pressedSolve = true;
      widget.result = null;
    });
    String code = _controller.text;
    dynamic res =
        await Database.submitProblem(id: widget.problem.id, code: code);
    if (res["success"]) {
      res["reward"] = await SaveData.solveProblem(widget.problem);
    }
    setState(() {
      widget.result = res;
    });
    print(widget.result);
  }

  ///
  /// Conditionally displays the result of a submission.
  ///
  Widget resultWidget() {
    if (widget.result == null) {
      return _pressedSolve
          ? const CircularProgressIndicator()
          : const Text("No submission yet");
    } else {
      String output =
          "### Submission successful! Passed ${widget.result['total']} cases.";
      if (widget.result["success"]) {
      } else {
        output =
            "### Submission failed. Passed ${widget.result['passed'].length} / ${widget.result['total']} cases.";

        output += "\n### Failed Case\n";
        output += "```\n";
        output += widget.result["input"]
            .toString()
            .substring(1, widget.result["input"].toString().length - 1);
        output += "\n```\n";
        output += "### Expected Output\n";
        output += "```\n";
        output += widget.result["expected"].toString();
        output += "\n```\n";
        output += "### Actual Output\n";
        output += "```\n";
        output += widget.result["output"].toString();
        output += "\n```\n";
      }

      return MarkdownBody(
        data: output,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.problem.title),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MarkdownBody(
                  data: "# ${widget.problem.number}. ${widget.problem.title}"),
              MarkdownBody(data: widget.problem.description),
              const Divider(height: 30, thickness: 1.0),
              const MarkdownBody(data: "## Solution"),
              TextFormField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Solution',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(onPressed: submit, child: const Text("Submit")),
              const Divider(height: 30, thickness: 1.0),
              const MarkdownBody(data: "## Submission"),
              resultWidget(),
              if (widget.result != null &&
                  widget.result["reward"] != null &&
                  widget.result["reward"])
                Column(
                  children: [
                    const MarkdownBody(data: "## Reward"),
                    Icon(Icons.stars, color: Colors.yellow[800], size: 50),
                    Text(
                      "${widget.problem.points} points!",
                      style: TextStyle(fontSize: 20, color: Colors.yellow[800]),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
