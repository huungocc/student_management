import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:student_management/widgets/add_member.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import 'widget.dart';


class AddClasses extends StatefulWidget {
  final bool isAddClass;
  final Map<String, dynamic>? classData;
  final List<String>? studentData;

  const AddClasses({super.key, required this.isAddClass, this.classData, this.studentData});

  @override
  State<AddClasses> createState() => _AddClasses();
}

class _AddClasses extends State<AddClasses> {
  final TextEditingController _controllerClassName = TextEditingController();
  final TextEditingController _controllerRoom = TextEditingController();
  final TextEditingController _controllerSchedule = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  final AccountService _accountService = AccountService();
  List<Map<String, dynamic>> teacherData = [];
  List<Map<String, dynamic>> studentData = [];

  String selectedTeacher = '';
  List<String> selectedStudents = [];

  final SubjectService _subjectService = SubjectService();
  List<String> subjectList = [];
  String selectedSubject = '';

  final ClassService _classService = ClassService();

  @override
  void initState() {
    super.initState();
    _initializeClassData();
    loadAllUserData();
    loadSubjectList();
  }

  void _initializeClassData() {
    if (widget.classData != null) {
      _controllerClassName.text = widget.classData?['title'] ?? '';
      _controllerRoom.text = widget.classData?['room'] ?? '';
      _controllerSchedule.text = widget.classData?['daysInWeek'] ?? '';

      // Cập nhật môn học
      if (widget.classData?['subject'] != null) {
        setState(() {
          selectedSubject = widget.classData!['subject'];
        });
      }

      // Cập nhật ngày bắt đầu
      if (widget.classData?['startDay'] != null) {
        setState(() {
          _selectedDate = DateFormat(FormatDate.dateOfBirth).parse(widget.classData!['startDay']);
        });
      }

      // Cập nhật giảng viên và sinh viên
      if (widget.classData?['teacher'] != null) {
        setState(() {
          selectedTeacher = widget.classData!['teacher'];
          print(selectedTeacher);
        });
      }

      if (widget.studentData != null) {
        setState(() {
          selectedStudents = List<String>.from(widget.studentData!);
        });
      }
    }
  }


  Future<void> loadAllUserData() async {
    try {
      List<Map<String, dynamic>> loadedTeacherData = await _accountService.loadAllUserDataByRole(UserRole.teacher);
      List<Map<String, dynamic>> loadedStudentData = await _accountService.loadAllUserDataByRole(UserRole.student);

      setState(() {
        teacherData = loadedTeacherData;
        studentData = loadedStudentData;
      });
    }  catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error),
        ),
      );
    }
  }

  Future<void> loadSubjectList() async {
    try{
      List<String> loadedSubjectList = await _subjectService.loadAllSubjectTitles();

      setState(() {
        subjectList = loadedSubjectList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error),
        ),
      );
    }
  }

  void _showDatePicker() {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: ScrollDatePicker(
            selectedDate: _selectedDate,
            locale: Locale('en'),
            onDateTimeChanged: (DateTime value) {
              setState(() {
                _selectedDate = value;
              });
            },
          ),
        );
      },
    );
  }

  void onAddMemberPressed() async {
    FocusScope.of(context).requestFocus(FocusNode());

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AddMember(
          studentData: studentData,
          teacherData: teacherData,
          selectedTeacher: selectedTeacher,
          selectedStudents: selectedStudents,
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedTeacher = result['selectedTeacher'] as String;
        selectedStudents = result['selectedStudents'] as List<String>;
      });
    }
  }

  void onCancelPressed() {
    Navigator.pop(context);
  }

  Future<void> addClass() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String title = _controllerClassName.text.trim();
    String subject = selectedSubject;
    String startDay = DateFormat(FormatDate.dateOfBirth).format(_selectedDate);
    String daysInWeek = _controllerSchedule.text.trim();
    String room = _controllerRoom.text.trim();
    String teacher = selectedTeacher;
    List<String> students = selectedStudents;

    if (title.isEmpty || subject.isEmpty || startDay.isEmpty || daysInWeek.isEmpty || room.isEmpty || teacher.isEmpty || students.isEmpty) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    } else {
      await CustomDialogUtil.showDialogConfirm(
          context,
          content: AppLocalizations.of(context)!.addClass + title,
          onSubmit: () async {
            try {
              await _classService.addClass(
                  title,
                  subject,
                  startDay,
                  daysInWeek,
                  room,
                  teacher,
                  students
              );

              await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.addClassSuccess,
                  onSubmit: () => Navigator.pop(context)
              );
            } catch (e) {
              print(e);
              if (e.toString().contains("Lớp học đã tồn tại")) {
                await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.existClass,
                );
              } else {
                await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.addClassFail,
                );
              }
            }
          }
      );
    }
  }

  Future<void> editClass() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String title = _controllerClassName.text.trim();
    String subject = selectedSubject;
    String startDay = DateFormat(FormatDate.dateOfBirth).format(_selectedDate);
    String daysInWeek = _controllerSchedule.text.trim();
    String room = _controllerRoom.text.trim();
    String teacher = selectedTeacher;
    List<String> students = selectedStudents;

    if (title.isEmpty || subject.isEmpty || startDay.isEmpty || daysInWeek.isEmpty || room.isEmpty || teacher.isEmpty || students.isEmpty) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    } else {
      await CustomDialogUtil.showDialogConfirm(
          context,
          content: AppLocalizations.of(context)!.editClass + title,
          onSubmit: () async {
            try {
              await _classService.editClass(
                  title,
                  subject,
                  startDay,
                  daysInWeek,
                  room,
                  teacher,
                  students
              );

              await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.editClassSuccess,
                  onSubmit: () => Navigator.pop(context)
              );
            } catch (e) {
              print(e);
              await CustomDialogUtil.showDialogNotification(
                context,
                content: AppLocalizations.of(context)!.editClassFail,
              );
            }
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            TextField(
              enabled: widget.isAddClass,
              controller: _controllerClassName,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nameClass,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.subjectName,
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField2<String>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.chooseSubject,
                labelStyle: TextStyle(fontSize: 16,color: Colors.black87, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: subjectList.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 18, color: Colors.black87, fontFamily: Fonts.display_font),
                ),
              )).toList(),
              onChanged: (value) {
                selectedSubject = value!;
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
                iconSize: 30,
              ),
              dropdownStyleData: DropdownStyleData(
                offset: Offset(0, -5),
                elevation: 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[300],
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                height: 53,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 13),
                    Text(
                      DateFormat(FormatDate.dateOfBirth).format(_selectedDate),
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                    ),
                    Spacer(),
                    Icon(Icons.date_range_rounded, color: Colors.black87,),
                    SizedBox(width: 13),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _controllerSchedule,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: 'Lịch học trong tuần',
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Nhập lịch học trong tuần",
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _controllerRoom,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: 'Phòng học',
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Nhập phòng học",
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                minimumSize: Size(double.infinity, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              onPressed: onAddMemberPressed,
              child: Text(
                  'Thành viên',
                  style: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font, fontSize: 16)
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 30),
                    backgroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: onCancelPressed,
                  child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 30),
                    backgroundColor: Colors.teal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: widget.isAddClass ? addClass : editClass,
                  child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
