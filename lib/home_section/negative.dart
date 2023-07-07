import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_application_1/home_section/cividis.dart';

class negative extends StatefulWidget {
  final String title;

  const negative({Key? key, required this.title}) : super(key: key);

  @override
  _negativeState createState() => _negativeState();
}

class _negativeState extends State<negative> {
  GlobalKey boundaryKey = GlobalKey();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  late Timer _timer;
  String _currentDate = '';
  String _currentTime = '';

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
      ..addText(_currentDate + '\n' + _currentTime);
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

  void openAdditionalSettings() {
    // Implement the logic to open the additional settings screen/modal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          RepaintBoundary(
            key: boundaryKey,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                 -1.0,  0.0,  0.0, 0.0, 255.0, // Red transformation
                 0.0, -1.0,  0.0, 0.0, 255.0, // Green transformation
                  0.0,  0.0, -1.0, 0.0, 255.0, // Blue transformation
                  0.0,  0.0,  0.0, 1.0,   0.0, // Alpha transformation
              ]),
              child: Mjpeg(
                isLive: true,
                stream: 'http://192.168.91.1:81/',
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
                timeout: Duration(seconds: 30000),
              ),
            ),
          ),
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
                    style: const TextStyle(fontSize: 20, color: Colors.black , fontWeight:FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    _currentTime,
                    style: const TextStyle(fontSize: 20, color: Colors.black,fontWeight:FontWeight.bold),
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
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
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
                  child: Icon(Icons.camera_alt,size: 45,),
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
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
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
                  openAdditionalSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
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
                      child: Icon(Icons.settings, size: 50,),
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
      MaterialPageRoute(builder: (context) => const cividis(title: 'cividis')),
    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
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
                child: Image.asset(
                  'assets/images/negetive.png',
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
      home: negative(title: 'negative'),
    ),
  );
}
