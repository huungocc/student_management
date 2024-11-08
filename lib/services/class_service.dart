import 'package:cloud_firestore/cloud_firestore.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Tạo lớp học
  Future<void> addClass(
      String title,
      String subject,
      String startDay,
      String daysInWeek,
      String room,
      String teacher,
      List<String> students) async {
    try {
      await _firestore.collection("class").doc(title).set({
        'title': title,
        'subject': subject,
        'startDay': startDay,
        'daysInWeek': daysInWeek,
        'room': room,
        'teacher': teacher,
      });

      for (String student in students) {
        await _firestore
            .collection("class")
            .doc(title)
            .collection("students")
            .doc(student)
            .set({'email': student});
      }
    } catch (e) {
      print('Error adding class: $e');
    }
  }


  //Load data lớp học
  Future<List<Map<String, dynamic>>> loadAllClassData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('class').get();
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

  // Lấy thông tin của một lớp học theo title
  Future<Map<String, dynamic>> getClassByTitle(String title) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('class').doc(title).get();
      Map<String, dynamic> classData = docSnapshot.data() as Map<String, dynamic>;
      classData['id'] = docSnapshot.id;
      return classData;
    } catch (e) {
      return {};
    }
  }

  Future<QuerySnapshot> getStudentsByClassTitle(String classTitle) async {
    return await _firestore.collection("class").doc(classTitle).collection("students").get();
  }

  // Lấy thông tin member dựa trên email và role
  Future<Map<String, dynamic>> getMemberData(String role, String email) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(role).doc(email).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> memberData = docSnapshot.data() as Map<String, dynamic>;
        memberData['id'] = docSnapshot.id;
        return memberData;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  //Xóa lớp học
  Future<void> deleteClass(String title) async {
    try {
      await _firestore
          .collection("class")
          .doc(title)
          .delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Hàm load dữ liệu điểm của sinh viên
  Future<List<Map<String, String>>> loadStudentScores(String classTitle) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("class")
          .doc(classTitle)
          .collection("students")
          .get();

      List<Map<String, String>> studentScores = await Future.wait(
        querySnapshot.docs.map((doc) async {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String email = doc.id;

          // Lấy tên sinh viên từ collection "student"
          DocumentSnapshot studentDoc = await _firestore.collection("student").doc(email).get();
          String studentName = '';

          if (studentDoc.exists) {
            final studentData = studentDoc.data() as Map<String, dynamic>?; // Ép kiểu
            studentName = studentData != null && studentData.containsKey('name')
                ? studentData['name'].toString()
                : '';
          }

          return {
            'email': email,
            'name': studentName,
            'process': data['process']?.toString() ?? '',
            'exam': data['exam']?.toString() ?? '',
          };
        }).toList(),
      );

      return studentScores;
    } catch (e) {
      print('Error loading student scores: $e');
      return [];
    }
  }



  // Hàm sửa điểm của sinh viên
  Future<void> updateStudentScore(
      String classTitle, String studentEmail, String process, String exam) async {
    try {
      await _firestore
          .collection("class")
          .doc(classTitle)
          .collection("students")
          .doc(studentEmail)
          .update({
        'process': process,
        'exam': exam,
      });
    } catch (e) {
      print('Error updating student score: $e');
    }
  }
}
