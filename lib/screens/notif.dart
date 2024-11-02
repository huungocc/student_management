import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/manager.dart';
import '../services/service.dart';
import '../widgets/widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Notif extends StatefulWidget {
  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  final AuthService _authService = AuthService();
  final TextEditingController _controllerSearch = TextEditingController();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    isAdmin = await _authService.hasPermission(['admin']);
    setState(() {});
  }

  void _onNotifPressed() {
    //hủy focus vào textfield
    FocusScope.of(context).requestFocus(new FocusNode());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerSearch.clear());
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InfoScreen(
          isAdmin: isAdmin,
          title:
              'Trường Đại học Giao thông vận tải chia sẻ khó khăn cùng đồng bào bị ảnh hưởng do thiên tai, lũ lụt',
          description: 'dd/mm/yyyy',
          info:
              'Trong những ngày vừa qua, cơn bão số 3 (tên quốc tế là Yagi) với cường độ rất mạnh đã tàn phá và gây thiệt hại nặng nề cho các tỉnh miền Bắc nước ta. Trong khó khăn hoạn nạn, tinh thần tương thân tương ái, lá lành đùm lá rách của dân tộc ta trở nên mạnh mẽ hơn bao giờ hết. Ngay khi nắm được thông tin về thiệt hại do bão lũ gây ra, Trường Đại học Giao thông vận tải đã tích cực hưởng ứng, cũng như triển khai kịp thời nhiều hoạt động có ý nghĩa nhằm góp phần động viên, làm vơi bớt những đau thương mất mát, giúp nhân dân vùng bị bão lũ, thiên tai nhanh chóng ổn định đời sống, khôi phục sản xuất.',
          iconData: Icons.notifications_active_outlined,
          leftButtonTitle: AppLocalizations.of(context)!.delete,
          rightButtonTitle: AppLocalizations.of(context)!.edit,
          onLeftPressed: _deleteNotif,
          onRightPressed: _editNotif,
        );
      },
    );
  }

  void _addNotif() {
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
          child: EditNoti(
            onCancelPressed: _onCancelPressed,
            onOkPressed: _onOkPressed,
          ),
        );
      },
    );
  }

  Future<void> _deleteNotif() async {
    //
  }

  void _editNotif() {
    _addNotif();
  }

  Future<void> _onCancelPressed() async {
    Navigator.pop(context);
  }

  Future<void> _onOkPressed() async {
    //
  }

  Future<void> _onNotifRefresh() async {
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
            AppLocalizations.of(context)!.notif,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: Fonts.display_font,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
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
                onRefresh: _onNotifRefresh,
                child: SingleChildScrollView(
                  child: InfoCard(
                  title: 'Trường Đại học Giao thông vận tải chia sẻ khó khăn cùng đồng bào bị ảnh hưởng do thiên tai, lũ lụt',
                  description: 'dd/mm/yyyy',
                  iconData: Icons.notifications_active_outlined,
                  onPressed: _onNotifPressed,
                )),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          backgroundColor: Colors.teal,
          elevation: 0,
          shape: CircleBorder(),
          child: Icon(Icons.add_rounded, color: Colors.white),
          onPressed: _addNotif,
        ),
      ),
    );
  }
}
