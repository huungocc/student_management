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

  final List<String> _monhoc = ['mon 1', 'mon 2', 'mon 3'];

  final ClassService _classService = ClassService();
  List<Map<String, dynamic>> classData = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await _checkPermission();
    await _loadClassData();
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
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
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra'),
        ),
      );
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
        content: 'Xóa môn học $title',
        onSubmit: () async {
          try {
            await _classService.deleteClass(title);

            await CustomDialogUtil.showDialogNotification(
                context,
                content: 'Xóa lớp học thành công',
                onSubmit: () {
                  _loadClassData();
                }
            );
          } catch (e) {
            print(e);
            await CustomDialogUtil.showDialogNotification(
              context,
              content: 'Xóa lớp học thất bại',
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
              items: _monhoc.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 18, color: Colors.black87, fontFamily: Fonts.display_font),
                ),
              )).toList(),
              onChanged: (value) {
                //
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: classData.length,
                  itemBuilder: (context, index) {
                    final classes = classData[index];
                    return InfoCard(
                      title: classes['title'] ?? 'Unknown Class',
                      description: classes['subject'] ?? 'Unknown Subject',
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
