class User {
  final String id;
  final String email;
  final String role; // "student", "instructor", "admin"
  final String linkedId; // Links to either Student or Instructor ID

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.linkedId,
  });
}
