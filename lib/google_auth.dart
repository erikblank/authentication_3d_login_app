import 'dart:async';
import 'package:authentication_3d_login_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class GoogleAuth extends StatefulWidget {
  GoogleAuth({
    Key? key,
  }) : super(key: key);

  @override
  _GoogleAuth createState() => _GoogleAuth();
}

class _GoogleAuth extends State<GoogleAuth> with TickerProviderStateMixin {
  late Future<Map<String, dynamic>> _googleAuth;
  late Timer timer;
  int ticInSec = 1;

  @override
  void initState() {
    super.initState();
    _googleAuth = AuthService.getGoogleCode();
    setTimer();
  }

  void setTimer() {
    timer = Timer.periodic(Duration(seconds: ticInSec), (timer) async {
      setState(() {
        _googleAuth = AuthService.getGoogleCode();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your authentication code:',
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: _googleAuth,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${snapshot.data!["code"]}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              value: snapshot.data!["time"] / 30000,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
