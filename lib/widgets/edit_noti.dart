import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../managers/manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/service.dart';
import 'widget.dart';

class EditNoti extends StatefulWidget {
  final bool isAddNotif;
  final Map<String, dynamic>? notifData;

  const EditNoti({super.key, required this.isAddNotif, this.notifData});

  @override
  State<EditNoti> createState() => _EditNotiState();
}

class _EditNotiState extends State<EditNoti> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  final _notifService = NotifService();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    if (widget.notifData != null) {
      _controllerTitle.text = widget.notifData?['title'] ?? '';
      _controllerDescription.text = widget.notifData?['content'] ?? '';
    }
  }

  Future<void> addNotif() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String title = _controllerTitle.text.trim();
    String content = _controllerDescription.text.trim();
    String datetime = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    if(title.isEmpty || content.isEmpty) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    } else if (title.length > 255) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.error255,
      );
    }
    else {
      await CustomDialogUtil.showDialogConfirm(
          context,
          content: AppLocalizations.of(context)!.addNotif + title,
          onSubmit: () async {
            try {
              await _notifService.addNotification(title, content, datetime);

              await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.addNotifSuccess,
                  onSubmit: () => Navigator.pop(context)
              );
            } catch (e) {
              print(e);
              if (e.toString().contains("Thông báo với tiêu đề này đã tồn tại")) {
                await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.existNotif,
                );
              } else {
                await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.addNotifFail,
                );
              }
            }
          }
      );
    }
  }

  Future<void> editNotif() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String title = _controllerTitle.text.trim();
    String content = _controllerDescription.text.trim();
    String datetime = widget.notifData?['datetime'];

    if(title.isEmpty || content.isEmpty) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    }
    else {
      await CustomDialogUtil.showDialogConfirm(
          context,
          content: AppLocalizations.of(context)!.editNotif + title,
          onSubmit: () async {
            try {
              await _notifService.editNotification(title, content, datetime);

              await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.editNotifSuccess,
                  onSubmit: () => Navigator.pop(context)
              );
            } catch (e) {
              print(e);
              await CustomDialogUtil.showDialogNotification(
                context,
                content: AppLocalizations.of(context)!.editNotifFail,
              );
            }
          }
      );
    }
  }

  void onCancelPressed(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            TextField(
              controller: _controllerTitle,
              cursorColor: Colors.black87,
              enabled: widget.isAddNotif,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 2,
              scrollPhysics: ClampingScrollPhysics(),
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.title,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.title,
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
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

            Container(
              child: TextField(
                controller: _controllerDescription,
                cursorColor: Colors.black87,
                keyboardType: TextInputType.multiline,
                minLines: 8,
                maxLines: 8,
                scrollPhysics: ClampingScrollPhysics(),
                style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.content,
                  labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                  hintText: AppLocalizations.of(context)!.content,
                  hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
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
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 30),
                    backgroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: onCancelPressed,
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 30),
                    backgroundColor: Colors.teal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: widget.isAddNotif ? addNotif : editNotif,
                  child: Text(
                      AppLocalizations.of(context)!.ok,
                    style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
