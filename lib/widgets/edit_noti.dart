import 'package:flutter/material.dart';
import '../managers/manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditNoti extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onOkPressed;

  const EditNoti({
    Key? key,
    required this.onCancelPressed,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  State<EditNoti> createState() => _EditNotiState();
}

class _EditNotiState extends State<EditNoti> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

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
                  onPressed: widget.onCancelPressed,
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
                  onPressed: widget.onOkPressed,
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
