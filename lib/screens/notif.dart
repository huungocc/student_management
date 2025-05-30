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
  List<Map<String, dynamic>> filteredNotifData = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
    loadAllNotifData();
    _controllerSearch.addListener(_filterNotifData);
  }

  @override
  void dispose() {
    _controllerSearch.removeListener(_filterNotifData);
    _controllerSearch.dispose();
    super.dispose();
  }

  Future<void> loadAllNotifData() async{
    try {
      List<Map<String,dynamic>> loadedNotifData = await _notifService.loadAllNotifData();

      setState(() {
        notifData = loadedNotifData;
        filteredNotifData = loadedNotifData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error),
        ),
      );
    }
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
  }

  void _filterNotifData() {
    String searchQuery = _controllerSearch.text.toLowerCase();
    setState(() {
      filteredNotifData = notifData
          .where((notif) => notif['title']?.toLowerCase().contains(searchQuery) ?? false)
          .toList();
    });
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
        content: AppLocalizations.of(context)!.deleteNotif,
        onSubmit: () async {
          try {
            await _notifService.deleteNotification(datetime);

            await CustomDialogUtil.showDialogNotification(
                context,
                content: AppLocalizations.of(context)!.delNotifSuccess,
                onSubmit: () {
                  Navigator.pop(context);
                  loadAllNotifData();
                }
            );
          } catch (e) {
            print(e);
            await CustomDialogUtil.showDialogNotification(
              context,
              content: AppLocalizations.of(context)!.delNotifFail,
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
                  child: filteredNotifData.isEmpty
                  ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noData,
                      style: TextStyle(fontSize: 16, color: Colors.black54, fontFamily: Fonts.display_font),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: filteredNotifData.length,
                    itemBuilder: (context, index) {
                      final notif = filteredNotifData[index];
                      return InfoCard(
                        title: notif['title'] ?? 'N/A',
                        description: notif['datetime'] ?? 'N/A',
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
