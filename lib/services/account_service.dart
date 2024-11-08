import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Load thông tin user theo role
  Future<List<Map<String, dynamic>>> loadAllUserDataByRole(String role) async {
    QuerySnapshot querySnapshot = await _firestore.collection(role).get();

    List<Map<String, dynamic>> usersData = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();

    return usersData;
  }

  //Load thông tin của user đang đăng nhập
  Future<Map<String, dynamic>?> loadUserData(String role, String? email) async {
    DocumentSnapshot documentSnapshot = await _firestore.collection(role).doc(email).get();
    Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;
    userData['id'] = documentSnapshot.id;
    return userData;
  }

  //Sửa thông tin user
  Future<void> editUserInfo(
      String role,
      String email,
      String name,
      String gender,
      String dateOfBirth,
      String country,
      String address,
      String phone) async {

    await _firestore.collection(role).doc(email).set({
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'address': address,
      'phone': phone
    }, SetOptions(merge: true));
  }

  // Đổi mật khẩu user
  Future<void> changeUserPassword(
      String email,
      String currentPassword,
      String newPassword,
      ) async {
    User? user = _auth.currentUser;

    if (user != null && user.email == email) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
    }
  }
}
