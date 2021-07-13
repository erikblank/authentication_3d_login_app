import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:authentication_3d_login_app/google_auth.dart';
import 'package:authentication_3d_login_app/auth_3d.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({Key? key, required this.camera}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginOptions(
        title: 'Choose authentication option',
        camera: camera,
      ),
    );
  }
}

class LoginOptions extends StatelessWidget {
  LoginOptions({Key? key, required this.title, required this.camera})
      : super(key: key);
  final CameraDescription camera;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoogleAuth()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Google Auth"),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Auth3d(camera: camera)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("3D Auth"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
