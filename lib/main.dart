import 'package:flutter/material.dart';
import 'package:flutter_github_repos/presentation/home/home_page.dart';
import 'package:flutter_github_repos/service_locator.dart';

void main() {
  setup();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
