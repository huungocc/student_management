import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_management/services/notif_service.dart';
import 'package:student_management/widgets/dialog.dart';
import '../managers/manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditNoti extends StatefulWidget {



  @override
  State<EditNoti> createState() => _EditNotiState();
}

class _EditNotiState extends State<EditNoti> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  final _notifService = NotifService();

  Future<void> _onOkPressed() async {
    String title = _controllerTitle.text.trim();
    String content = _controllerDescription.text.trim();
    String datetime = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    if(title.isEmpty && content.isEmpty)
      {
        await CustomDialogUtil.showDialogNotification(
          context,
            content: 'ban can nhap du thong tin'
        );
      }
    else {
      await _notifService.addNotification(context, title, content, datetime);
    }

  }

 void _onCancelPressed(){
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
                  onPressed: _onCancelPressed,
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
                  onPressed: _onOkPressed,
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
