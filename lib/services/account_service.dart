import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Load danh sách email theo role
  Future<List<Map<String, dynamic>>> loadAllUserDataByRole(BuildContext context, String role) async {
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

  //Xóa user

  //Đặt lại mk user (Giảng viên, Sinh viên)
}