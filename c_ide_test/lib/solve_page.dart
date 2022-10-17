import 'package:c_ide_test/database.dart';
import 'package:c_ide_test/main.dart';
import 'package:c_ide_test/problem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SolvePage extends StatefulWidget {
  final Problem problem;

  const SolvePage({super.key, required this.problem});
  @override
  State<SolvePage> createState() => _SolvePageState();
}

class _SolvePageState extends State<SolvePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.problem.startCode);
  }

  ///
  /// Makes an HTTP request with the given code to the server.
  ///
  void submit() async {
    String code = _controller.text;
    var res = await Database.submitProblem(id: widget.problem.id, code: code);
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.problem.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            MarkdownBody(
                data: "# ${widget.problem.number}. ${widget.problem.title}"),
            MarkdownBody(data: "### ${widget.problem.description}"),
            const SizedBox(
              height: 12,
            ),
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
          ],
        ),
      ),
    );
  }
}
