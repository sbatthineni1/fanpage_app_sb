import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app_sb/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _form = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  registerusingid() async {
    UserCredential userCredential;
    User user;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _username.text, password: _password.text);
      user = userCredential.user!;
      FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        'userid': user.uid,
        'username': _username.text,
        'role': 'user',
        'createdAt': DateTime.now(),
      }).then((value) => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const Loginpage())));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
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
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.password_rounded),
                  hintText: 'give your password',
                  labelText: 'password',
                ),
                controller: _password,
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Container(
                height: 50,
                width: 200,
                color: Colors.blue,
                child: ElevatedButton(
                    onPressed: () async {
                      _form.currentState!.validate() ? registerusingid() : null;
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    child: Text("Register")),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
