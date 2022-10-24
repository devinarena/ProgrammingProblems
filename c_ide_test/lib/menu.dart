import 'package:c_ide_test/problem.dart';
import 'package:c_ide_test/problems.dart';
import 'package:c_ide_test/settings.dart';
import 'package:c_ide_test/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// Second tab of the home screen, options menu
///

class MenuPage extends StatefulWidget {
  final Future<List<Problem>> problems;

  const MenuPage(this.problems, {super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Uri repoURL =
      Uri.parse("https://github.com/devinarena/ProgrammingProblems");
  final Uri issuesURL =
      Uri.parse("https://github.com/devinarena/ProgrammingProblems/issues/new");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              child: ListTile(
                title: const Text("Statistics"),
                subtitle: const Text("View your locally-saved statistics"),
                leading: const Icon(Icons.bar_chart, size: 40.0),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Statistics(widget.problems),
                )),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Settings"),
                subtitle: const Text("Customize your experience"),
                leading: const Icon(Icons.settings, size: 40.0),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Settings(),
                )),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Manage save data"),
                subtitle: const Text("Backup, restore, or delete save data"),
                leading: const Icon(Icons.import_export, size: 40.0),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Suggest a problem"),
                subtitle: const Text("Have an idea? Create an issue!"),
                leading: const Icon(Icons.edit, size: 40.0),
                onTap: () async {
                  if (!await launchUrl(issuesURL)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to open GitHub repository"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("GitHub Repository"),
                subtitle: const Text("Contribute or view the source code"),
                leading: const Icon(Icons.code, size: 40.0),
                onTap: () async {
                  if (!await launchUrl(repoURL)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to open GitHub repository"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Software Info"),
                subtitle: const Text("Version: 1.0"),
                leading: const Icon(Icons.info, size: 40.0),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
