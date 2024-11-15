import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';

class Subject extends StatefulWidget {
  const Subject({super.key});

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  final AuthService _authService = AuthService();
  bool isAdmin = false;

  final SubjectService _subjectService = SubjectService();
  List<Map<String, dynamic>> subjectData = [];
  List<Map<String, dynamic>> filteredSubjectData = [];

  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermission();
    loadAllSubjectData();
    _controllerSearch.addListener(_filterSubjects);
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
  }

  void _filterSubjects() {
    String searchText = _controllerSearch.text.toLowerCase();
    setState(() {
      filteredSubjectData = subjectData.where((subject) {
        final title = subject['title']?.toLowerCase() ?? '';
        final category = subject['category']?.toLowerCase() ?? '';
        return title.contains(searchText) || category.contains(searchText);
      }).toList();
    });
  }

  @override
  void dispose() {
    _controllerSearch.removeListener(_filterSubjects);
    _controllerSearch.dispose();
    super.dispose();
  }

  Future<void> loadAllSubjectData() async {
    try {
      List<Map<String, dynamic>> loadedSubjectData = await _subjectService.loadAllSubjectData();

      setState(() {
        subjectData = loadedSubjectData;
        filteredSubjectData = loadedSubjectData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error),
        ),
      );
    }
  }

  void _onSubjectPressed(Map<String, dynamic> subjectData) {
    FocusScope.of(context).requestFocus(FocusNode());

    String info = '''
      Số tín chỉ: ${subjectData['credit'] ?? 'N/A'}
      Mô tả: ${subjectData['description'] ?? 'N/A'}
      Tổng số buổi: ${subjectData['totalDays'] ?? 'N/A'}
    ''';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InfoScreen(
          title: subjectData['title'] ?? 'N/A',
          description: subjectData['category'] ?? 'N/A',
          info: info,
          iconData: Icons.school_outlined,
          leftButtonTitle: AppLocalizations.of(context)!.delete,
          rightButtonTitle: AppLocalizations.of(context)!.edit,
          onLeftPressed: () => _deleteSubject(subjectData['title']),
          onRightPressed: () => _editSubject(subjectData),
          isAdmin: isAdmin,
        );
      },
    );
  }

  void _addSubject() {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddSubject(isAddSubject: true),
        );
      },
    ).then((_) {
      _onSubjectRefresh();
    });
  }

  Future<void> _deleteSubject(String title) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await CustomDialogUtil.showDialogConfirm(
      context,
      content: AppLocalizations.of(context)!.deleteSubject + title,
      onSubmit: () async {
        try {
          await _subjectService.deleteSubject(title);

          await CustomDialogUtil.showDialogNotification(
            context,
            content: AppLocalizations.of(context)!.delSubjectSuccess,
            onSubmit: () {
              Navigator.pop(context);
              loadAllSubjectData();
            }
          );
        } catch (e) {
          print(e);
          await CustomDialogUtil.showDialogNotification(
            context,
            content: AppLocalizations.of(context)!.delSubjectFail,
          );
        }
      }
    );
  }

  void _editSubject(Map<String, dynamic> subjectData) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddSubject(isAddSubject: false, subjectData: subjectData),
        );
      },
    ).then((_) {
      _onSubjectRefresh();
    });
  }

  Future<void> _onSubjectRefresh() async {
    loadAllSubjectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.subject,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: Fonts.display_font,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              TextFormField(
                controller: _controllerSearch,
                cursorColor: Colors.black87,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: Fonts.display_font),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  hintText: AppLocalizations.of(context)!.search,
                  hintStyle: TextStyle(
                      color: Colors.black26, fontFamily: Fonts.display_font),
                  prefixIcon: const Icon(Icons.search_rounded),
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onSubjectRefresh,
                  child: filteredSubjectData.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.noData,
                        style: TextStyle(fontSize: 16, color: Colors.black54, fontFamily: Fonts.display_font),
                      ),
                  )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: filteredSubjectData.length,
                      itemBuilder: (context, index) {
                        final subject = filteredSubjectData[index];
                        return InfoCard(
                          title: subject['title'] ?? 'N/A',
                          description: subject['category'] ?? 'N/A',
                          iconData: Icons.school_outlined,
                          onPressed: () => _onSubjectPressed(subject),
                        );
                      },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          elevation: 0,
          shape: CircleBorder(),
          child: Icon(Icons.add_rounded, color: Colors.white),
          onPressed: _addSubject,
        ),
      ),
    );
  }
}
