import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../managers/manager.dart';
import '../services/service.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;

  Future<void> _signIn() async {
    // Hiển thị loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 30.0,
          ),
        );
      },
    );

    // Lấy giá trị từ TextEditingController
    String email = _controllerUsername.text.trim();
    String password = _controllerPassword.text;

    // Đăng nhập
    User? user = await _authService.signInWithEmailAndPassword(context, email, password);
    Navigator.pop(context);
    if (user != null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/utc_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 30, 40, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.app_name,
                          style: TextStyle(color: Colors.black87, fontSize: 35, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.account_balance_rounded, size: 30)
                      ],
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _controllerUsername,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email,
                        labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black87, width: 2.0),
                        ),
                      ),
                      onEditingComplete: () => _focusNodePassword.requestFocus(),
                      //Todo: check email
                      // validator: (String? value) {
                      //   // if (value == null || value.isEmpty) {
                      //   //   return "Please enter username.";
                      //   // } else if (!_boxAccounts.containsKey(value)) {
                      //   //   return "Username is not registered.";
                      //   // }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _controllerPassword,
                      focusNode: _focusNodePassword,
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                        prefixIcon: const Icon(Icons.lock_outline),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black87, width: 2.0),
                        ),

                      ),
                      //Todo: Check password
                      // validator: (String? value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Please enter password.";
                      //   }
                      //   // else if (value != _boxAccounts.get(_controllerUsername.text)) {
                      //   //   return "Wrong password.";
                      //   // }
                      //
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 28),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _signIn,
                          child: Text(
                              AppLocalizations.of(context)!.login,
                              style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
