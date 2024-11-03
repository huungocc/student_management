import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';

class Classes extends StatefulWidget {
  const Classes({super.key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final AuthService _authService = AuthService();
  bool isAdmin = false;

  final TextEditingController _controllerSearch = TextEditingController();

  final List<String> _monhoc = ['mon 1', 'mon 2', 'mon 3'];

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission([UserRole.admin]);
    setState(() {});
  }

  void _onClassesPressed(){
    Navigator.pushNamed(context, Routes.classname);
  }

  void _addClass(){
    FocusScope.of(context).requestFocus(FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) => _controllerSearch.clear());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddClasses(
            onCancelPressed: _onCancelPressed,
            onOkPressed: _onOkPressed,
            onAddMemberPressed: _onAddMemberPressed,
          ),
        );
      },
    );
  }

  void _onAddMemberPressed() {
    //
  }

  void _onCancelPressed(){
    Navigator.pop(context);
  }

  Future<void> _onOkPressed() async{

  }

  Future<void> _deleteSubject() async {
    //
  }

  Future<void> _onClassesRefresh() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.classes,
            style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        child: Column(
          children: [
            SizedBox(height: 15),
            DropdownButtonFormField2<String>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.chooseSubject,
                labelStyle: TextStyle(fontSize: 16,color: Colors.black87, fontFamily: Fonts.display_font),
                contentPadding: EdgeInsets.symmetric(vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: _monhoc.map((item) => DropdownMenuItem<String>(
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
            RefreshIndicator(
              onRefresh: _onClassesRefresh,
              child: Scrollbar(
                thumbVisibility: true,
                radius: Radius.circular(8),
                child: SingleChildScrollView(
                  child: InfoCard(
                    title: 'Toan',
                    description: 'Dai Cuong',
                    iconData: Icons.school_outlined,
                    onPressed: _onClassesPressed,
                  )
                )
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          elevation: 0,
          shape: CircleBorder(),
          child: Icon(Icons.add_rounded, color: Colors.white),
          onPressed: _addClass,
        ),
      ),
    );
  }
}
