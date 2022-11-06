import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'splashscreen.dart';

List<CameraDescription> cameras;

// void PlayAudio()
// {
//   final player=AudioCache();
//   player.play('note7.wav');
// }


Future<Null> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new MyApp());

}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ikshana',
      debugShowCheckedModeBanner: false,
      home: MySplash(),
    );
  }
}
