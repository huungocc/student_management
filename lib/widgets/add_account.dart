import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../managers/manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/service.dart';
import 'widget.dart';

class AddAccount extends StatefulWidget {

  @override
  State<AddAccount> createState() => _EditNotiState();
}

class _EditNotiState extends State<AddAccount> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _authService = AuthService();
  String _selectedRole = '';

  Future<void> _signup() async {
    String email = _controllerEmail.text.trim();
    String password = _controllerPassword.text.trim();
    String confirm = _controllerPassword.text.trim();
    String role = '';
    String userID = email.split('@')[0];

    if (email.isNotEmpty && !Validator.validateEmail(email)) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.wrongEmail,
      );
    } else if (password.isNotEmpty && !Validator.validatePassword(password)) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.wrongPassword,
      );
    } else if (confirm != password) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.wrongConfirm,
      );
    } else if (email.isEmpty || password.isEmpty || confirm.isEmpty || _selectedRole.isEmpty) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    } else {
      if (_selectedRole == AppLocalizations.of(context)!.admin) role = UserRole.admin;
      if (_selectedRole == AppLocalizations.of(context)!.teacher) role = UserRole.teacher;
      if (_selectedRole == AppLocalizations.of(context)!.student) role = UserRole.student;
      await CustomDialogUtil.showDialogConfirm(
        context,
        content: 'Tạo tài khoản $_selectedRole\nID: $userID',
        onSubmit: () async {
          await _authService.signUpWithEmailAndPassword(context, email, password, role, userID);
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _accountType = [AppLocalizations.of(context)!.admin, AppLocalizations.of(context)!.teacher, AppLocalizations.of(context)!.student];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            TextFormField(
              controller: _controllerEmail,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.text,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                labelText: AppLocalizations.of(context)!.email,
                labelStyle: TextStyle(
                    color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.email,
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
            TextFormField(
              controller: _controllerPassword,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscurePassword,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                labelText: AppLocalizations.of(context)!.password,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.password,
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: _obscurePassword
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined)),
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
            TextFormField(
              controller: _controllerConfirmPassword,
              cursorColor: Colors.black87,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureConfirmPassword,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                labelText: AppLocalizations.of(context)!.passwordConfirm,
                labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                hintText: AppLocalizations.of(context)!.passwordConfirm,
                hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: _obscureConfirmPassword
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined)),
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
                labelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 11),
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
              items: _accountType
                .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontFamily: Fonts.display_font),
                    ),
                  ))
                .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
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
              onPressed: _signup,
              child: Text(AppLocalizations.of(context)!.create,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: Fonts.display_font,
                      fontSize: 16)),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
