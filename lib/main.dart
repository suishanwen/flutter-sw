import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';
import 'reducer/combineRecuder.dart';
import 'model/user.dart';
import 'model/page.dart';
import 'reduxApp.dart';

void main() {
  final store = new Store<AppState>(
    appReducer,
    middleware: [thunkMiddleware,new LoggingMiddleware.printer()],
    initialState: new AppState(
      user: new User(false, '', null),
      page: new Page(false, 0, null),
    ),
  );
  runApp(new MaterialApp(title: 'NetUseMonitor', home: new ReduxApp(store)));
}
