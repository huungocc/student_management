import 'package:flutter/material.dart';
import 'package:student_management/widgets/function_card.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();

  Future<void> _signOut() async {
    await _authService.signOut(context);
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  void _onNotiPressed() {
    Navigator.pushNamed(context, Routes.notif);
  }

  void _onSchedulePressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ScheduleSubject(),
        );
      },
    );
  }

  void _onSubjectPressed() {
    Navigator.pushNamed(context, Routes.subject);
  }

  void _onClassPressed() {
    Navigator.pushNamed(context, Routes.classes);
  }

  void _onInfoPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: UserScreen(
            onCancelPressed: _onCancelPressed,
            onOkPressed: _onOkPressed,
          ),
        );
      },
    );
  }

  Future<void> _onCancelPressed() async {
    Navigator.pop(context);
  }

  Future<void> _onOkPressed() async {
    //
  }

  void _onUserPressed() {
    Navigator.pushNamed(context, Routes.account);
  }

  void _onSettingPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SettingScreen(
          onLogOut: _signOut,
        );
      },
    );
  }

  Future<void> _onHomeRefresh() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 35, right: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.welcome,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: Fonts.display_font,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Nguyễn Hữu Ngọc',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: Fonts.display_font),
                            ),
                          ],
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/default_avt.png'),
                          //foregroundImage: NetworkImage(_currentUser!.photoURL!),
                          radius: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            RefreshIndicator(
              onRefresh: _onHomeRefresh,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    InfoCard(
                      title:
                          'Trường Đại học Giao thông vận tải chia sẻ khó khăn cùng đồng bào bị ảnh hưởng do thiên tai, lũ lụt',
                      description: 'dd/mm/yyyy',
                      iconData: Icons.notifications_active_outlined,
                      bgColor: Colors.teal,
                      elColor: Colors.white,
                      onPressed: _onNotiPressed,
                    ),
                    InfoCard(
                      title: 'Tên lớp học',
                      description: 'Ca 1 101-A2',
                      iconData: Icons.schedule_outlined,
                      bgColor: Colors.cyan[600],
                      elColor: Colors.white,
                      onPressed: _onSchedulePressed,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FunctionCard(
                            title: AppLocalizations.of(context)!.subject,
                            iconData: Icons.school_outlined,
                            bgColor: Colors.red,
                            elColor: Colors.white,
                            onPressed: _onSubjectPressed,
                          ),
                          FunctionCard(
                            title: AppLocalizations.of(context)!.classes,
                            iconData: Icons.calendar_month_outlined,
                            bgColor: Colors.orange,
                            elColor: Colors.white,
                            onPressed: _onClassPressed,
                          ),
                          FunctionCard(
                            title: AppLocalizations.of(context)!.account,
                            iconData: Icons.people_alt_outlined,
                            bgColor: Colors.indigo,
                            elColor: Colors.white,
                            onPressed: _onUserPressed,
                          ),
                        ],
                      ),
                    ),
                  ]),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () {
                  _onInfoPressed();
                },
                child: Icon(Icons.edit_note_outlined,
                    color: Colors.grey[800], size: 30)),
            GestureDetector(
                onTap: () {
                  _onSettingPressed(context);
                },
                child: Icon(Icons.settings_outlined,
                    color: Colors.grey[800], size: 30)),
          ],
        ),
      ),
    );
  }
}
