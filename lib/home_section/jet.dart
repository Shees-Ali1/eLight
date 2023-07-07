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
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_application_1/home_section/negative.dart';




class jet extends StatefulWidget {
  final String title;

  const jet({Key? key, required this.title}) : super(key: key);

  @override
  _jetState createState() => _jetState();
}


class GrayScaleFalseColorsFilter extends ColorFilter {
   GrayScaleFalseColorsFilter() : super.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0.0, 0.0, // Red
        0.2126, 0.7152, 0.0722, 0.0, 0.0, // Green
        0.2126, 0.7152, 0.0722, 0.0, 0.0, // Blue
        0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
      ]);

  
  // ColorFilter? scale(double factor) {
  //   return GrayScaleFalseColorsFilter();
  // }


  Color? filterColor(Color color) {
    final double r = color.red / 255.0;
    final double g = color.green / 255.0;
    final double b = color.blue / 255.0;
    final double a = color.alpha / 255.0;

    final double grayScale = (r + g + b) / 3.0;
    final Color falseColor = getColorFromFalseColors(grayScale);

    return Color.fromRGBO(
      falseColor.red,
      falseColor.green,
      falseColor.blue,
      a,
    );
  }

 Color getColorFromFalseColors(double value) {
  // Define the false colors mapping
  final falseColors = {
    0.0: Colors.red,
    0.25: Colors.yellow,
    0.5: Colors.green,
    0.75: Colors.blue,
    1.0: Colors.purple,
  };

  // Find the nearest false color for the given value
  final sortedKeys = falseColors.keys.toList()..sort();
  for (int i = 0; i < sortedKeys.length - 1; i++) {
    final start = sortedKeys[i];
    final end = sortedKeys[i + 1];
    if (value >= start && value <= end) {
      final startColor = falseColors[start]!;
      final endColor = falseColors[end]!;
      final ratio = (value - start) / (end - start);
      return Color.lerp(startColor, endColor, ratio)!;
    }
  }

  // Return the last defined false color if the value is outside the defined range
  return falseColors[sortedKeys.last]!;
}
 }


// class GrayScaleFalseColorsFilter extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ColorFiltered(
//       colorFilter: ColorFilter.matrix(<double>[
//         0.2126, 0.7152, 0.0722, 0, 0, // Red
//         0.2126, 0.7152, 0.0722, 0, 0, // Green
//         0.2126, 0.7152, 0.0722, 0, 0, // Blue
//         0, 0, 0, 1, 0, // Alpha
//       ]),
//       child: ColorFiltered(
//         colorFilter: ColorFilter.matrix(<double>[
//           0, 1, 0, 0, 0, // Red
//           0, 0, 1, 0, 0, // Green
//           1, 0, 0, 0, 0, // Blue
//           0, 0, 0, 1, 0, // Alpha
//         ]),
//         child: Image.asset('path/to/image.png'),
//       ),
//     );
//   }
// }





class _jetState extends State<jet> {
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
            
            // child: ColorFiltered(
            //   colorFilter: 
            //   // GrayScaleFalseColorsFilter(),
            //   const ColorFilter.matrix(<double>[
            //    0.0, 0.0, 1.0, 0.0, 0.0,    // Red transformation mapped to blue hue
            //     0.0, 1.0, 0.0, 0.0, 0.0,    // Green transformation mapped to red hue
            //     1.0, 0.0, 0.0, 0.0, 0.0,    // Blue transformation mapped to green hue
            //     0.0, 0.0, 0.0, 1.0, 0.0,    // Alpha transformation
            //   ]),
              child: Mjpeg(
                isLive: true,
                stream: 'http://192.168.91.1:81/?filter=1',
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
                  openAdditionalSettings();
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
      MaterialPageRoute(builder: (context) => negative(title: 'negative')),
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
      home: jet(title: 'Jet'),
    ),
  );
}
