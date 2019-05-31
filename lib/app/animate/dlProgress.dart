import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sw/action/socketAction.dart';

Dio dio = new Dio();

class DlProgress extends StatefulWidget {
  final String identity;
  final String type;

  DlProgress(this.identity, this.type);

  _AnimationApp createState() => new _AnimationApp();
}

class _AnimationApp extends State<DlProgress>
    with SingleTickerProviderStateMixin {
  Animation<double> tween;
  AnimationController controller;

  /*初始化状态*/
  initState() {
    super.initState();
    /*创建动画控制类对象*/
    if (widget.type == SocketAction.REPORT_STATE) {
      controller = new AnimationController(
          duration: const Duration(milliseconds: 5000), vsync: this);
    } else {
      controller = new AnimationController(
          duration: const Duration(milliseconds: 3000), vsync: this);
    }

    /*创建补间对象*/
    tween = new Tween(begin: 0.0, end: 1.0).animate(controller) //返回Animation对象
      ..addListener(() {
        if (tween.value == 1.0) {
          dio.post("https://bitcoinrobot.cn/api/mq/send/ctrl",
              data: {"code": widget.type, "identity": widget.identity});
          controller.forward(from: 0.0);
        }
        setState(() {});
      });
    controller.forward(); //执行动画
  }

  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          startAnimtaion(); //点击文本 重新执行动画
        },
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            value: controller.value,
          ),
        ));
  }

  startAnimtaion() {
    setState(() {
      controller.forward(from: 0.0);
    });
  }

  dispose() {
    //销毁控制器对象
    controller.dispose();
    super.dispose();
  }
}
