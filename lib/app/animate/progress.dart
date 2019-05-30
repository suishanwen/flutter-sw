import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:sw/model/appState.dart';
import 'package:sw/model/baseState.dart';

class Progress extends StatefulWidget {
  Progress();

  _Progress createState() => new _Progress();
}

class _Progress extends State<Progress> {
  ProgressHUD _progressHUD;

  initState() {
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading...',
      loading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, BaseState>(converter: (store) {
      if (mounted && _progressHUD.state != null) {
        if (store.state.base.loading) {
          _progressHUD.state.show();
        } else {
          _progressHUD.state.dismiss();
        }
      }
      return store.state.base;
    }, builder: (context, base) {
      return _progressHUD;
    });
  }
}
