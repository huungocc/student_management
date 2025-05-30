import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:student_management/screens/screen.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';

class Classes extends StatefulWidget {
  final String? email;

  const Classes({super.key, this.email});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final AuthService _authService = AuthService();
  bool isAdmin = false;

  final ClassService _classService = ClassService();
  List<Map<String, dynamic>> classData = [];
  List<Map<String, dynamic>> filteredClassData = [];

  final SubjectService _subjectService = SubjectService();
  List<String> subjectList = [];
  String selectedSubject = 'Tất cả';

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await _checkPermission();
    await _loadClassData();
    await _loadSubjectList();
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
  }

  Future<void> _loadSubjectList() async {
    try{
      List<String> loadedSubjectList = await _subjectService.loadAllSubjectTitles();
      loadedSubjectList.insert(0, 'Tất cả');

      setState(() {
        subjectList = loadedSubjectList;
        _filterClasses(selectedSubject);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadClassData() async {
    print(widget.email);
    try {
      List<Map<String, dynamic>> loadedClassData;

      if (isAdmin) {
        loadedClassData = await _classService.loadAllClassData();
      } else {
        loadedClassData = await _classService.getClassesByUserEmail(widget.email!);
      }

      setState(() {
        classData = loadedClassData;
        _filterClasses(selectedSubject);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error),
        ),
      );
    }
  }

  void _filterClasses(String? subject) {
    if (subject == null || subject == 'Tất cả') {
      setState(() {
        filteredClassData = List.from(classData);
        selectedSubject = 'Tất cả';
      });
    } else {
      setState(() {
        filteredClassData = classData
            .where((classItem) =>
        classItem['subject']?.toString().toLowerCase() ==
            subject.toLowerCase())
            .toList();
        selectedSubject = subject;
      });
    }
  }

  void _onClassesPressed(String className) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassName(className: className),
      ),
    );
  }

  Future<void> _deleteClass(String title) async {
    await CustomDialogUtil.showDialogConfirm(
        context,
        content: AppLocalizations.of(context)!.deleteSubject + title,
        onSubmit: () async {
          try {
            await _classService.deleteClass(title);

            await CustomDialogUtil.showDialogNotification(
                context,
                content: AppLocalizations.of(context)!.delClassSuccess,
                onSubmit: () {
                  _loadClassData();
                }
            );
          } catch (e) {
            print(e);
            await CustomDialogUtil.showDialogNotification(
              context,
              content: AppLocalizations.of(context)!.delClassFail,
            );
          }
        }
    );
  }

  void _addClass(){
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddClasses(isAddClass: true),
        );
      },
    ).then((_) {
      _onClassesRefresh();
    });
  }

  Future<void> _onClassesRefresh() async {
    _loadClassData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.classes,
            style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        child: Column(
          children: [
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
                _filterClasses(value);
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onClassesRefresh,
                child: filteredClassData.isEmpty
                ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.noData,
                    style: TextStyle(fontSize: 16, color: Colors.black54, fontFamily: Fonts.display_font),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: filteredClassData.length,
                  itemBuilder: (context, index) {
                    final classes = filteredClassData[index];
                    return InfoCard(
                      title: classes['title'] ?? 'N/A',
                      description: classes['subject'] ?? 'N/A',
                      iconData: Icons.school_outlined,
                      onPressed: () => _onClassesPressed(classes['title']),
                      onLongPressed: () => _deleteClass(classes['title']),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          elevation: 0,
          shape: CircleBorder(),
          child: Icon(Icons.add_rounded, color: Colors.white),
          onPressed: _addClass,
        ),
      ),
    );
  }
}
