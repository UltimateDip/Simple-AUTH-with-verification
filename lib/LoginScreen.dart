import 'package:auth_testing/ContentScreen.dart';
import 'package:auth_testing/SignUpVerification.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthMode { SignUp, Login }

class LoginScreen extends StatefulWidget {
  static const id = 'log_in_screen';

  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _auth = FirebaseAuth.instance;
  bool reSend = false;

  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      //invalid
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    // print(_authData['email']);
    // print(_authData['password']);

    if (_authMode == AuthMode.Login) {
      try {
        final newUser = await _auth.signInWithEmailAndPassword(
            email: _authData['email'], password: _authData['password']);

        if (newUser != null && _auth.currentUser.emailVerified)
          Navigator.pushNamed(context, ContentScreen.id);
      } catch (err) {
        throw err;
      }
    } else if (_authMode == AuthMode.SignUp) {
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: _authData['email'], password: _authData['password']);

        if (newUser != null) {
          SignUp().verifyEmail();
          setState(() {
            reSend = true;
          });
        }
      } catch (err) {
        throw err;
      }
    } else
      return;

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        reSend=false;
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 5, right: 10),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,

                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid E-Mail';
                          }
                        },

                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Password is too short';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                    ),
                    if (_authMode == AuthMode.SignUp)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff000000),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          obscureText: true,
                          validator: _authMode == AuthMode.SignUp
                              // ignore: missing_return
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Password do not match';
                                  }
                                }
                              : null,
                        ),
                      ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    if (_isLoading) CircularProgressIndicator(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    //login button
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(10.0),
                        child: MaterialButton(
                          onPressed: _submit,
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(_authMode == AuthMode.Login
                              ? 'LOGIN '
                              : 'SIGN UP '),
                        ),
                      ),
                    ),
                    //sign up <-> login exchange button
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 20, right: 10),
                      child: Material(
                        elevation: 5.0,
                        color: Color(0xff09e0d9),
                        borderRadius: BorderRadius.circular(10.0),
                        child: MaterialButton(
                          onPressed: _switchAuthMode,
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            '${_authMode == AuthMode.Login ? 'SIGN UP ' : 'LOGIN '}INSTEAD',
                          ),
                        ),
                      ),
                    ),
                    if (reSend)
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'A verification link has sent to your email.\nPlease verify your email.' +
                                  '\n\nIf not received please click RESEND',
                              style: TextStyle(color: Colors.black38),
                            ),
                          ),
                          FlatButton(
                            child: Text(
                              "RESEND",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () async {
                              try {
                                // print('In resend');
                                await _auth.currentUser.sendEmailVerification();//TODO
                              } catch (err) {
                                throw err;
                              }
                              setState(() {
                                reSend = true;
                              });
                            },
                          )
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
