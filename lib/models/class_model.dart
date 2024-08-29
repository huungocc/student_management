import 'package:student_management/models/model.dart';

class Class {
  final String classId;
  final Course course;
  final Instructor instructor;
  final List<Student> students;
  final DateTime schedule;

  Class({
    required this.classId,
    required this.course,
    required this.instructor,
    required this.students,
    required this.schedule,
  });
}
