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
      DocumentSnapshot existingClass = await _firestore.collection("class").doc(title).get();
      if (existingClass.exists) {
        throw Exception("Lớp học đã tồn tại");
      }

      await _firestore.collection("class").doc(title).set({
        'title': title,
        'subject': subject,
        'startDay': startDay,
        'daysInWeek': daysInWeek,
        'room': room,
        'teacher': teacher,
      });

      QuerySnapshot existingStudents = await _firestore
          .collection("class")
          .doc(title)
          .collection("students")
          .get();

      for (var doc in existingStudents.docs) {
        await doc.reference.delete();
      }

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
      throw e;
    }
  }

  //edit
  Future<void> editClass(
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

  Future<List<Map<String, dynamic>>> getClassesByUserEmail(String email) async {
    List<Map<String, dynamic>> classData = [];

    try {
      // Truy vấn lớp học mà email là teacher
      QuerySnapshot teacherSnapshot = await _firestore
          .collection('class')
          .where('teacher', isEqualTo: email)
          .get();

      // Lưu lớp học có email trong vai trò teacher vào danh sách classData
      classData.addAll(teacherSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList());

      // Lấy tất cả lớp học để kiểm tra trong từng subcollection students
      QuerySnapshot allClassesSnapshot = await _firestore.collection('class').get();

      for (var classDoc in allClassesSnapshot.docs) {
        // Kiểm tra từng lớp để xem email có trong subcollection students không
        QuerySnapshot studentsSnapshot = await classDoc.reference.collection('students')
            .where('email', isEqualTo: email)
            .get();

        if (studentsSnapshot.docs.isNotEmpty) {
          // Nếu email có trong students, thêm lớp học vào danh sách classData nếu chưa có
          Map<String, dynamic> data = classDoc.data() as Map<String, dynamic>;
          data['id'] = classDoc.id;

          // Kiểm tra tránh trùng lặp (nếu lớp đã có trong danh sách)
          if (!classData.any((item) => item['id'] == classDoc.id)) {
            classData.add(data);
          }
        }
      }

      return classData;
    } catch (e) {
      print('Error getting classes by user email: $e');
      return [];
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
