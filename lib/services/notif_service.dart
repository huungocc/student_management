import 'package:cloud_firestore/cloud_firestore.dart';

class NotifService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //tao thong bao
  Future<void> addNotification(String title,
      String content, String datetime) async {
    try {
      QuerySnapshot existingNotif = await _firestore
          .collection("notif")
          .where('title', isEqualTo: title)
          .get();

      if (existingNotif.docs.isNotEmpty) {
        throw Exception("Thông báo với tiêu đề này đã tồn tại");
      }

      await _firestore
          .collection("notif")
          .doc(datetime)
          .set({'title': title, 'content': content, 'datetime': datetime});
    } catch (e) {
      print(e);
      throw e;
    }
  }

  //edit
  Future<void> editNotification(String title,
      String content, String datetime) async {
    try {
      await _firestore
          .collection("notif")
          .doc(datetime)
          .set({'title': title, 'content': content, 'datetime': datetime});
    } catch (e) {
      print(e);
    }
  }

  //load data theo thứ tự mới nhất trước
  Future<List<Map<String, dynamic>>> loadAllNotifData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('notif')
          .orderBy('datetime', descending: true)
          .get();

      List<Map<String, dynamic>> notifData = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      return notifData;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //xoa thong bao
  Future<void> deleteNotification(String datetime) async {
    try {
      await _firestore.collection("notif").doc(datetime).delete();
    } catch (e) {
      print(e);
    }
  }

  // load title và datetime của thông báo mới nhất
  Future<Map<String, dynamic>?> loadLatestNotif() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('notif')
          .orderBy('datetime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'title': data['title'],
          'datetime': data['datetime'],
        };
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}