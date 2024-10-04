import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAccount extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onOkPressed;

  const AddAccount({
    Key? key,
    required this.onCancelPressed,
    required this.onOkPressed,
  }) : super(key: key);


  @override
  State<AddAccount> createState() => _EditNotiState();
}

class _EditNotiState extends State<AddAccount> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String> _accountType = ['sinh vien', 'giang vien', 'admin'];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            TextField(
              controller: _controllerEmail,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,

              style: TextStyle(fontSize: 16,
                  color: Colors.black87,
                  fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                    color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: "Email",
                hintStyle: TextStyle(
                    color: Colors.black26, fontFamily: Fonts.display_font),
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
              controller: _controllerPassword,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,

              style: TextStyle(fontSize: 16,
                  color: Colors.black87,
                  fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                labelStyle: TextStyle(
                    color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.password,
                hintStyle: TextStyle(
                    color: Colors.black26, fontFamily: Fonts.display_font),
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
              controller: _controllerConfirmPassword,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,

              style: TextStyle(fontSize: 16,
                  color: Colors.black87,
                  fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.passwordConfirm,
                labelStyle: TextStyle(
                    color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.passwordConfirm,
                hintStyle: TextStyle(
                    color: Colors.black26, fontFamily: Fonts.display_font),
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
                labelText: AppLocalizations.of(context)!.accountType,
                labelStyle: TextStyle(fontSize: 16,
                    color: Colors.black87,
                    fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.accountType,
                hintStyle: TextStyle(
                    color: Colors.black26, fontFamily: Fonts.display_font),
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

              items: _accountType.map((item) =>
                  DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 18,
                          color: Colors.black87,
                          fontFamily: Fonts.display_font),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(400, 30),
                backgroundColor: Colors.indigo,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: widget.onOkPressed,
              child: Text(
                  AppLocalizations.of(context)!.create,
                  style: TextStyle(color: Colors.white,
                      fontFamily: Fonts.display_font,
                      fontSize: 16)
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
