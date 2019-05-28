import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Log extends StatefulWidget {
  final String id;
  String logs;
  WebSocketChannel channel;

  Log(this.id);

  @override
  _LogPage createState() => new _LogPage();
}

class _LogPage extends State<Log> {
  @override
  Widget build(BuildContext context) {
    widget.channel = new IOWebSocketChannel.connect(
        'wss://socket.bitcoinrobot.cn/${widget.id}');
    widget.logs = "";
    return new Scaffold(
      body: new SingleChildScrollView(
          child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data.toString();
                    if (widget.id == "1" && data.contains("[Tel]")) {
                      widget.logs =
                          "${data.replaceFirst("[Tel]", "")}\n\n${widget.logs}";
                    } else {
                      widget.logs = "${data}\n\n${widget.logs}";
                    }
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
