import 'dart:async';

import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:gallery_saver/files.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_recorder/screen_recorder.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';

import 'package:video_player/video_player.dart';
import 'package:flutter_application_1/home_section/jet.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/home_section/exporter.dart';
import 'package:flutter_application_1/home_section/frame.dart';

// class ScreenRecorderController {
//   final SchedulerBinding? binding;
//   final Exporter _exporter = Exporter();
//
//
//   ScreenRecorderController({
//     this.pixelRatio = 0.5,
//     this.skipFramesBetweenCaptures = 2,
//     this.binding,
//   })  : _containerKey = GlobalKey(),
//         _binding = binding ?? SchedulerBinding.instance;
//
//   final GlobalKey _containerKey;
//   final SchedulerBinding _binding;
//
//   /// The pixelRatio describes the scale between the logical pixels and the size
//   /// of the output image. Specifying 1.0 will give you a 1:1 mapping between
//   /// logical pixels and the output pixels in the image. The default is a pixel
//   /// ration of 3 and a value below 1 is not recommended.
//   ///
//   /// See [RenderRepaintBoundary](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html)
//   /// for the underlying implementation.
//   final double pixelRatio;
//
//   /// Describes how many frames are skipped between captured frames.
//   /// For example, if skipFramesBetweenCaptures = 2, screen_recorder
//   /// captures a frame, skips the next two frames, and then captures the next
//   /// frame again.
//   final int skipFramesBetweenCaptures;
//
//   int skipped = 0;
//
//   bool _record = false;
//
//   void start() {
//     // Only start recording if no recording is in progress
//     if (_record) {
//       return;
//     }
//     _record = true;
//     _binding.addPostFrameCallback(postFrameCallback);
//   }
//
//   void stop() {
//     _record = false;
//   }
//
//   void postFrameCallback(Duration timestamp) async {
//     if (!_record) {
//       return;
//     }
//     if (skipped > 0) {
//       // Count down frames that should be skipped
//       skipped--;
//       // Add a new PostFrameCallback to capture the next frame
//       _binding.addPostFrameCallback(postFrameCallback);
//       // Skip this frame
//       return;
//     }
//     if (skipped == 0) {
//       // Reset skipped frame counter
//       skipped += skipFramesBetweenCaptures;
//     }
//     try {
//       final image = await capture();
//       if (image == null) {
//         print('capture returned null');
//         return;
//       }
//       _exporter.onNewFrame(Frame(timestamp, image));
//     } catch (e) {
//       print(e.toString());
//     }
//     _binding.addPostFrameCallback(postFrameCallback);
//   }
//
//   Future<ui.Image?> capture() async {
//     final renderObject = _containerKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//
//     if (renderObject == null) {
//       return null;
//     }
//
//     return await renderObject.toImage(pixelRatio: pixelRatio);
//   }
// }


class AdditionalSettingsDialog extends StatefulWidget {
  final ValueChanged<String> onStreamUrlChanged;

  const AdditionalSettingsDialog({Key? key, required this.onStreamUrlChanged}) : super(key: key);

  @override
  _AdditionalSettingsDialogState createState() => _AdditionalSettingsDialogState();
}

class _AdditionalSettingsDialogState extends State<AdditionalSettingsDialog> {


  late SharedPreferences _prefs;
  double brightnessValue = 0;
  double contrastValue = 0;
  double saturationValue = 0;



  bool switch1Value = false;
  bool switch2Value = false;
  bool switch3Value = false;
  bool switch4Value = false;
  bool switch5Value = false;



  @override
  void initState() {
    super.initState();
    // Initialize SharedPreferences instance
    _initPrefs();
  }


  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Retrieve the switch states from SharedPreferences
    setState(() {
      switch1Value = _prefs.getBool('switch1Value') ?? false;
      switch2Value = _prefs.getBool('switch2Value') ?? false;
      switch3Value = _prefs.getBool('switch3Value') ?? false;
      switch4Value = _prefs.getBool('switch4Value') ?? false;
      switch5Value = _prefs.getBool('switch5Value') ?? false;
    });
    setState(() {
      brightnessValue = _prefs.getDouble('brightnessValue') ?? 0;
      contrastValue = _prefs.getDouble('contrastValue') ?? 0;
      saturationValue = _prefs.getDouble('saturationValue') ?? 0;

    });
  }

  void _savePrefs() {
    // Save the switch states to SharedPreferences
    _prefs.setBool('switch1Value', switch1Value);
    _prefs.setBool('switch2Value', switch2Value);
    _prefs.setBool('switch3Value', switch3Value);
    _prefs.setBool('switch4Value', switch4Value);
    _prefs.setBool('switch5Value', switch5Value);


    _prefs.setDouble('brightnessValue', brightnessValue);
    _prefs.setDouble('contrastValue', contrastValue);
    _prefs.setDouble('saturationValue', saturationValue);
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topRight,
              child: Opacity(
                opacity: 0.9,
                child: Dialog(
                  insetPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          _buildSlider('Brightness', brightnessValue, 'brightness', (newValue) {
                            setState(() {
                              brightnessValue = newValue;
                            });
                            // Handle brightness value change in real-time
                          }),
                          _buildSlider('Contrast', contrastValue, 'contrast', (newValue) {
                            setState(() {
                              contrastValue = newValue;
                            });
                            // Handle contrast value change in real-time
                          }),
                          _buildSlider('Saturation', saturationValue, 'saturation', (newValue) {
                            setState(() {
                              saturationValue = newValue;
                            });
                            // Handle saturation value change in real-time
                          }),
                          SizedBox(height: 1),
                          _buildSwitch('V-Flip', switch1Value, (newValue) {
                            setState(() {
                              switch1Value = newValue;

                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          _buildSwitch('H-Mirror', switch2Value, (newValue) {
                            setState(() {
                              switch2Value = newValue;

                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          _buildSwitch('Raw GMA', switch3Value, (newValue) {
                            setState(() {
                              switch3Value = newValue;

                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          _buildSwitch('Lens Correction', switch4Value, (newValue) {
                            setState(() {
                              switch4Value = newValue;

                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          // _buildSwitch('Disable Sleep Mode', switch5Value, (newValue) {
                          //   setState(() {
                          //     switch5Value = newValue;
                          //
                          //   });
                          //   _savePrefs(); // Save the switch states when changed
                          // }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void updateStreamUrl() {
    double adjustedBrightness = brightnessValue;
    double adjustedContrast = contrastValue;
    double adjustedSaturation = saturationValue;

    bool adjustedVFlip = switch1Value;
    bool adjustedHMirror = switch2Value;
    bool adjustedRawGMA = switch3Value;
    bool adjustedLensCorrection = switch4Value;

    String urlParameters = '';
    urlParameters += 'brightness=${adjustedBrightness.toStringAsFixed(0)}';
    urlParameters += '&contrast=${adjustedContrast.toStringAsFixed(0)}';
    urlParameters += '&saturation=${adjustedSaturation.toStringAsFixed(0)}';
    urlParameters += '&V-Flip=${adjustedVFlip ? '1' : '0'}';
    urlParameters += '&H-Mirror=${adjustedHMirror ? '1' : '0'}';
    urlParameters += '&Raw=${adjustedRawGMA ? '1' : '0'}';
    urlParameters += '&Lens=${adjustedLensCorrection ? '1' : '0'}';

    setState(() {
      streamUrl = 'http://192.168.185.1:81/?filter=2&$urlParameters';
      print(streamUrl);
      widget.onStreamUrlChanged(streamUrl);
    });
  }



  Widget _buildSlider(String name, double value, String type, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Text(
              '-2',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            Expanded(
              child: Slider(
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    onChanged(newValue);
                  });
                  updateStreamUrl(); // Update the stream URL when the slider value changes
                  _savePrefs(); // Save the slider values when changed
                },
                min: -2.0,
                max: 2.0,
                divisions: 4,

                activeColor: Colors.yellow, // Set the active color to yellow
              ),
            ),
            Text(
              '+2',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitch(String name, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 25,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Switch(
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      onChanged(newValue);
                      updateStreamUrl(); // Call updateStreamUrl to re-render the stream URL
                    });
                    _savePrefs(); // Save the switch states when changed
                  },
                  activeColor: Colors.yellow,
                  hoverColor: Colors.yellow,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }



}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey boundaryKey = GlobalKey();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  late Timer _timer;
  String _currentDate = '';
  String _currentTime = '';
  bool _isRecording = false;
  String _recordingFilePath = '';
  ScreenRecorderController _screenRecorderController = ScreenRecorderController();


  String streamUrl = 'http://192.168.185.1:81/?filter=2';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _getCurrentDateTime();

  }

  @override
  void dispose() {
    _timer.cancel();
    // _videoPlayerController?.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _getCurrentDateTime();
    });
  }

  void _getCurrentDateTime() {
    final now = DateTime.now();
    setState(() {
      _currentDate = _dateFormat.format(now);
      _currentTime = _timeFormat.format(now);
    });
  }

  void captureImage(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
      boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      List<int> pngBytes = byteData!.buffer.asUint8List();

      Directory directory = await getTemporaryDirectory();
      String filePath = '${directory.path}/eLight.png';

      File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final imageSize = Size(image.width.toDouble(), image.height.toDouble());
      canvas.drawImage(image, Offset.zero, Paint());

      final textStyle = ui.TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
      final paragraphStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(_currentDate + '\n' + _currentTime);
      final paragraph = paragraphBuilder.build()
        ..layout(ui.ParagraphConstraints(width: imageSize.width));
      final textOffset = Offset(10, 10);
      canvas.drawParagraph(paragraph, textOffset);

      final modifiedImage = await recorder.endRecording().toImage(
        imageSize.width.toInt(),
        imageSize.height.toInt(),
      );
      ByteData? modifiedByteData = await modifiedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      List<int> modifiedPngBytes = modifiedByteData!.buffer.asUint8List();
      await file.writeAsBytes(modifiedPngBytes);

      final result = await ImageGallerySaver.saveFile(file.path);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });

          return Stack(
            children: [

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: AlertDialog(
                    content: Container(
                      height: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'The captured image has been saved successfully.',
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error capturing and saving image: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });

          return AlertDialog(
            title: Text('Error'),
          );
        },
      );
    }
  }

  void toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;

      if (_isRecording) {
        _startRecording();
      } else {
        _stopRecording();
      }
    });
  }



  Future<void> _startRecording() async {
    // _screenRecorderController.start();
    print("recording start");
  }

  void _stopRecording() {
    // _screenRecorderController.stop();
    print("recording stop");
  }


  void openAdditionalSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdditionalSettingsDialog(
          onStreamUrlChanged: (newStreamUrl) {
            setState(() {
              streamUrl = newStreamUrl;
            });
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          RepaintBoundary(
            key: boundaryKey,
            // child: ColorFiltered(
            //   colorFilter: ColorFilter.matrix(<double>[
            //     0.2989, 0.587, 0.114, 0.0, 0.0, // Red transformation mapped to grayscale
            //     0.2989, 0.587, 0.114, 0.0, 0.0, // Green transformation mapped to grayscale
            //     0.2989, 0.587, 0.114, 0.0, 0.0, // Blue transformation mapped to grayscale
            //     0.0, 0.0, 0.0, 1.0, 0.0, // Alpha transformation
            //   ]),

                child: Mjpeg(
                  isLive: true,
                  stream: streamUrl,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                  timeout: Duration(seconds: 30),
                ),
              ),
            // ),

      Positioned(
        bottom: 10,
        left: 10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                _currentDate,
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                _currentTime,
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 10,
        right: 180,
        child: ElevatedButton(
          onPressed: () {
            captureImage(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 10),
            padding: const EdgeInsets.all(0), // Remove horizontal and vertical padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Icon(Icons.camera_alt, size: 40),
            ),
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 100,
        child: ElevatedButton(
          onPressed: toggleRecording,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRecording ? Colors.red : Colors.white,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 10),
            padding: const EdgeInsets.all(0), // Remove horizontal and vertical padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Icon(Icons.videocam, size: 50),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 10,
        right: 20,
        child: ElevatedButton(
          onPressed: () {
            openAdditionalSettings(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 10),
            padding: const EdgeInsets.all(0), // Remove horizontal and vertical padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Icon(Icons.settings, size: 50),
            ),
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 20,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => jet(title: 'Jet')),
            );
          },
          style: ElevatedButton
            .styleFrom(
        backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontSize: 10),
          padding: const EdgeInsets.all(0), // Remove horizontal and vertical padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: Image.asset(
              'assets/images/B&W.png',
              width: 40,
              height: 40,
            ),
          ),
        ),
      ),
    ),

        ],
    ),
    );
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  // DartVLC.initialize();

  runApp(
    MaterialApp(
      title: 'Camera App',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'HomePage'),
    ),
  );
}
