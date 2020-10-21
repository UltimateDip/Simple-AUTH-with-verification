import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentScreen extends StatefulWidget {
  static const id = 'content_screen';

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final _auth = FirebaseAuth.instance;

  User newUser;
  String status;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;

    if (user != null) {
      newUser = user;
      status = newUser.emailVerified ? 'email verified' : 'email not verified';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: deviceSize.height / 10,
                color: Colors.white,
                child: Center(
                  child: Text(
                    (newUser!=null && newUser.emailVerified)
                        ? 'Email : ' +
                        newUser.email +
                        '\nStatus : $status'
                        : 'data not available',
                    style: TextStyle(
                        color: Colors.black87, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                height: deviceSize.height / 20,
                minWidth: deviceSize.height * 0.15,
                color: Colors.purple[300],
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                },
                child: Text("Log out"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
