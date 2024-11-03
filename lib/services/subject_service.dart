import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo môn học
  Future<void> addSubject(String title, String category, String credit,
      String description, String totalDays) async {
    try {
      await _firestore
          .collection("subject")
          .doc(title)
          .set({'title': title, 'category': category, 'credit': credit, 'description': description, 'totalDays': totalDays});
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Load data subject
  Future<List<Map<String, dynamic>>> loadAllSubjectData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('subject').get();
      List<Map<String, dynamic>> subjectData = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
      return subjectData;
    } catch (e) {
      return [];
    }
  }

  // Xóa môn học
  Future<void> deleteSubject(String title) async {
    try {
      await _firestore
          .collection("subject")
          .doc(title)
          .delete();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
