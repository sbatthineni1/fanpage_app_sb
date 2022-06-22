import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app_sb/databaseservices.dart';
import 'package:fanpage_app_sb/googleauth.dart';
import 'package:intl/intl.dart';
import 'package:fanpage_app_sb/login.dart';
import 'package:fanpage_app_sb/post.dart';
import 'package:fanpage_app_sb/postform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _form = GlobalKey<FormState>();
  TextEditingController _message = TextEditingController();
  bool loading = false;
  bool admin = false;
  String name = '';
  var dateTimeFormat = DateFormat("M/d/y hh:mm");
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy('createdAt')
      .snapshots();

  @override
  void initState() {
    super.initState();
    setAdmin();
  }

  void setAdmin() async {
    db
        .collection("users")
        .doc(auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot['role'] == 'admin') {
        setState(() {
          admin = true;
        });
      } else {
        setState(() {
          admin = false;
        });
      }
    });
    //  setState(() {
    //     admin = (user.type == "admin");
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, actions: [
        IconButton(
          onPressed: () async {
            signoutPopup(context);
          },
          icon: const Icon(Icons.logout),
        ),
      ]),
      floatingActionButton: admin
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => addpost(context));
                //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>AddPost()));
              },
              backgroundColor: Colors.amber,
              child: const Icon(Icons.add),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  Row(children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, bottom: 3.0, right: 20.0),
                          child: Text(
                            dateTimeFormat
                                .format(data['createdAt'].toDate())
                                .toString(),
                            textAlign: TextAlign.right,
                          ),
                        )),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      title: Text(
                        data['message'],
                        style: const TextStyle(color: Colors.black87),
                        textAlign: TextAlign.justify,
                      ),
                      tileColor: Colors.amber,
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // void logout() async {
  //   await auth.signOut();
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (BuildContext context) => const Loginpage()),
  //     ModalRoute.withName('/'),
  //   );
  // }

  void signoutPopup(context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('Are you sure to logout'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<GoogleSignInClass>(context, listen: false)
                  .logout();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const Loginpage()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget addpost(context) {
    return Dialog(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              controller: _message,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add your message here',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
            )),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    addMessage(context, _message.text);
                    Navigator.of(context).pop();
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Home()));
                  });
                },
                child: const Text("Post"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // addMessage(context, _message.text);
                    Navigator.of(context).pop();
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Home()));
                  });
                },
                child: const Text("cancel"),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  void addMessage(BuildContext context, String message) {
    var userName = db.collection('users').doc().get();
    try {
      db.collection("messages").add(
          {"message": message, "createdBy": name, "createdAt": DateTime.now()});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
