  import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';
import 'main.dart';


class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}


class _MySplashState extends State<MySplash> {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new HomePage(cameras),
      backgroundColor: Colors.white,

      photoSize: 200,
      gradientBackground: LinearGradient(
        colors: [
          HexColor('#ee9ca7'),
          HexColor('#ffdde1')
        ]
      ),
      loaderColor: Colors.grey,
      image: Image.asset('assets/ikshana_demo.png',


        fit: BoxFit.fill,
      ),

      loadingText: Text('Ikshana we become your eyes',
      style: TextStyle(
        fontSize: 20,

      ),),
    );
  }
}
