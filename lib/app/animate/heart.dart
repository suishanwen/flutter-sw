import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  _AnimationApp heartState = new _AnimationApp();

  _AnimationApp createState() => heartState;

  void beat() {
    heartState.heartBeat();
  }
}

class _AnimationApp extends State<Heart> with SingleTickerProviderStateMixin {
  Animation<double> tween;
  AnimationController controller;

  /*初始化状态*/
  initState() {
    super.initState();

    /*创建动画控制类对象*/
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    /*创建补间对象*/
    tween = new Tween(begin: 0.0, end: 1.0).animate(controller) //返回Animation对象
      ..addListener(() {
        if(mounted){
          setState(() {});
        }
      });

//    controller.forward(); //执行动画
  }

  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          startAnimtaion(); //点击文本 重新执行动画
        },
        child: new Image.network(
          'https://bitcoinrobot.cn/file/Heart.png',
          width: 30.0 * controller.value,
          height: 30.0 * controller.value,
        ));
  }

  startAnimtaion() {
    if (mounted){
      setState(() {
        controller.forward(from: 0.0);
      });
    }
  }

  heartBeat() {
    new Future.delayed(const Duration(seconds: 0), () {
      startAnimtaion();
    });
  }

  dispose() {
    //销毁控制器对象
    controller.dispose();
    super.dispose();
  }
}
