import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:c_ide_test/problem.dart';

class Database {
  // static const dbURL = "10.0.0.68:5000";
  static const dbURL = "73.156.33.157:5000";

  static Future<List<Problem>> fetchProblems() async {
    try {
      final response = await http.get(Uri.http(dbURL, "/problems"));
      if (response.statusCode == 200) {
        List<dynamic> problems = jsonDecode(response.body);
        return problems.map((e) => Problem.fromJson(e)).toList();
      } else {
        print("Failed to load problems");
      }
    } catch (e) {
      print("Failed to load problems");
    }
    return [];
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
