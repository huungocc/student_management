import 'package:flutter/material.dart';
import '../managers/manager.dart';
import 'package:text_scroll/text_scroll.dart';

class AccountInfoScreen extends StatefulWidget {
  final String title;
  final String description;
  final String info;
  final IconData iconData;
  final Color? bgColor;
  final Color? elColor;
  final String buttonTitle;
  final VoidCallback? onPressed;

  const AccountInfoScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.info,
    required this.iconData,
    this.bgColor,
    this.elColor,
    this.buttonTitle = '',
    this.onPressed,
  }) : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<AccountInfoScreen> {
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
                        fontFamily: Fonts.display_font,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.elColor ?? Colors.black87,
                      ),
                    )
                    : Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: Fonts.display_font,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.elColor ?? Colors.black87,
                      ),
                    ),
                    Text(
                      widget.description,
                      textAlign: TextAlign.left,
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
                widget.info,
                style: TextStyle(fontSize: 16, fontFamily: Fonts.display_font),
                softWrap: true,
              ),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: widget.onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings_outlined, color: Colors.white),
                SizedBox(width: 10),
                Text(
                    widget.buttonTitle,
                    style: TextStyle(color: Colors.white, fontFamily: Fonts.display_font, fontSize: 16)
                ),
                SizedBox(width: 7),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
