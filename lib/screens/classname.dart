import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';

class ClassName extends StatefulWidget {
  const ClassName({super.key});

  @override
  State<ClassName> createState() => _ClassNameState();
}

class _ClassNameState extends State<ClassName> {
  final AuthService _authService = AuthService();
  bool isAdmin = false;
  final TextEditingController _controllerContentClass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission(['admin']);
    setState(() {});
  }

  void _onEditClassPressed() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Tên lớp học',
            style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        )),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15.0,right: 15),
        child: Column(
          children: [
            TextFormField(
              maxLines: 3,
              minLines: 3,
              controller: _controllerContentClass,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: Fonts.display_font),
              decoration: InputDecoration(
                hintText: "Nội dung lớp học",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                )
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.white70,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(130, 30),
                  backgroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Điểm",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: Fonts.display_font,
                      fontSize: 16),
                )
              ),
            ),
            Visibility(
              visible: isAdmin,
              child: SizedBox(width: 10)
            ),
            Visibility(
              visible: isAdmin,
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 30),
                    backgroundColor: Colors.orange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _onEditClassPressed,
                  child: Text(
                    AppLocalizations.of(context)!.edit,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: Fonts.display_font,
                        fontSize: 16),
                  )),
              ),
            ),
          ],
        )),
    );
  }
}
