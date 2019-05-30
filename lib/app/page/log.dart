import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Log extends StatefulWidget {
  final String id;

  Log(this.id);

  @override
  _LogPage createState() => new _LogPage();
}

class _LogPage extends State<Log> {
  String logs;
  WebSocketChannel channel;

  @override
  Widget build(BuildContext context) {
    channel = new IOWebSocketChannel.connect(
        'wss://socket.bitcoinrobot.cn/${widget.id}');
    logs = "";
    return new Scaffold(
      body: new SingleChildScrollView(
          child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data.toString();
                    if (widget.id == "1") {
                      if (data.contains("[Tel]")) {
                        logs = "${data.replaceFirst("[Tel]", "")}\n\n${logs}";
                      }
                    } else {
                      logs = "${data}\n\n${logs}";
                    }
                  }
                  return new Text(logs);
                },
              ))),
    );
  }

  @override
  void dispose() {
    print("channer close");
    channel.sink.close();
    super.dispose();
  }
}
