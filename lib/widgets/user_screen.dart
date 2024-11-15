import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:student_management/services/account_service.dart';
import 'package:student_management/widgets/widget.dart';
import '../managers/manager.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class UserScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String userRole;

  const UserScreen({Key? key, this.userData, required this.userRole}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _accountService = AccountService();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  final List<String> sexItems = [
    'Nam',
    'Nữ',
  ];
  String currentUserSex = 'Nam';

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    if (widget.userData != null) {
      _controllerName.text = widget.userData?['name'] ?? '';
      _controllerCountry.text = widget.userData?['country'] ?? '';
      _controllerAddress.text = widget.userData?['address'] ?? '';
      _controllerPhone.text = widget.userData?['phone'] ?? '';

      // Cập nhật giới tính
      if (widget.userData?['gender'] != null) {
        setState(() {
          currentUserSex = widget.userData!['gender'];
        });
      }

      // Cập nhật ngày sinh
      if (widget.userData?['dateOfBirth'] != null) {
        setState(() {
          _selectedDate =  DateFormat(FormatDate.dateOfBirth).parse(widget.userData!['dateOfBirth']);
        });
      }
    }
  }

  Future<void> editUserInfo() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    String name = _controllerName.text.trim();
    String gender = currentUserSex;
    String dateOfBirth = DateFormat(FormatDate.dateOfBirth).format(_selectedDate);
    String country = _controllerCountry.text.trim();
    String address = _controllerAddress.text.trim();
    String phone = _controllerPhone.text.trim();

    if (name.isEmpty || gender.isEmpty || dateOfBirth.isEmpty || country.isEmpty || address.isEmpty || phone.isEmpty){
      await CustomDialogUtil.showDialogNotification(
        context,
        content: AppLocalizations.of(context)!.emptyInfo,
      );
    } else if (!Validator.validatePhone(phone)) {
      await CustomDialogUtil.showDialogNotification(
        context,
        content: 'Sai định dạng SĐT',
      );
    } else {
      try {
        await _accountService.editUserInfo(
            widget.userRole,
            widget.userData!['email'],
            name,
            gender,
            dateOfBirth,
            country,
            address,
            phone
        );

        await CustomDialogUtil.showDialogNotification(
          context,
          content: 'Sửa thông tin thành công',
          onSubmit: () => Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
                (Route<dynamic> route) => false,
          )
        );
      } catch (e) {
        print(e);
        await CustomDialogUtil.showDialogNotification(
          context,
          content: 'Sửa thông tin thất bại',
        );
      }
    }
  }

  void _showDatePicker() {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: ScrollDatePicker(
            selectedDate: _selectedDate,
            locale: Locale('en'),
            onDateTimeChanged: (DateTime value) {
              setState(() {
                _selectedDate = value;
              });
            },
          ),
        );
      },
    );
  }

  void _onChangePasswordPressed() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ChangePassword(userData: widget.userData),
        );
      },
    );
  }

  Future<void> _onCancelPressed() async {
    Navigator.pop(context);
  }

  Future<void> _onOkPressed() async {
    editUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          TextField(
            controller: _controllerName,
            cursorColor: Colors.black87,
            keyboardType: TextInputType.name,
            style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              labelText: AppLocalizations.of(context)!.fullName,
              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
              hintText: AppLocalizations.of(context)!.fullName,
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
            value: currentUserSex,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            items: sexItems.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              ),
            )).toList(),
            onChanged: (value) {
              currentUserSex = value!;
            },
            buttonStyleData: ButtonStyleData(padding: EdgeInsets.only(right: 8)),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
              iconSize: 30,
            ),
            dropdownStyleData: DropdownStyleData(
              offset: Offset(0, -5),
              elevation: 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: _showDatePicker,
            child: Container(
              height: 53,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 13),
                  Text(
                    DateFormat(FormatDate.dateOfBirth).format(_selectedDate),
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
                  ),
                  Spacer(),
                  Icon(Icons.date_range_rounded, color: Colors.black87,),
                  SizedBox(width: 13),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _controllerCountry,
            cursorColor: Colors.black87,
            keyboardType: TextInputType.streetAddress,
            style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              labelText: AppLocalizations.of(context)!.country,
              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
              hintText: AppLocalizations.of(context)!.country,
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
            controller: _controllerAddress,
            cursorColor: Colors.black87,
            keyboardType: TextInputType.streetAddress,
            style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              labelText: AppLocalizations.of(context)!.address,
              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
              hintText: AppLocalizations.of(context)!.address,
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
            controller: _controllerPhone,
            cursorColor: Colors.black87,
            keyboardType: TextInputType.phone,
            style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              labelText: AppLocalizations.of(context)!.phone,
              labelStyle: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font),
              hintText: AppLocalizations.of(context)!.phone,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              minimumSize: Size(double.infinity, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            onPressed: _onChangePasswordPressed,
            child: Text(
                AppLocalizations.of(context)!.changePass,
                style: TextStyle(color: Colors.black87, fontFamily: Fonts.display_font, fontSize: 16)
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
                onPressed: _onCancelPressed,
                child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(130, 30),
                  backgroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _onOkPressed,
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
    );
  }
}
