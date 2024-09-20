import 'package:flutter/material.dart';
import '../managers/manager.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoScreen extends StatefulWidget {
  final String title;
  final String description;
  final IconData iconData;
  final Color? bgColor;
  final Color? elColor;
  final VoidCallback onDeletePressed;
  final VoidCallback onEditPressed;

  const InfoScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.iconData,
    this.bgColor,
    this.elColor,
    required this.onDeletePressed,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(widget.iconData, size: 30, color: widget.elColor ?? Colors.black87),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.title.length > 25
                    ? TextScroll(
                      widget.title,
                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                      pauseBetween: const Duration(seconds: 2),
                      fadedBorder: true,
                      fadeBorderSide: FadeBorderSide.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.elColor ?? Colors.black87,
                      ),
                    )
                    : Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.elColor ?? Colors.black87,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(fontFamily: Fonts.display_font, fontSize: 13, color: widget.elColor ?? Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                'Trong những ngày vừa qua, cơn bão số 3 (tên quốc tế là Yagi) với cường độ rất mạnh đã tàn phá và gây thiệt hại nặng nề cho các tỉnh miền Bắc nước ta. Trong khó khăn hoạn nạn, tinh thần tương thân tương ái, lá lành đùm lá rách của dân tộc ta trở nên mạnh mẽ hơn bao giờ hết. Ngay khi nắm được thông tin về thiệt hại do bão lũ gây ra, Trường Đại học Giao thông vận tải đã tích cực hưởng ứng, cũng như triển khai kịp thời nhiều hoạt động có ý nghĩa nhằm góp phần động viên, làm vơi bớt những đau thương mất mát, giúp nhân dân vùng bị bão lũ, thiên tai nhanh chóng ổn định đời sống, khôi phục sản xuất.',
                style: TextStyle(fontSize: 16, fontFamily: Fonts.display_font),
                softWrap: true,
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: widget.onDeletePressed,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_outlined, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                        AppLocalizations.of(context)!.delete,
                        style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                    ),
                    SizedBox(width: 7),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: widget.onEditPressed,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                        AppLocalizations.of(context)!.edit,
                        style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                    ),
                    SizedBox(width: 7),
                  ],
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
