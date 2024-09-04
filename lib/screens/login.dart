import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../managers/manager.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  bool isVisible = false;

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
              height: isVisible == true ? 300 : 400,
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
                child: Stack(
                  children: [
                    Visibility(
                      visible: isVisible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: TextStyle(color: Colors.black87, fontSize: 28, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Icon(Icons.password_rounded, size: 30)
                            ],
                          ),
                          const SizedBox(height: 35),
                          TextFormField(
                            controller: _controllerUsername,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.userName,
                              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                              prefixIcon: const Icon(Icons.person_outline_outlined),
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
                            // validator: (String? value) {
                            //   // if (value == null || value.isEmpty) {
                            //   //   return "Please enter username.";
                            //   // } else if (!_boxAccounts.containsKey(value)) {
                            //   //   return "Username is not registered.";
                            //   // }
                            //   return null;
                            // },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              // Todo: Send request
                            },
                            child: Text(
                                AppLocalizations.of(context)!.send,
                                style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font)
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text(
                                    AppLocalizations.of(context)!.backToLogin,
                                    style: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font)),
                                onPressed: () {
                                  setState(() {
                                    isVisible = false;
                                  });
                                },
                              )
                          ),
                        ],
                      )
                    ),
                    Visibility(
                      visible: !isVisible,
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
                              labelText: AppLocalizations.of(context)!.userName,
                              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
                              prefixIcon: const Icon(Icons.person_outline_outlined),
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
                            // validator: (String? value) {
                            //   if (value == null || value.isEmpty) {
                            //     return "Please enter password.";
                            //   }
                            //   //Todo: Check password
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
                                onPressed: () {
                                  // Todo: Login
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font)
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font)),
                              onPressed: () {
                                setState(() {
                                  isVisible = true;
                                });
                              },
                            )
                          ),
                        ],
                      ),
                    )
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
