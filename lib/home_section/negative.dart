// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_section/jet.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_application_1/home_section/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AdditionalSettingsDialog extends StatefulWidget {
  final ValueChanged<String> onStreamUrlChanged;

  const AdditionalSettingsDialog({Key? key, required this.onStreamUrlChanged})
      : super(key: key);

  @override
  AdditionalSettingsDialogState createState() =>
      AdditionalSettingsDialogState();
}

class AdditionalSettingsDialogState extends State<AdditionalSettingsDialog> {
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
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
                    height: MediaQuery.of(context).size.height * 1,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          _buildSlider(
                              'Brightness', brightnessValue, 'brightness',
                              (newValue) {
                            setState(() {
                              brightnessValue = newValue;
                            });
                            // Handle brightness value change in real-time
                          }),
                          _buildSlider('Contrast', contrastValue, 'contrast',
                              (newValue) {
                            setState(() {
                              contrastValue = newValue;
                            });
                            // Handle contrast value change in real-time
                          }),
                          _buildSlider(
                              'Saturation', saturationValue, 'saturation',
                              (newValue) {
                            setState(() {
                              saturationValue = newValue;
                            });
                            // Handle saturation value change in real-time
                          }),
                          const SizedBox(height: 1),
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
                          _buildSwitch('Lens Correction', switch4Value,
                              (newValue) {
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
    urlParameters += '&vFlip=${adjustedVFlip ? '1' : '0'}';
    urlParameters += '&hMirror=${adjustedHMirror ? '1' : '0'}';
    urlParameters += '&raw=${adjustedRawGMA ? '1' : '0'}';
    urlParameters += '&lens=${adjustedLensCorrection ? '1' : '0'}';

    setState(() {
      streamUrl = 'http://192.168.108.1:81/?filter=3&$urlParameters';
      print(streamUrl);
      widget.onStreamUrlChanged(streamUrl);
    });
  }

  Widget _buildSlider(
      String name, double value, String type, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            const Text(
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
            const Text(
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
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
        const SizedBox(height: 10),
      ],
    );
  }
}

class Negative extends StatefulWidget {
  final String title;

  const Negative({Key? key, required this.title}) : super(key: key);

  @override
  NegativeState createState() => NegativeState();
}

class NegativeState extends State<Negative> {
  GlobalKey boundaryKey = GlobalKey();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  late Timer _timer;
  String _currentDate = '';
  String _currentTime = '';

  String streamUrl = 'http://192.168.108.1:81/?filter=3';
  @override
  void initState() {
    super.initState();
    _startTimer();
    _getCurrentDateTime(); // Initialize the date and time immediately
  }

  @override
  void dispose() {
    _timer.cancel();
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

      const logoImageProvider = AssetImage('assets/images/Logo.png');
      final logoImageStream = logoImageProvider.resolve(ImageConfiguration.empty);
      final logoImageCompleter = Completer<ui.Image>();
      final logoImageListener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
        final ui.Image image = info.image;
        logoImageCompleter.complete(image);
      });
      logoImageStream.addListener(logoImageListener);
      final logoImage = await logoImageCompleter.future;
      logoImageStream.removeListener(logoImageListener);

      const logoSize = Size(250, 150); // Adjust the size of the logo as needed

      // Calculate the logo offset to place it at the top-right corner
      canvas.drawImageRect(
          logoImage,
          Rect.fromLTWH(0, 0, logoImage.width.toDouble(), logoImage.height.toDouble()),
          Offset(imageSize.width - logoSize.width, -35) & logoSize,
          Paint());

      final textStyle = ui.TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
      final paragraphStyle = ui.ParagraphStyle(textAlign: TextAlign.left);
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(_currentDate)
        ..addText(' ')
        ..addText(_currentTime);
      final paragraph = paragraphBuilder.build()
        ..layout(ui.ParagraphConstraints(width: imageSize.width));

      // Calculate the text offset to place it at the bottom-left corner
      final textOffset = Offset(10, imageSize.height - paragraph.height - 10);

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

      print(result);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });

          return const Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AlertDialog(
                  content: SizedBox(
                    height: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Image Saved to gallery',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });

          return const AlertDialog(
            title: Text('Error'),
          );
        },
      );
    }
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
            child: Mjpeg(
              isLive: true,
              stream: streamUrl,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              timeout: const Duration(seconds: 30000),
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
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    _currentTime,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 100,
            child: ElevatedButton(
              onPressed: () {
                captureImage(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 10),
                padding: const EdgeInsets.all(
                    0), // Remove horizontal and vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 45,
                  ),
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
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 10),
                padding: const EdgeInsets.all(
                    0), // Remove horizontal and vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Icon(
                    Icons.settings,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          // ),
          Positioned(
            top: 10,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: 'HomePage')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 10),
                padding: const EdgeInsets.all(
                    0), // Remove horizontal and vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Image.asset(
                    'assets/images/negative.png',
                    width: 40, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
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
  runApp(
    MaterialApp(
      title: 'Camera App',
      theme: ThemeData.dark(),
      home: const Negative(title: 'negative'),
    ),
  );
}
