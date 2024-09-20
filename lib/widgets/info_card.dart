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
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, fontFamily: Fonts.display_font, fontWeight: FontWeight.bold, color: widget.elColor ?? Colors.black87),
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
          ),
        ),
      ),
    );;
  }
}
