import 'package:flutter/material.dart';

import '../managers/manager.dart';

class FunctionCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color? bgColor;
  final Color? elColor;
  final Function onPressed;

  const FunctionCard({
    Key? key,
    required this.title,
    required this.iconData,
    this.bgColor,
    this.elColor,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        height: MediaQuery.of(context).size.width * 0.6,
        width: MediaQuery.of(context).size.width * 0.455,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: bgColor ?? Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 70, color: elColor ?? Colors.black87),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: Fonts.display_font,
                        fontWeight: FontWeight.bold,
                        color: elColor ?? Colors.black87
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
