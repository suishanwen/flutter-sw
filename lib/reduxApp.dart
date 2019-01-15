import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sw/app/app.dart';
import 'model/appState.dart';

class ReduxApp extends StatelessWidget {
  final Store store;

  ReduxApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new App(),
    );
  }
}
