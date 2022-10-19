import 'package:c_ide_test/problem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static final dynamic _save = {};

  static get getSave => _save;

  static void loadSave() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> problemsSolved = prefs.getStringList('problemsSolved') ??
        List<String>.empty(growable: true);
    final int points = prefs.getInt('points') ?? 0;

    _save['problemsSolved'] = problemsSolved;
    _save['problemsSolved'] = List<String>.empty(growable: true);
    _save['points'] = points;
  }

  static void save() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList('problemsSolved', _save['problemsSolved']);
    prefs.setInt('points', _save['points']);
  }

  static Future<bool> solveProblem(Problem problem) async {
    if (_save['problemsSolved'].contains(problem.id)) {
      return false;
    }

    _save['problemsSolved'].add(problem.id);
    _save['points'] += problem.points;

    save();

    return true;
  }
}
