import 'package:firebase_auth/firebase_auth.dart';

class SignUp {
  final _auth = FirebaseAuth.instance;
  User _newUser;

  void verifyEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      _newUser = user;
    } else
      return;
    try {
      await _newUser.sendEmailVerification();
    } catch (err) {
      throw err;
    }
  }
}
