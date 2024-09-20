import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import '../managers/manager.dart';

class InfoCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData iconData;
  final Color? bgColor;
  final Color? elColor;
  final Function onPressed;

  const InfoCard({
    Key? key,
    required this.title,
    required this.description,
    required this.iconData,
    this.bgColor,
    this.elColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed(),
      child: Container(
        width: double.infinity,
        height: 90,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: widget.bgColor ?? Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
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
                          color: widget.elColor ?? Colors.black87
                        ),
                      )
                          : Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: Fonts.display_font,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.elColor ?? Colors.black87
                        ),
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontFamily: Fonts.display_font,
                          fontSize: 13,
                          color: widget.elColor ?? Colors.black87
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
