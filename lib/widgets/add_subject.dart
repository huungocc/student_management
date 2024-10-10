import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../managers/manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddSubject extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onOkPressed;

  const AddSubject({
    Key? key,
    required this.onCancelPressed,
    required this.onOkPressed,
  }) : super(key: key);


  @override
  State<AddSubject> createState() => _AddSubject();
}

class _AddSubject extends State<AddSubject> {
  final TextEditingController _controllerSubjectName = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();
  final TextEditingController _controllerNumberOfDays = TextEditingController();

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
              controller: _controllerSubjectName,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.subjectName,
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
              isExpanded: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.subjectCategory,
                labelStyle: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: _loaimon.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                ),
              )).toList(),
              onChanged: (value) {
                //
              },
              buttonStyleData: ButtonStyleData(padding: EdgeInsets.only(right: 8)),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black87,
                ),
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
            DropdownButtonFormField2<String>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.numberOfCredit,
                labelStyle: TextStyle(fontSize: 16,color: Colors.black87, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 11),
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
                controller: _controllerContent,
                cursorColor: Colors.black87,
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                  hintText: 'Mô tả',
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
              controller: _controllerNumberOfDays,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.numberOfDays,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Tổng số buổi",
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
