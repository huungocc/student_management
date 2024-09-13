import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../managers/manager.dart';

class SettingScreen extends StatelessWidget {
  final VoidCallback onLogOut;

  const SettingScreen({
    Key? key,
    required this.onLogOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> languageItems = [
      'English',
      'Tiếng Việt',
    ];
    LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);
    String currentLanguage = localeProvider.locale?.languageCode == 'en' ? 'English' : 'Tiếng Việt';

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              children: [
                DropdownButtonFormField2<String>(
                  value: currentLanguage,
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  items: languageItems.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                    ),
                  )).toList(),
                  onChanged: (value) {
                    if (value == 'English') {
                      localeProvider.setLocale(Locale('en'));
                    } else if (value == 'Tiếng Việt') {
                      localeProvider.setLocale(Locale('vi'));
                    }
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
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    elevation: 0,
                    minimumSize: const Size.fromHeight(60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onLogOut,
                  child: Text(
                      AppLocalizations.of(context)!.logout,
                      style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}