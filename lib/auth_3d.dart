import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Auth3D extends StatefulWidget {
  Auth3D({
    Key? key,
  }) : super(key: key);

  @override
  _Auth3D createState() => _Auth3D();
}

class _Auth3D extends State<Auth3D> with TickerProviderStateMixin {
  int _number = 654321;
  late Timer timer;
  late AnimationController controller;
  int _duration = 10;

  @override
  void initState() {
    _number = getRandomNum();
    setTimer();
    setProgress();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  void setTimer() {
    timer = Timer.periodic(Duration(seconds: _duration), (timer) async {
      setState(() {
        _number = getRandomNum();
      });
      controller.dispose();
      setProgress();
    });
  }

  void setProgress() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _duration),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
  }

  int getRandomNum() {
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("3D Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your authentication code:',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_number',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: controller.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
