import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  State<AddSubject> createState() => _EditNotiState();
}

class _EditNotiState extends State<AddSubject> {
  final TextEditingController _controllerSubjectName = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();
  final TextEditingController _controllerNumberOfDays = TextEditingController();
  final TextEditingController _controllerDaysInWeek = TextEditingController();
  @override
  Widget build(BuildContext context) {


    final List<String> _tinchi = ['1', '2', '3', '4'];



    final List<String> _loaimon = ['dai cuong', 'chuyen nganh', 'thuc hanh', 'ly thuyet'];



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
                labelText: "Tên Môn Học",
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Tên Môn Học",
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
            DropdownButtonFormField2<String>(


              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Loại Môn",
                labelStyle: TextStyle(fontSize: 16,color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Loại Môn",
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
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
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


              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Số Tín Chỉ",
                labelStyle: TextStyle(fontSize: 16,color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Số Tín Chỉ",
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
            TextField(
              controller: _controllerNumberOfDays,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: "Tổng số buổi",
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Tổng số buổi",
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
            TextField(
              controller: _controllerDaysInWeek,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: "Số buổi trong 1 tuần",
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Số buổi trong 1 tuần",
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
