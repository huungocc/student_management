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
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadAllUserData();
    _controllerSearch.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controllerSearch.removeListener(_onSearchChanged);
    _controllerSearch.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchQuery = _controllerSearch.text.toLowerCase().trim();
    if (searchQuery.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return;
    }

    final allUsers = [...adminData, ...teacherData, ...studentData];
    final results = allUsers.where((user) {
      final name = (user['name'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      final userID = (user['userID'] ?? '').toString().toLowerCase();
      final gender = (user['gender'] ?? '').toString().toLowerCase();
      final phone = (user['phone'] ?? '').toString().toLowerCase();

      return name.contains(searchQuery) ||
          email.contains(searchQuery) ||
          userID.contains(searchQuery) ||
          gender.contains(searchQuery) ||
          phone.contains(searchQuery);
    }).toList();

    setState(() {
      isSearching = true;
      searchResults = results;
    });
  }

  Future<void> loadAllUserData() async {
    try {
      List<Map<String, dynamic>> loadedAdminData = await _accountService.loadAllUserDataByRole(UserRole.admin);
      List<Map<String, dynamic>> loadedTeacherData = await _accountService.loadAllUserDataByRole(UserRole.teacher);
      List<Map<String, dynamic>> loadedStudentData = await _accountService.loadAllUserDataByRole(UserRole.student);

      setState(() {
        adminData = loadedAdminData;
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

  void _accountPressed(Map<String, dynamic> userData) {
    FocusScope.of(context).requestFocus(FocusNode());

    String info = '''
      ID: ${userData['userID'] ?? 'N/A'}
      Email: ${userData['email'] ?? 'N/A'}
      Giới tính: ${userData['gender'] ?? 'N/A'}
      Ngày sinh: ${userData['dateOfBirth'] ?? 'N/A'}
      Quê quán: ${userData['country'] ?? 'N/A'}
      Địa chỉ: ${userData['address'] ?? 'N/A'}
      Số điện thoại: ${userData['phone'] ?? 'N/A'}
    ''';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AccountInfoScreen(
          title: userData['name'] ?? 'N/A',
          description: userData['role'] ?? 'N/A',
          info: info,
          iconData: Icons.account_circle_outlined,
          buttonTitle: AppLocalizations.of(context)!.advanced,
          onPressed: () => _openFirebaseUserConsole(),
          isAdmin: true,
        );
      },
    );
  }

  void _addAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerSearch.clear());
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
    ).then((_) {
      _onAccountRefresh();
    });
  }

  void _openFirebaseUserConsole() {
    Navigator.pushNamed(context, Routes.webview);
  }

  Future<void> _onAccountRefresh() async {
    loadAllUserData();
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: TextStyle(
              fontSize: 16,
              fontFamily: Fonts.display_font,
              color: Colors.black54
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final user = searchResults[index];
        return InfoCard(
          title: user['name'] ?? user['email'],
          description: user['userID'] ?? 'N/A',
          iconData: Icons.account_circle_outlined,
          onPressed: () => _accountPressed(user),
        );
      },
    );
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
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _onAccountRefresh,
                      child: Visibility(
                        visible: !isSearching,
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
                                      description: admin['userID'] ?? 'N/A',
                                      iconData: Icons.account_circle_outlined,
                                      onPressed: () => _accountPressed(admin),
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
                                      description: teacher['userID'] ?? 'N/A',
                                      iconData: Icons.account_circle_outlined,
                                      onPressed: () => _accountPressed(teacher),
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
                                      description: student['userID'] ?? 'N/A',
                                      iconData: Icons.account_circle_outlined,
                                      onPressed: () => _accountPressed(student),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isSearching)
                      _buildSearchResults(),
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
