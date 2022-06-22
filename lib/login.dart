import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app_sb/Registration.dart';
import 'package:fanpage_app_sb/googleauth.dart';
import 'package:fanpage_app_sb/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Shilpa FanPage"),
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: (Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.camera,
                    size: 50.0,
                  )),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter emailID";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'What do people call you?',
                  labelText: 'User Email ID*',
                ),
                controller: _username,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter password";
                  }
                  // else {
                  //   return null;
                  // }
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.password_sharp),
                  hintText: 'give your password',
                  labelText: 'password',
                ),
                controller: _password,
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // _loading = true;
                      _form.currentState!.validate() ? logIn(context) : null;
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.amber),
                  child: const Text("Login"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // _loading = true;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Registration()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.amber),
                  child: const Text("Register"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                  onPressed: () {
                    final provider =
                        Provider.of<GoogleSignInClass>(context, listen: false);
                    provider.googleLogin(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.amber),
                  child: const Text("Signin with Google"),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  void logIn(BuildContext context) async {
    print("**********************Shilpa****************");
    if (_form.currentState!.validate()) {
      print("**********************validate****************");
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _username.text, password: _password.text);
        User? user = userCredential.user;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Homepage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == "Wrong Password" || e.code == "no email") {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Incorrect email/Password")));
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
