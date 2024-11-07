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

  //xóa môn học
  Future<void> deleteSubject(String title) async {
    try {
      QuerySnapshot classSnapshot = await _firestore
          .collection("class")
          .where('subject', isEqualTo: title)
          .get();

      for (DocumentSnapshot classDoc in classSnapshot.docs) {
        QuerySnapshot studentsSnapshot = await classDoc.reference.collection("students").get();
        for (DocumentSnapshot studentDoc in studentsSnapshot.docs) {
          await studentDoc.reference.delete();
        }

        await classDoc.reference.delete();
      }

      await _firestore.collection("subject").doc(title).delete();
    } catch (e) {
      print(e);
    }
  }


  // Lấy danh sách tiêu đề các môn học
  Future<List<String>> loadAllSubjectTitles() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('subject').get();
      List<String> subjectTitles = querySnapshot.docs.map((doc) {
        return doc['title'] as String;
      }).toList();
      return subjectTitles;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
