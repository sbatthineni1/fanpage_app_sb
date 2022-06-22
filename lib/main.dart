import 'package:fanpage_app_sb/googleauth.dart';
import 'package:fanpage_app_sb/welcomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCSqLJbrkdrG3pSYv6D7mz5PPSGHTPn3GQ",
          appId: "1:210650124694:android:c9ede0bef6ecfd9d5d4db7",
          messagingSenderId: "210650124694",
          projectId: "fanpageapp-24203"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInClass(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shilpa\'s Fanpage',
        home: const Splashscreen(),
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Shilpa\'s Fanpage',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //
    // );
  }
}
