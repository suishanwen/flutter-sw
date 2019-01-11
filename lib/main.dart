import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';
import 'reducer/combineRecuder.dart';
import 'model/user.dart';
import 'model/page.dart';
import 'model/telCard.dart';
import 'model/onlineCtrl.dart';
import 'reduxApp.dart';

void main() {
  final store = new Store<AppState>(
    appReducer,
    middleware: [thunkMiddleware, new LoggingMiddleware.printer()],
    initialState: new AppState(
      user: new User(false, '', null, null),
      page: new Page(false, 0, null),
      card: new TelCard(false, false, new List<CardInfo>(), null, null),
      onlineCtrl: new OnlineCtrl(false, false, new List<Controller>(), null),
    ),
  );
  runApp(new MaterialApp(
      title: 'NetUseMonitor',
      debugShowCheckedModeBanner: false,
      home: new ReduxApp(store)));
}
