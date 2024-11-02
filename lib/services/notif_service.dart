import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_management/widgets/dialog.dart';

class NotifService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//tao thong bao
  Future<void> addNotification(BuildContext context, String title,
      String content, String datetime) async {
    try {
      await _firestore
          .collection("notif")
          .doc(datetime)
          .set({'title': title, 'content': content, 'datetime': datetime});
      await CustomDialogUtil.showDialogNotification(context,
          content: "tao thong bao thanh cong");
    } catch (e) {
      print(e);
      await CustomDialogUtil.showDialogNotification(context,
          content: "tao thong bao that bai");
      return null;
    }
  }

  //end thong bao

  //load data
  Future<List<Map<String, dynamic>>> loadAllNotifData(
      BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('notif').get();
      List<Map<String, dynamic>> notifData = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
      return notifData;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra'),
        ),
      );
      return [];
    }
  }
}
