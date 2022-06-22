import 'package:fanpage_app_sb/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final Future<FirebaseApp> _initializeApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 201, 117),
      body: FutureBuilder(
          initialData: _initializeApp,
          future: Future.delayed(Duration(seconds: 5)),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text("error"),
                ),
                color: Colors.blue,
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Loginpage();
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera,
                          size: 50.0,
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Shilpa's fanpage app",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
