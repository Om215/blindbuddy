import 'dart:async';
import 'dart:io';
import 'currency.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'sos_dialog.dart';
import 'dialogue_ocr.dart';
import 'sos_dialog.dart';
// import 'package:helping_hands/sos/sos_dialog.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ocr_plugin/simple_ocr_plugin.dart';
import 'package:tflite/tflite.dart';
import 'package:telephony/telephony.dart';
import 'dart:math' as math;
import 'package:vibration/vibration.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _capImage;
  File _currImage;
  final FlutterTts flutterTts = FlutterTts();
  final Telephony telephony = Telephony.instance;

  PageController _controller = PageController(
    initialPage: 0,
  );

  Future getCurrImage() async {
    final currImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _currImage = currImage;
    });
    if (currImage != null) {
      CurrPage.currencyDetect(context, currImage);
    }
  }

  // Future getCapImage() async {
  //   final capImage = await ImagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _capImage = capImage;
  //   });
  //   if (capImage != null) {
  //     // imgCap.uploadImg(context, _capImage);
  //   }
  // }

  var sosCount = 0;
  var initTime;

  @override
  Future<void> initState() {
    super.initState();
    // smsPermission();

    // loadModel();

    print('shake');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      sendSms();
      // if (sosCount == 0) {
      //   print('count 0');
      //
      //   initTime = DateTime.now();
      //   ++sosCount;
      // }
      // else {
      //   if (DateTime.now().difference(initTime).inSeconds < 4) {
      //     ++sosCount;
      //     print('count 1');
      //
      //     if (sosCount == 2) {
      //       sendSms();
      //       sosCount = 0;
      //     }
      //     print(sosCount);
      //   }
      // else {
      //     sosCount = 0;
      //     print(sosCount);
      //   }
    });

    detector.startListening();
  }

  void getUserLocation() {}

  void sendSms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String n1 = prefs.getString('n1');
    String n2 = prefs.getString('n2');
    String n3 = prefs.getString('n3');
    String name = prefs.getString('name');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (position == null) {
      position = await Geolocator.getLastKnownPosition();
    }

    // String lat = (position.latitude).toString();
    // String long = (position.longitude).toString();

    double lat = position.latitude;
    double long = position.longitude;

    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    print(googleUrl);
    // String alt = (position.altitude).toString();
    // String speed = (position.speed).toString();
    String timestamp = (position.timestamp).toIso8601String();
    //var map=launch(googleUrl);
    telephony.sendSms(
        to: n1, message: "$name needs your help, last seen at: $googleUrl");
    telephony.sendSms(
        to: n2, message: "$name needs your help, last seen at:  $googleUrl");
    // telephony.sendSms(
    //     to: n3,
    //     message:
    //     //"$name needs you help, last seen at:  Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp"
    //     "Help me Hello");
  }

  // void smsPermission() async {
  //   bool permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
  // }

  // loadModel() async {
  //   String res = await Tflite.loadModel(
  //       model: "assets/ssd_mobilenet.tflite",
  //       labels: "assets/ssd_mobilenet.txt");
  //   print("MODEL" + res);
  // }

  @override
  Widget build(BuildContext context) {
    //  Size screen = MediaQuery.of(context).size;
    sosDialog sd = sosDialog();
    ocrDialog od = new ocrDialog();
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: _speakPage,
        children: <Widget>[
          //

          Container(
            child: Center(
                child: SizedBox.expand(
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(HexColor('#A8DEE0')),
                        ),
                        onPressed: () => od.optionsDialogBox(context),
                        child: Text("Extract text from Images",
                            style: TextStyle(
                                fontSize: 27.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))))),
            //color: HexColor('355C7D'),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              HexColor('#1d2671'),
              HexColor('#ed4264'),
            ])),
          ),
          Container(
            child: Center(
                child: SizedBox.expand(
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(HexColor('#F9E2E')),
                        ),
                        onPressed: () => getCurrImage(),
                        child: Text("Currency Identifier",
                            style: TextStyle(
                                fontSize: 27.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))))),
            //   color: HexColor('6C5B7B'),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              HexColor('#ed4264'),
              HexColor('#ffedbc'),
            ])),
          ),
          Container(
            child: Center(
                child: SizedBox.expand(
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(HexColor('#A8DEE0')),
                        ),
                        onPressed: () {
                          sd.sosDialogBox(context);
                        },
                        child: Text("SOS",
                            style: TextStyle(
                                fontSize: 27.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))))),
            // color: HexColor('F67280'),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              HexColor('#eecda3'),
              HexColor('#ef629f'),
            ])),
          ),
        ],
        scrollDirection: Axis.horizontal,
        pageSnapping: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  _speakPage(int a) async {
    if (a == 0) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(amplitude: 128, duration: 1400);
      }
      await flutterTts.speak("Text Extraction from images");
    } else if (a == 1) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(amplitude: 128, duration: 1800);
      }
      await flutterTts.speak("Currency Identifier");
    } else if (a == 2) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(amplitude: 128, duration: 2200);
      }
      await flutterTts.speak("SOS Settings");
    }
  }
}











































































// Container(
//   child: Stack(
//     children: [
//       Camera(
//         widget.cameras,
//         _model,
//         setRecognitions,
//       ),
//       BndBox(
//           _recognitions == null ? [] : _recognitions,
//           math.max(_imageHeight, _imageWidth),
//           math.min(_imageHeight, _imageWidth),
//           screen.height,
//           screen.width,
//           _model),
//     ],
//   ),
// ),