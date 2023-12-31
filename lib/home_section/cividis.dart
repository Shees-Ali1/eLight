import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/home_section/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdditionalSettingsDialog extends StatefulWidget {
  final ValueChanged<String> onStreamUrlChanged;

  const AdditionalSettingsDialog({Key? key, required this.onStreamUrlChanged}) : super(key: key);

  @override
  _AdditionalSettingsDialogState createState() => _AdditionalSettingsDialogState();
}

class _AdditionalSettingsDialogState extends State<AdditionalSettingsDialog> {


  late SharedPreferences _prefs;
  double brightnessValue = 0.0;
  double contrastValue = 0.0;
  double saturationValue = 0.0;



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
  }

  void _savePrefs() {
    // Save the switch states to SharedPreferences
    _prefs.setBool('switch1Value', switch1Value);
    _prefs.setBool('switch2Value', switch2Value);
    _prefs.setBool('switch3Value', switch3Value);
    _prefs.setBool('switch4Value', switch4Value);
    _prefs.setBool('switch5Value', switch5Value);
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
                          _buildSwitch('ChangeFilter', switch1Value, (newValue) {
                            setState(() {
                              switch1Value = newValue;
                              if (newValue) {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/');
                              } else {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=2');
                              }
                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          _buildSwitch('H-Mirror', switch2Value, (newValue) {
                            setState(() {
                              switch2Value = newValue;
                              if (newValue) {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=1');
                              } else {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=2');
                              }
                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          _buildSwitch('Raw GMA', switch3Value, (newValue) {
                            setState(() {
                              switch3Value = newValue;
                              if (newValue) {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=1');
                              } else {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=2');
                              }
                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          _buildSwitch('Lens Correction', switch4Value, (newValue) {
                            setState(() {
                              switch4Value = newValue;
                              if (newValue) {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=1');
                              } else {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=2');
                              }
                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
                          _buildSwitch('Disable Sleep Mode', switch5Value, (newValue) {
                            setState(() {
                              switch5Value = newValue;
                              if (newValue) {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=1');
                              } else {
                                widget.onStreamUrlChanged('http://192.168.91.1:81/?filter=2');
                              }
                            });
                            _savePrefs(); // Save the switch states when changed
                          }),
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
                onChanged: onChanged,
                min: -2.0,
                max: 2.0,
                divisions: 40,
                label: value.toString(),
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


// ignore: camel_case_types
class cividis extends StatefulWidget {
  final String title;

  const cividis({Key? key, required this.title}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _cividisState createState() => _cividisState();
}

// ignore: camel_case_types
class _cividisState extends State<cividis> {
  GlobalKey boundaryKey = GlobalKey();
 final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  late Timer _timer;
  String _currentDate = '';
  String _currentTime = '';

  String streamUrl = 'http://192.168.91.1:81/?filter=2';

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

    // Get the directory for storing the image
    Directory directory = await getTemporaryDirectory();
    String filePath = '${directory.path}/eLight.png';

    // Save the image to the gallery
    File file = File(filePath);
    await file.writeAsBytes(pngBytes);

    // Create a new image with the date and time text
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    canvas.drawImage(image, Offset.zero, Paint());

    // Add the date and time text
    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    final paragraphStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('$_currentDate\n$_currentTime');
    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: imageSize.width));
    final textOffset = Offset(10, 10); // Adjust the position of the text as needed
    canvas.drawParagraph(paragraph, textOffset);

    // Save the modified image with the text
    final modifiedImage = await recorder.endRecording().toImage(
      imageSize.width.toInt(),
      imageSize.height.toInt(),
    );
    ByteData? modifiedByteData = await modifiedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    List<int> modifiedPngBytes = modifiedByteData!.buffer.asUint8List();
    await file.writeAsBytes(modifiedPngBytes);

    // Save the modified image to the gallery
    final result = await ImageGallerySaver.saveFile(file.path);

    // Show a small alert when the image is saved
    showDialog(
  context: context,
  builder: (BuildContext context) {
    // Close the dialog after 1 second
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });

    return Stack(
          children: [
           Positioned(
  bottom: 0, // Adjust the top position as needed
   left: 0,
  right: 0,
  child: Center(
    child: AlertDialog(
      // title: Text('Image Saved'),
      content: Container(
        height: 20, // Set the desired height of the content area
       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Adjust the vertical alignment
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
    // Handle any error that occurred during the capture process
    print('Error capturing and saving image: $error');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Close the dialog after 1 second
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });

        return AlertDialog(
          title: Text('Error'),
          // content: Text('An error occurred while capturing and saving the image.'),
        );
      },
    );
  }
}

  void recordVideo() {
    // Implement the logic to start/stop recording a video
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
            //   colorFilter: const ColorFilter.matrix(<double>[
            //      0.0, 0.0, 1.0, 0.0, 0.0,
            //     0.0, 1.0, 1.0, 0.0, 0.0,
            //     1.0, 1.0, 0.0, 0.0, 0.0,
            //     0.0, 0.0, 0.0, 1.0, 0.0,
            //   ]),
              child: Mjpeg(
                isLive: true,
                stream: streamUrl,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
                timeout: Duration(seconds: 30000),
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
                    style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    _currentTime,
                    style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),
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
                  child: Icon(Icons.camera_alt,size: 40,),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 100,
            child: ElevatedButton(
              onPressed: recordVideo,
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
                  child: Icon(Icons.videocam,size: 50,),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 20,
            // child: PopupMenuButton<String>(
            //   onSelected: (value) {
            //     // Handle selected item
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return <PopupMenuEntry<String>>[
            //       PopupMenuItem<String>(
            //         value: 'Settings',
            //         child: Text('Settings'),
            //       ),
            //     ];
            //   },
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
                    child: Icon(Icons.settings,size: 50,),
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
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'HomePage')),
    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 10),
                padding: const EdgeInsets.all(0), // Remove horizontal and vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child:  SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child:Image.asset('assets/images/jet.png'
                  ,
                  width:40,
                  height:40,) ,
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
      home: cividis(title: 'cividis'),
    ),
  );
}
