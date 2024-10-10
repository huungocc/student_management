import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../managers/manager.dart';

class ChangePassword extends StatefulWidget {
  final VoidCallback changePassword;

  const ChangePassword({super.key, required this.changePassword});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _controllerOldPassword = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controllerOldPassword,
            cursorColor: Colors.black87,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureOldPassword,
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
                      _obscureOldPassword = !_obscureOldPassword;
                    });
                  },
                  icon: _obscureOldPassword
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
          TextField(
            controller: _controllerNewPassword,
            cursorColor: Colors.black87,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureNewPassword,
            style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              labelText: 'Mật khẩu mới',
              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
              hintText: 'Mật khẩu mới',
              hintStyle: TextStyle(color: Colors.black26, fontFamily: Fonts.display_font),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                  icon: _obscureNewPassword
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
          TextField(
            controller: _controllerConfirmPassword,
            cursorColor: Colors.black87,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureConfirmPassword,
            style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              labelText: 'Xác nhận mật khẩu mới',
              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
              hintText: 'Xác nhận mật khẩu mới',
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              elevation: 0,
              minimumSize: Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: widget.changePassword,
            child: Text(
              'Đổi mật khẩu',
              style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
            ),
          ),
        ],
      ),
    );
  }
}
