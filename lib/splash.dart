import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void appConfig() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacementNamed((context), '/rca');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Image.asset(
          'images/splash.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
