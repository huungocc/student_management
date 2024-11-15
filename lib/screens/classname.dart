import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';

class ClassName extends StatefulWidget {
  final String className;

  ClassName({this.className = ''});

  @override
  State<ClassName> createState() => _ClassNameState();
}

class _ClassNameState extends State<ClassName> {
  final AuthService _authService = AuthService();
  bool isAdmin = false;

  final ClassService _classService = ClassService();
  Map<String, dynamic> classData = {};
  String info = '';
  Map<String, dynamic> teacherData = {};
  List<Map<String, dynamic>> studentData = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([_checkPermission(), loadClassData()]);
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
  }

  Future<void> loadClassData() async {
    try {
      setState(() {
        classData = {};
        info = '';
        teacherData = {};
        studentData = [];
      });

      // Lấy dữ liệu của lớp học
      Map<String, dynamic> loadedClassData = await _classService.getClassByTitle(widget.className);

      // Tạo thông tin cơ bản của lớp học
      String newInfo = '''
        Môn học: ${loadedClassData['subject'] ?? 'N/A'}
        Ngày bắt đầu: ${loadedClassData['startDay'] ?? 'N/A'}
        Lịch học trong tuần: ${loadedClassData['daysInWeek'] ?? 'N/A'}
        Phòng học: ${loadedClassData['room'] ?? 'N/A'}
      ''';

      // Lấy dữ liệu giáo viên
      Map<String, dynamic> newTeacherData = await _classService.getMemberData('teacher', loadedClassData['teacher'] ?? '');

      // Lấy dữ liệu sinh viên từ subcollection "students"
      List<Map<String, dynamic>> newStudentData = [];
      QuerySnapshot studentsSnapshot = await _classService.getStudentsByClassTitle(widget.className);
      for (var doc in studentsSnapshot.docs) {
        Map<String, dynamic> studentInfo = await _classService.getMemberData('student', doc['email']);
        newStudentData.add(studentInfo);
      }

      // Cập nhật state
      setState(() {
        classData = loadedClassData;
        info = newInfo;
        studentData = newStudentData;
        teacherData = newTeacherData;
      });
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error),
          ),
        );
      }
    }
  }

  void _onMemberPressed(Map<String, dynamic> memberData) {
    String info = '''
      ID: ${memberData['userID'] ?? 'N/A'}
      Email: ${memberData['email'] ?? 'N/A'}
      Giới tính: ${memberData['gender'] ?? 'N/A'}
      Ngày sinh: ${memberData['dateOfBirth'] ?? 'N/A'}
      Quê quán: ${memberData['country'] ?? 'N/A'}
      Địa chỉ: ${memberData['address'] ?? 'N/A'}
      Số điện thoại: ${memberData['phone'] ?? 'N/A'}
    ''';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AccountInfoScreen(
          isAdmin: false,
          title: memberData['name'] ?? 'N/A',
          description: memberData['role'] ?? 'N/A',
          info: info,
          iconData: Icons.account_circle_outlined,
        );
      },
    );
  }

  void _onEditClassPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddClasses(isAddClass: false, classData: classData, studentData: studentData.map((student) => student['email'] as String).toList()),
        );
      },
    ).then((_) {
      _onClassRefresh();
    });
  }

  void _onScorePressed(String className) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Score(className: className),
      ),
    );
  }

  Future<void> _onClassRefresh() async {
    loadClassData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              widget.className,
              style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
          )),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15.0,right: 15),
        child: Column(
          children: [
            Text(
              info,
              style: TextStyle(fontSize: 16, fontFamily: Fonts.display_font),
              softWrap: true,
            ),
            SizedBox(height: 15),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onClassRefresh,
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Text(
                        AppLocalizations.of(context)!.teacher,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: Fonts.display_font, color: Colors.black)
                    ),
                    InfoCard(
                      title: teacherData['name'] ?? teacherData['email'] ?? 'N/A',
                      description: teacherData['userID'] ?? 'N/A',
                      iconData: Icons.account_circle_outlined,
                      onPressed: () => _onMemberPressed(teacherData),
                    ),
                    ExpansionTile(
                      title: Text(
                          AppLocalizations.of(context)!.student,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: Fonts.display_font, color: Colors.black)
                      ),
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: studentData.length,
                          itemBuilder: (context, index) {
                            final student = studentData[index];
                            return InfoCard(
                              title: student['name'] ?? student['email'] ?? 'N/A',
                              description: student['userID'] ?? 'N/A',
                              iconData: Icons.account_circle_outlined,
                              onPressed: () => _onMemberPressed(student),
                            );
                          },
                        ),
                      ],
                    )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          height: 60,
          color: Colors.white70,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(130, 30),
                      backgroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => _onScorePressed(widget.className),
                    child: Text(
                      AppLocalizations.of(context)!.score,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: Fonts.display_font,
                          fontSize: 16),
                    )
                ),
              ),
              Visibility(
                  visible: isAdmin,
                  child: SizedBox(width: 10)
              ),
              Visibility(
                visible: isAdmin,
                child: Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(130, 30),
                        backgroundColor: Colors.orange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _onEditClassPressed,
                      child: Text(
                        AppLocalizations.of(context)!.edit,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: Fonts.display_font,
                            fontSize: 16),
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
