import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../managers/manager.dart';
import '../widgets/widget.dart';


class AddClasses extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onOkPressed;

  const AddClasses({
    Key? key,
    required this.onCancelPressed,
    required this.onOkPressed,
  }) : super(key: key);


  @override
  State<AddClasses> createState() => _AddClasses();
}

class _AddClasses extends State<AddClasses> {
  final TextEditingController _controllerClassName = TextEditingController();
  final TextEditingController _controllershift = TextEditingController();
  final TextEditingController _controllerCLassroom = TextEditingController();
  final TextEditingController _controllerTimeStart = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final List<String> _tinchi = ['1', '2', '3'];
    final List<String> _loaimon = ['Đại cương', 'Chuyên ngành'];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            TextField(
              controller: _controllerClassName,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nameClass,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.subjectName,
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
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
            DropdownButtonFormField2<String>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.subject,
                labelStyle: TextStyle(fontSize: 16,color: Colors.black87, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 11,horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: _tinchi.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 18, color: Colors.black87, fontFamily: Fonts.display_font),
                ),
              )).toList(),
              onChanged: (value) {
                //
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
                iconSize: 30,
              ),
              dropdownStyleData: DropdownStyleData(
                offset: Offset(0, -5),
                elevation: 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[300],
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            SizedBox(height: 15),
            Container(
              child: TextField(
                controller: _controllerTimeStart,
                cursorColor: Colors.black87,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.timeStart,
                  labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                  hintText: AppLocalizations.of(context)!.timeStart,
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
            TextField(
              controller: _controllerCLassroom,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: "Các buổi trong tuần,các ca",
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Các buổi trong tuần,các ca",
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
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
            TextField(
              controller: _controllershift,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.classroom,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.classroom,
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
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
            Row(

              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 50),
                    backgroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: widget.onCancelPressed,
                  child: Text(
                      AppLocalizations.of(context)!.teacher,
                      style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 50),
                    backgroundColor: Colors.teal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: widget.onOkPressed,
                  child: Text(
                      AppLocalizations.of(context)!.student,
                      style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(

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
