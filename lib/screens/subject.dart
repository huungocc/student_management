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

  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
  }

  //-------su kien--------------
  void _onSubjectPressed() {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InfoScreen(
          isAdmin: isAdmin,
          title: 'Toan',
          description: 'Dai cuong',
          info: '1+1=3',
          iconData: Icons.school_outlined,
          onLeftPressed: _deleteSubject,
          onRightPressed: _addSubject,
          leftButtonTitle: AppLocalizations.of(context)!.delete,
          rightButtonTitle: AppLocalizations.of(context)!.edit,
        );
      },
    );
  }

  void _addSubject() {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddSubject(
            onCancelPressed: _onCancelPressed,
            onOkPressed: _onOkPressed,
          ),
        );
      },
    );
  }

  void _onCancelPressed() {
    Navigator.pop(context);
  }

  Future<void> _onOkPressed() async {}

  Future<void> _deleteSubject() async {}

  Future<void> _onSubjectRefresh() async {
    //
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
              RefreshIndicator(
                onRefresh: _onSubjectRefresh,
                child: Scrollbar(
                    thumbVisibility: true,
                    radius: Radius.circular(8),
                    child: SingleChildScrollView(
                        child: InfoCard(
                      title: 'Toan',
                      description: 'Dai Cuong',
                      iconData: Icons.school_outlined,
                      onPressed: _onSubjectPressed,
                    ))),
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
