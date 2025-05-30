import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:student_management/screens/screen.dart';
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
  final AccountService _accountService = AccountService();
  User? currentUser;
  Map<String, dynamic>? currentUserData;

  bool isAdmin = false;
  String userRole = '';

  final NotifService _notifService = NotifService();
  Map<String, dynamic>? latestNotif;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _checkPermission();
    await _getUserRole();
    await _loadUserData();
    await _loadLatestNotif();
    setState(() {});
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
  }

  Future<void> _getUserRole() async {
    userRole = await AuthService.getStringRole();
  }

  Future<void> _loadUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && userRole.isNotEmpty) {
      try {
        var userData = await _accountService.loadUserData(userRole, currentUser!.email);
        currentUserData = userData;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error),
          ),
        );
      }
    }
  }

  Future<void> _loadLatestNotif() async {
    try {
      Map<String,dynamic>? loadedLatestNotifData = await _notifService.loadLatestNotif();
      setState(() {
        latestNotif = loadedLatestNotifData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error),
        ),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: 30.0,
            ),
          );
        },
      );

      await _authService.signOut();

      Navigator.pop(context);
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.signOutSuccess,
        onSubmit: () => Navigator.pushReplacementNamed(context, Routes.login)
      );
    } catch (e) {
      Navigator.pop(context);
      await CustomDialogUtil.showDialogNotification(
          context,
          content: AppLocalizations.of(context)!.signOutFailed,
      );
      throw e;
    }
  }

  void _onNotiPressed() {
    Navigator.pushNamed(context, Routes.notif).then((_) {
      _onHomeRefresh();
    });
  }

  Future<void> _onSchedulePressed() async {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (BuildContext context) {
    //     return Padding(
    //       padding: EdgeInsets.only(
    //         bottom: MediaQuery.of(context).viewInsets.bottom,
    //       ),
    //       child: ScheduleSubject(),
    //     );
    //   },
    // );
    await CustomDialogUtil.showDialogNotification(
      context,
      content: 'Coming soon',
    );
  }

  void _onSubjectPressed() {
    Navigator.pushNamed(context, Routes.subject);
  }

  void _onClassPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Classes(email: currentUserData!['email']),
      )
    );
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
          child: UserScreen(userData: currentUserData, userRole: userRole),
        );
      },
    );
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
    _loadUserData();
    _loadLatestNotif();
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
                              currentUserData?['name'] ?? currentUserData?['email'] ?? 'N/A',
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
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    InfoCard(
                      title:
                      latestNotif?['title'] ?? 'N/A',
                      description: latestNotif?['datetime'] ?? 'N/A',
                      iconData: Icons.notifications_active_outlined,
                      bgColor: Colors.teal,
                      elColor: Colors.white,
                      onPressed: _onNotiPressed,
                    ),
                    InfoCard(
                      title: 'Coming soon',
                      description: 'Coming soon',
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
                          Visibility(
                            visible: isAdmin,
                            child: FunctionCard(
                              title: AppLocalizations.of(context)!.account,
                              iconData: Icons.people_alt_outlined,
                              bgColor: Colors.indigo,
                              elColor: Colors.white,
                              onPressed: _onUserPressed,
                            ),
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
