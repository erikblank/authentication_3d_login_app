// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<Widget> imageList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    // Next, initialize the controller. This returns a Future.
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  void authenticate() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        });
    new Timer(const Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });

    print("authentication done");
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Scaffold(
      appBar: AppBar(title: const Text('3D Authentication')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      CameraPreview(_controller),
                      SizedBox(
                        height: 70,
                        child: Row(
                          children: imageList,
                        ),
                      ),
                    ],
                  );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            if (imageList.length < 3) {
              setState(() {
                _isLoading = true;
              });
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await _controller.takePicture();

              setState(() {
                imageList.add(Padding(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.fitWidth,
                      width: 60,
                      height: 60,
                    )));
                _isLoading = false;
              });
            } else {
              // If the picture was taken, display it on a new screen.
              // await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => DisplayPictureScreen(
              //       // Pass the automatically generated path to
              //       // the DisplayPictureScreen widget.
              //       imagePath: image.path,
              //     ),
              //   ),
              // );
              authenticate();
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child:
            imageList.length < 3 ? Icon(Icons.camera_alt) : Icon(Icons.check),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
