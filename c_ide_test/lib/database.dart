import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:c_ide_test/problem.dart';

class Database {
  static const dbURL = "10.0.0.68:5000";

  static Future<List<Problem>> fetchProblems() async {
    final response = await http.get(Uri.parse('http://$dbURL/problems'));
    if (response.statusCode == 200) {
      List<Problem> problems = [];
      for (var problem in jsonDecode(response.body)) {
        problems.add(Problem.fromJson(problem));
      }
      return problems;
    } else {
      throw Exception('Failed to load problem');
    }
  }

  static Future<dynamic> submitProblem(
      {required String id, required String code}) async {
    final response = await http.post(Uri.parse('http://$dbURL/solve'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'code': code,
        }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit problem');
    }
  }
}
