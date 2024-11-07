import 'package:flutter/material.dart';
import 'package:student_management/widgets/widget.dart';

import '../managers/manager.dart';

class AddMember extends StatefulWidget {
  final List<Map<String, dynamic>> teacherData;
  final List<Map<String, dynamic>> studentData;
  final String? selectedTeacher;
  final List<String> selectedStudents;

  const AddMember({super.key,
    required this.teacherData,
    required this.studentData,
    this.selectedTeacher,
    required this.selectedStudents,
  });

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  String? selectedTeacher;
  List<String> selectedStudents = [];

  @override
  void initState() {
    super.initState();
    selectedTeacher = widget.selectedTeacher;
    selectedStudents = List.from(widget.selectedStudents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Thêm Thành Viên',
              style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.black87,
              labelColor: Colors.black87,
              tabs: [
                Tab(text: 'Giảng viên'),
                Tab(text: 'Sinh viên'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ListView.builder(
                  itemCount: widget.teacherData.length,
                  itemBuilder: (context, index) {
                    final teacher = widget.teacherData[index];
                    return InfoCard(
                      title: teacher['name'] ?? teacher['email'],
                      description: teacher['userID'] ?? 'N/A',
                      iconData: Icons.account_circle_outlined,
                      hasCheckBox: true,
                      isChecked: selectedTeacher == teacher['email'],
                      onChecked: (isChecked) {
                        setState(() {
                          selectedTeacher = isChecked == true ? teacher['email'] : null;
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ListView.builder(
                  itemCount: widget.studentData.length,
                  itemBuilder: (context, index) {
                    final student = widget.studentData[index];
                    return InfoCard(
                      title: student['name'] ?? student['email'],
                      description: student['userID'] ?? 'N/A',
                      iconData: Icons.school_outlined,
                      hasCheckBox: true,
                      isChecked: selectedStudents.contains(student['email']),
                      onChecked: (isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            selectedStudents.add(student['email']);
                          } else {
                            selectedStudents.remove(student['email']);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.white70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            Navigator.pop(context, {
              'selectedTeacher': selectedTeacher,
              'selectedStudents': selectedStudents,
            });
          },
          child: Text(
            "Xác nhận",
            style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font)
          ),
        ),
      ),
    );
  }
}
