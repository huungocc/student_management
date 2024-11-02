import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String ROLE_KEY = 'user_role';

  // Đăng nhập với email và mật khẩu
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String? role = await getUserRole(email);
    if (role != null) {
      await saveUserRole(role);
    }

    return userCredential.user;
  }

  Future<String?> getUserRole(String email) async {
    try {
      List<String> collections = ['admin', 'teacher', 'student'];

      for (String collection in collections) {
        DocumentSnapshot doc = await _firestore.collection(collection).doc(email).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['role'] as String;
        }
      }
      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  // Lưu role vào SharedPreferences
  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ROLE_KEY, role);
  }

  // Lấy role từ SharedPreferences
  Future<String?> getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ROLE_KEY);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ROLE_KEY);
    await _auth.signOut();
  }

  // Kiểm tra quyền truy cập
  Future<bool> hasPermission(List<String> allowedRoles) async {
    String? currentRole = await getCurrentUserRole();
    return currentRole != null && allowedRoles.contains(currentRole);
  }
}
