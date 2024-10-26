import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập với email và mật khẩu
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Đăng ký tài khoản với email, mật khẩu và role
  Future<User?> signUpWithEmailAndPassword(String email, String password, String role, String userID) async {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Lưu thông tin người dùng vào Firestore với role
      await _firestore.collection(role).doc(email).set({
        'email': email,
        'role': role,
        'userID': userID
      });
      return userCredential.user;
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
