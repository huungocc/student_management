import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController _controllerSearch = TextEditingController();
  final AccountService _accountService = AccountService();
  List<Map<String, dynamic>> adminData = [];
  List<Map<String, dynamic>> teacherData = [];
  List<Map<String, dynamic>> studentData = [];

  @override
  void initState() {
    super.initState();
    loadAllUserData();
  }

  Future<void> loadAllUserData() async {
    List<Map<String, dynamic>> loadedAdminData = await _accountService.loadAllUserDataByRole(context, 'admin');
    List<Map<String, dynamic>> loadedTeacherData = await _accountService.loadAllUserDataByRole(context, 'teacher');
    List<Map<String, dynamic>> loadedStudentData = await _accountService.loadAllUserDataByRole(context, 'student');
    setState(() {
      adminData = loadedAdminData;
      teacherData = loadedTeacherData;
      studentData = loadedStudentData;
    });
  }

  void _accountPressed() {
    FocusScope.of(context).requestFocus(new FocusNode());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerSearch.clear());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InfoScreen(
          title: 'Ten nguoi dung',
          description: 'Loai tai khoan',
          info: 'nguoi giu lang',
          iconData: Icons.account_circle_outlined,
          leftButtonTitle: AppLocalizations.of(context)!.delete,
          rightButtonTitle: AppLocalizations.of(context)!.resetPassword,
          onLeftPressed: _deleteAccount,
          onRightPressed: _onResetPassword,
        );
      },
    );
  }

  void _addAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerSearch.clear());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddAccount(),
        );
      },
    );
  }

  Future<void> _deleteAccount() async {}

  Future<void> _onResetPassword() async {
    //
  }

  Future<void> _onAccountRefresh() async {
    loadAllUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              AppLocalizations.of(context)!.account,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: Fonts.display_font, color: Colors.black),
            ),
            centerTitle: true,
          )),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controllerSearch,
              cursorColor: Colors.black87,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                hintText: AppLocalizations.of(context)!.search,
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
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
                onRefresh: _onAccountRefresh,
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    ExpansionTile(
                      title: Text(
                          AppLocalizations.of(context)!.admin,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: Fonts.display_font, color: Colors.black)
                      ),
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: adminData.length,
                          itemBuilder: (context, index) {
                            final admin = adminData[index];
                            return InfoCard(
                              title: admin['name'] ?? admin['email'],
                              description: admin['role'] ?? 'Unknown Role',
                              iconData: Icons.account_circle_outlined,
                              onPressed: () {},
                            );
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                          AppLocalizations.of(context)!.teacher,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: Fonts.display_font, color: Colors.black)
                      ),
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: teacherData.length,
                          itemBuilder: (context, index) {
                            final teacher = teacherData[index];
                            return InfoCard(
                              title: teacher['name'] ?? teacher['email'],
                              description: teacher['role'] ?? 'Unknown Role',
                              iconData: Icons.account_circle_outlined,
                              onPressed: () {},
                            );
                          },
                        ),
                      ],
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
                              title: student['name'] ?? student['email'],
                              description: student['role'] ?? 'Unknown Role',
                              iconData: Icons.account_circle_outlined,
                              onPressed: () {},
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        elevation: 0,
        shape: CircleBorder(),
        child: Icon(Icons.add_rounded, color: Colors.white),
        onPressed: _addAccount,
      ),
    );
  }
}
