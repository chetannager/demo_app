import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as maths;
import 'package:demo_app/listener.dart';

class Compass extends StatefulWidget {
  const Compass({Key key}) : super(key: key);

  @override
  _CompassState createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  StreamSubscription _streamSubscription;

  List<double> sensorValues;

  @override
  void initState() {
    sensorValues = <double>[];

    _streamSubscription = eventData.listen((event) {
      if (this.mounted) {
        setState(() {
          sensorValues = <double>[event.x, event.y, event.z];
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double angle = maths.atan2(sensorValues[1], sensorValues[0]);
    return Scaffold(
      appBar: AppBar(title: Text("Compass")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: maths.pi / 2 - angle,
              child: Image.asset("images/compass.png"),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              angle.toString() + "°",
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
