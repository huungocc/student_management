import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';

class AccountService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Load thông tin user theo role
  Future<List<Map<String, dynamic>>> loadAllUserDataByRole(
      BuildContext context, String role) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(role).get();

      List<Map<String, dynamic>> usersData = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      return usersData;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra'),
        ),
      );
      return [];
    }
  }

  //Load thông tin của user đang đăng nhập
  Future<Map<String, dynamic>?> loadUserData(BuildContext context, String role, String? email) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection(role).doc(email).get();
      Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;
      userData['id'] = documentSnapshot.id;
      return userData;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra khi tải thông tin'),
        ),
      );
      return null;
    }
  }

  //Sửa thông tin user
  Future<void> editUserInfo(
      BuildContext context,
      String role,
      String email,
      String name,
      String gender,
      String dateOfBirth,
      String country,
      String address,
      String phone) async {
    try {
      await _firestore.collection(role).doc(email).set({
        'name': name,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'country': country,
        'address': address,
        'phone': phone
      }, SetOptions(merge: true));

      await CustomDialogUtil.showDialogNotification(
        context,
        content: 'Sửa thông tin thành công',
      );
    } catch (e) {
      print(e);
      await CustomDialogUtil.showDialogNotification(
        context,
        content: 'Sửa thông tin thất bại',
      );
      return null;
    }
  }

  // Đổi mật khẩu user
  Future<void> changeUserPassword(
      BuildContext context,
      String email,
      String currentPassword,
      String newPassword,
      ) async {
    try {
      User? user = _auth.currentUser;

      if (user != null && user.email == email) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);

        await CustomDialogUtil.showDialogNotification(
          context,
          content: 'Đổi mật khẩu thành công',
        );
      } else {
        await CustomDialogUtil.showDialogNotification(
          context,
          content: 'Không thể xác thực người dùng',
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Đổi mật khẩu thất bại';
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Mật khẩu hiện tại không đúng';
          break;
        case 'requires-recent-login':
          errorMessage = 'Vui lòng đăng nhập lại để thực hiện thao tác này';
          break;
      }
      await CustomDialogUtil.showDialogNotification(
        context,
        content: errorMessage
      );
    } catch (e) {
      print(e);
      await CustomDialogUtil.showDialogNotification(
        context,
        content: 'Đổi mật khẩu thất bại',
      );
    }
  }

  // Xóa user


  //reset mật khẩu

}
