import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Notif extends StatefulWidget {
  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  final AuthService _authService = AuthService();
  final TextEditingController _controllerSearch = TextEditingController();
  bool isAdmin = false;

  final NotifService _notifService = NotifService();
  List<Map<String,dynamic>> notifData = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
    loadAllNotifData();
  }

  Future<void> loadAllNotifData() async{
    try {
      List<Map<String,dynamic>> loadedNotifData = await _notifService.loadAllNotifData();
      setState(() {
        notifData = loadedNotifData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra'),
        ),
      );
    }
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
  }

  void _onNotifPressed(Map<String, dynamic> notifData) {
    FocusScope.of(context).requestFocus(FocusNode());

    String info = notifData['content'];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InfoScreen(
          isAdmin: isAdmin,
          title: notifData['title'] ?? 'N/A',
          description: notifData['datetime'] ?? 'N/A',
          info: info,
          iconData: Icons.notifications_active_outlined,
          leftButtonTitle: AppLocalizations.of(context)!.delete,
          rightButtonTitle: AppLocalizations.of(context)!.edit,
          onLeftPressed: () => _deleteNotif(notifData['datetime']),
          onRightPressed: () => _editNotif(notifData),
        );
      },
    );
  }

  void _addNotif() {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditNoti(isAddNotif: true),
        );
      },
    ).then((_) {
      _onNotifRefresh();
    });
  }

  Future<void> _deleteNotif(String datetime) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await CustomDialogUtil.showDialogConfirm(
        context,
        content: 'Xóa thông báo?',
        onSubmit: () async {
          try {
            await _notifService.deleteNotification(datetime);

            await CustomDialogUtil.showDialogNotification(
                context,
                content: 'Xóa thông báo thành công',
                onSubmit: () {
                  Navigator.pop(context);
                  loadAllNotifData();
                }
            );
          } catch (e) {
            print(e);
            await CustomDialogUtil.showDialogNotification(
              context,
              content: 'Xóa thông báo thất bại',
            );
          }
        }
    );
  }

  void _editNotif(Map<String, dynamic> notifData) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditNoti(isAddNotif: false, notifData: notifData),
        );
      },
    ).then((_) {
      _onNotifRefresh();
    });
  }

  Future<void> _onNotifRefresh() async {
    loadAllNotifData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.notif,
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
          padding: EdgeInsets.only(left: 15, right: 15),
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
                  onRefresh: _onNotifRefresh,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: notifData.length,
                    itemBuilder: (context, index) {
                      final notif = notifData[index];
                      return InfoCard(
                        title: notif['title'] ?? 'Unknown Title',
                        description: notif['datetime'] ?? 'Unknown Datetime',
                        iconData: Icons.notifications_active_outlined,
                        onPressed: () => _onNotifPressed(notif),
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
          backgroundColor: Colors.teal,
          elevation: 0,
          shape: CircleBorder(),
          child: Icon(Icons.add_rounded, color: Colors.white),
          onPressed: _addNotif,
        ),
      ),
    );
  }
}
