import 'package:student_management/models/model.dart';

class Student {
  final String id;
  final String name;
  final DateTime birthDate;
  final String email;
  final String department;
  final List<Course> courses;
  final Map<String, double> grades; // Course ID -> Grade
  final double gpa;
  final String status; // Active, Graduated, etc.

  Student({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.email,
    required this.department,
    required this.courses,
    required this.grades,
    required this.gpa,
    required this.status,
  });
}
