import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';
import 'reducer/combineRecuder.dart';
import 'model/appState.dart';
import 'reduxApp.dart';

void main() {
  final store = new Store<AppState>(
    appReducer,
    middleware: [thunkMiddleware, new LoggingMiddleware.printer()],
    initialState: AppState.init(),
  );
  runApp(new MaterialApp(
      title: 'NetUseMonitor',
      debugShowCheckedModeBanner: false,
      home: new ReduxApp(store)));
}
