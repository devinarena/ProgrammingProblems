import 'package:c_ide_test/problem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeEditor extends StatefulWidget {
  final Problem problem;
  final TextEditingController controller;

  const CodeEditor(this.problem, this.controller, {super.key});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Solution',
      ),
    );
  }
}
