import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../managers/manager.dart';
import '../widgets/widget.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController _controllerSearch = TextEditingController();

  void _accountPressed() {
    FocusScope.of(context).requestFocus(new FocusNode());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerSearch.clear());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InfoScreen(
          title: 'Ten nguoi dung',
          description: 'Loai tai khoan',
          info: 'nguoi giu lang',
          iconData: Icons.account_circle_outlined,
          leftButtonTitle: AppLocalizations.of(context)!.delete,
          rightButtonTitle: AppLocalizations.of(context)!.resetPassword,
          onLeftPressed: _deleteAccount,
          onRightPressed: _onResetPassword,
        );
      },
    );
  }

  void _addAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerSearch.clear());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddAccount(),
        );
      },
    );
  }

  Future<void> _deleteAccount() async {}

  Future<void> _onResetPassword() async {
    //
  }

  Future<void> _onAccountRefresh() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              AppLocalizations.of(context)!.account,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: Fonts.display_font,
                  color: Colors.black),
            ),
            centerTitle: true,
          )),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          child: Column(
            children: [
              TextFormField(
                controller: _controllerSearch,
                cursorColor: Colors.black87,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: Fonts.display_font),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  hintText: AppLocalizations.of(context)!.search,
                  hintStyle: TextStyle(
                      color: Colors.black26, fontFamily: Fonts.display_font),
                  prefixIcon: const Icon(Icons.search_rounded),
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
              RefreshIndicator(
                onRefresh: _onAccountRefresh,
                child: Scrollbar(
                    thumbVisibility: true,
                    radius: Radius.circular(8),
                    child: SingleChildScrollView(
                      child: InfoCard(
                          title: "Ten nguoi dung 2",
                          description: "Loại người dùng",
                          iconData: Icons.account_circle_outlined,
                          onPressed: _accountPressed),
                    )),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        elevation: 0,
        shape: CircleBorder(),
        child: Icon(Icons.add_rounded, color: Colors.white),
        onPressed: _addAccount,
      ),
    );
  }
}
