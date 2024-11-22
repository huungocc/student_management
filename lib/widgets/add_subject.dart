import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:student_management/widgets/widget.dart';
import '../managers/manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/service.dart';

class AddSubject extends StatefulWidget {
  final bool isAddSubject;
  final Map<String, dynamic>? subjectData;

  const AddSubject({super.key, required this.isAddSubject, this.subjectData});

  @override
  State<AddSubject> createState() => _AddSubject();
}

class _AddSubject extends State<AddSubject> {
  final _subjectService = SubjectService();

  final TextEditingController _controllerSubjectName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerTotalDays = TextEditingController();

  String _currentCategory = 'Đại cương';
  String _currentCredit = '1';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    if (widget.subjectData != null) {
      _controllerSubjectName.text = widget.subjectData?['title'] ?? '';
      _controllerDescription.text = widget.subjectData?['description'] ?? '';
      _controllerTotalDays.text = widget.subjectData?['totalDays'] ?? '';

      // Cập nhật loại môn
      if (widget.subjectData?['category'] != null) {
        setState(() {
          if (widget.subjectData!['category'] == SubjectType.general) _currentCategory = 'Đại cương';
          if (widget.subjectData!['category'] == SubjectType.major) _currentCategory = 'Chuyên ngành';
        });
      }

      // Cập nhật số tín chỉ
      if (widget.subjectData?['credit'] != null) {
        setState(() {
          _currentCredit = widget.subjectData!['credit'];
        });
      }
    }
  }

  Future<void> addSubject() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String name = _controllerSubjectName.text.trim();
    String description = _controllerDescription.text.trim();
    String totalDays = _controllerTotalDays.text.trim();
    String credit = _currentCredit;
    String category = _currentCategory;

    if (name.isEmpty || description.isEmpty || totalDays.isEmpty || credit.isEmpty || category.isEmpty) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    } else if (name.length > 255 || description.length > 255) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.error255,
      );
    } else if (!Validator.isNumeric(totalDays)) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.errorNumber,
      );
    } else {
      if (category == 'Đại cương') category = SubjectType.general;
      if (category == 'Chuyên ngành') category = SubjectType.major;

      await CustomDialogUtil.showDialogConfirm(
          context,
          content: AppLocalizations.of(context)!.addSubject + name,
          onSubmit: () async {
            try {
              await _subjectService.addSubject(
                  name,
                  category,
                  credit,
                  description,
                  totalDays
              );

              await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.addSubjectSuccess,
                  onSubmit: () => Navigator.pop(context)
              );
            } catch (e) {
              print(e);
              if (e.toString().contains("Môn học đã tồn tại")) {
                await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.existSubject,
                );
              } else {
                await CustomDialogUtil.showDialogNotification(
                  context,
                  content: AppLocalizations.of(context)!.addSubjectFail,
                );
              }
            }
          }
      );
    }
  }

  Future<void> editSubject() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String name = _controllerSubjectName.text.trim();
    String description = _controllerDescription.text.trim();
    String totalDays = _controllerTotalDays.text.trim();
    String credit = _currentCredit;
    String category = _currentCategory;

    if (name.isEmpty || description.isEmpty || totalDays.isEmpty || credit.isEmpty || category.isEmpty) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    } else if (name.length > 255 || description.length > 255) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.error255,
      );
    } else if (!Validator.isNumeric(totalDays)) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.errorNumber,
      );
    } else {
      if (category == 'Đại cương') category = SubjectType.general;
      if (category == 'Chuyên ngành') category = SubjectType.major;

      await CustomDialogUtil.showDialogConfirm(
          context,
          content: AppLocalizations.of(context)!.editSubject + name,
          onSubmit: () async {
            try {
              await _subjectService.editSubject(
                  name,
                  category,
                  credit,
                  description,
                  totalDays
              );

              await CustomDialogUtil.showDialogNotification(
                context,
                content: AppLocalizations.of(context)!.editSubjectSuccess,
              );
            } catch (e) {
              print(e);
              await CustomDialogUtil.showDialogNotification(
                context,
                content: AppLocalizations.of(context)!.editSubjectFail,
              );
            }
          }
      );
    }
  }

  void onCancelPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> listCredit = ['1', '2', '3'];
    final List<String> listCategory = ['Đại cương', 'Chuyên ngành'];
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            TextField(
              controller: _controllerSubjectName,
              enabled: widget.isAddSubject,
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
              value: _currentCategory,
              items: listCategory.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                ),
              )).toList(),
              onChanged: (value) {
                _currentCategory = value!;
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
              value: _currentCredit,
              items: listCredit.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 18, color: Colors.black87, fontFamily: Fonts.display_font),
                ),
              )).toList(),
              onChanged: (value) {
                _currentCredit = value!;
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
                controller: _controllerDescription,
                cursorColor: Colors.black87,
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                  hintText: AppLocalizations.of(context)!.description,
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
              controller: _controllerTotalDays,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.numberOfDays,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.numberOfDays,
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
                  onPressed: widget.isAddSubject ? addSubject : editSubject,
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
