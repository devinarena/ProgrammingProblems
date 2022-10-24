import 'package:flutter/material.dart';

import 'package:c_ide_test/save_data.dart';

class ThemeProvider extends ChangeNotifier {
  late final ThemeData? light;
  late final ThemeData? dark;

  ThemeProvider(BuildContext context) {
    dark = ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
        textTheme: Theme.of(context).textTheme.apply(
            fontSizeFactor: 1.25,
            decorationColor: Colors.white,
            displayColor: Colors.white70,
            bodyColor: Colors.white));
    light = ThemeData(
        primarySwatch: Colors.red,
        textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 1.25));
  }

  get lightTheme => light;
  get darkTheme => dark;
  get theme => SaveData.getSave["theme"] == "dark" ? dark : light;

  void setTheme(String theme) {
    SaveData.getSave["theme"] = theme;
    SaveData.save();
    notifyListeners();
  }
}
