import 'package:auth_testing/ContentScreen.dart';
import 'package:auth_testing/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  //Problem : Firebase initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp() ;


  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: LoginScreen.id,
      title: "auth tester",
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        ContentScreen.id: (context) => ContentScreen(),
      },
    );
  }
}
