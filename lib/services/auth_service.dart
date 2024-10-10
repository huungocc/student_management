import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập với email và mật khẩu
  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.signInFailed + ': $e'),
        ),
      );
      throw e;
    }
  }

  // Đăng ký tài khoản với email, mật khẩu và role
  Future<User?> signUpWithEmailAndPassword(BuildContext context, String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thông tin người dùng vào Firestore với role
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'role': role,  // role: 'admin', 'student', 'teacher'
      });

      return userCredential.user;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.signUpFailed + ': $e'),
        ),
      );
      return null;
    }
  }

  // Đăng xuất
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.signOutFailed + ': $e'),
        ),
      );
      throw e;
    }
  }
}
