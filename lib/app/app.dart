import 'package:flutter/material.dart';
import 'package:sw/app/login.dart';
import 'package:sw/app/nav.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Navigation',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new Login(),
        '/nav': (BuildContext context) => new Nav(),
      },
    );
  }
}
