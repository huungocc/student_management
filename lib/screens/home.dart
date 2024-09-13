import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitThreeBounce(
            color: Colors.black,
            size: 30.0,
          ),
        );
      },
    );

    await _authService.signOut(context);
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  void _onNotiPressed() {
    //Todo: Navigate to Notification Screen
  }

  void _onSchedulePressed() {
    //Todo: Navigate to Schedule Screen
  }

  void _onSubjectPressed() {

  }

  void _onClassPressed() {

  }

  void _onInfoPressed() {

  }

  void _onUserPressed() {

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
                color: Colors.blueAccent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
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
                              style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Nguyễn Hữu Ngọc',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: Fonts.display_font),
                            ),
                          ],
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/default_avt.png'),
                          //foregroundImage: NetworkImage(_currentUser!.photoURL!),
                          radius: 35,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    InfoCard(
                      title: 'Tên thông báo',
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
                    Scrollbar(
                      thumbVisibility: true,
                      thickness: 3,
                      radius: Radius.circular(8),
                      child: SingleChildScrollView(
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
                    ),
                  ]
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
                //
              },
              child: Icon(Icons.edit_note_outlined, color: Colors.grey[800], size: 30)),
            GestureDetector(
              onTap: () {
                _onSettingPressed(context);
              },
              child: Icon(Icons.settings_outlined, color: Colors.grey[800], size: 30)),
          ],
        ),
      ),
    );
  }
}
