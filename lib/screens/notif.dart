import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/manager.dart';
import '../widgets/widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Notif extends StatefulWidget {
  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  final TextEditingController _controllerSearch = TextEditingController();

  void _onNotifPressed() {
    FocusScope.of(context).requestFocus(new FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) => _controllerSearch.clear());
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InfoScreen(
          title: 'Trường Đại học Giao thông vận tải chia sẻ khó khăn cùng đồng bào bị ảnh hưởng do thiên tai, lũ lụt',
          description: 'dd/mm/yyyy',
          iconData: Icons.notifications_active_outlined,
          onDeletePressed: _deleteNotif,
          onEditPressed: _editNotif,
        );
      },
    );
  }

  void _addNotif() {
    FocusScope.of(context).requestFocus(FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) => _controllerSearch.clear());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditNoti(
            onCancelPressed: _onCancelPressed,
            onOkPressed: _onOkPressed,
          ),
        );
      },
    );
  }

  Future<void> _deleteNotif() async {
    //
  }

  void _editNotif() {
    _addNotif();
  }

  Future<void> _onCancelPressed() async {
    Navigator.pop(context);
  }

  Future<void> _onOkPressed() async {
    //
  }

  Future<void> _onNotifRefresh() async {
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
            AppLocalizations.of(context)!.notif,
            style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
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
                decoration: InputDecoration(
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
              RefreshIndicator(
                onRefresh: _onNotifRefresh,
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: Radius.circular(8),
                  child: SingleChildScrollView(
                    child: InfoCard(
                      title: 'Trường Đại học Giao thông vận tải chia sẻ khó khăn cùng đồng bào bị ảnh hưởng do thiên tai, lũ lụt',
                      description: 'dd/mm/yyyy',
                      iconData: Icons.notifications_active_outlined,
                      onPressed: _onNotifPressed,
                    )
                  )
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: CircleBorder(),
        child: Icon(Icons.add_rounded, color: Colors.white),
        onPressed: _addNotif,
      ),
    );
  }
}
