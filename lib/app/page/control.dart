import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Control extends StatefulWidget {
  final String identity;
  WebSocketChannel channel;

  Control(this.identity);

  @override
  _ControlPage createState() => new _ControlPage();
}

class _ControlPage extends State<Control> {
  @override
  Widget build(BuildContext context) {
    widget.channel = new IOWebSocketChannel.connect(
        'ws://bitcoinrobot.cn:8051/sw/api/websocket/${widget.identity}_mobi');
    return new Scaffold(
      body: new SingleChildScrollView(
          child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  var data = "";
                  if (snapshot.hasData) {
                    data = snapshot.data.toString();
                  }
                  return new Text(data);
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
