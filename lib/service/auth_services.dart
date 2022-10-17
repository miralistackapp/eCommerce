import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning/app/widget/app_toast.dart';
import 'package:learning/main.dart';

class AuthServices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();

  //     ======================= Google Sign In =======================     //
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      await googleSignIn.signOut();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential;
      }
      return null;
    } on PlatformException catch (e) {
      logs('Catch error in signInWithGoogle --> ${e.message}');
      e.message!.showToast(isError: true);
      return null;
    }
  }

  //     ======================= SignUp =======================     //
  static Future<UserCredential?> createUser(String email, String password) async {
    try {
      UserCredential authUser = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      logs('User data : ${authUser.user}');
      return authUser;
    } on FirebaseAuthException catch (e) {
      logs('Catch error in Create User --> ${e.message}');
      e.message!.showToast(isError: true);
      return null;
    }
  }

  //     ======================= SignIn =======================     //
  static Future<UserCredential?> verifyUser(String email, String password) async {
    try {
      UserCredential authUser = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      logs('User data : ${authUser.user}');
      return authUser;
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User --> ${e.message}');
      e.message!.split('. ')[0].trim().toString().showToast(isError: true);
      return null;
    }
  }

  //     ======================= SignOut =======================     //
  static Future<void> userSignOut(BuildContext context) async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
