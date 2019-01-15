import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Log extends StatefulWidget {
  WebSocketChannel channel;
  String logs;

  @override
  _LogPage createState() => new _LogPage();
}

class _LogPage extends State<Log> {
  @override
  Widget build(BuildContext context) {
    widget.channel =
        new IOWebSocketChannel.connect('ws://bitcoinrobot.cn:9090/');
    widget.logs = "";
    return new Scaffold(
      body: new SingleChildScrollView(
          child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    widget.logs = "${snapshot.data}\n\n${widget.logs}";
                  }
                  return new Text(widget.logs);
                },
              ))),
    );
  }

  @override
  void dispose() {
    print("channer close");
    widget.channel.sink.close();
    super.dispose();
  }
}
