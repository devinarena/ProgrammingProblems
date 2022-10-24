import 'package:c_ide_test/main.dart';
import 'package:c_ide_test/save_data.dart';
import 'package:c_ide_test/theme.dart';
import 'package:flutter/material.dart';

///
/// User interface for the settings page. Allows the user to change the
/// application's settings.
///

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Theme: ", style: TextStyle(fontSize: 24.0)),
                    const SizedBox(width: 100),
                    DropdownButton(
                      value: SaveData.getSave["theme"] ?? "system",
                      items: const <DropdownMenuItem>[
                        DropdownMenuItem(
                          value: "light",
                          child: Text("Light"),
                        ),
                        DropdownMenuItem(
                          value: "dark",
                          child: Text("Dark"),
                        ),
                        DropdownMenuItem(
                          value: "system",
                          child: Text("System"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          ProgrammingProblems.themeProvider!.setTheme(value);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
