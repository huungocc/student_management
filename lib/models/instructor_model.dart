import 'package:student_management/models/model.dart';

class Instructor {
  final String id;
  final String name;
  final String department;
  final List<Course> teachingCourses;

  Instructor({
    required this.id,
    required this.name,
    required this.department,
    required this.teachingCourses,
  });
}
