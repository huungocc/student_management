import 'package:flutter/material.dart';
import 'package:student_management/widgets/widget.dart';

import '../managers/manager.dart';

class ScheduleInDay extends StatelessWidget {
  final String dayInWeek;
  final String date;
  final VoidCallback loadSchedule;

  const ScheduleInDay({
    Key? key,
    required this.dayInWeek,
    required this.date,
    required this.loadSchedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [
              Text(
                dayInWeek,
                style: TextStyle(fontFamily: Fonts.display_font, fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)
              ),
              Spacer(),
              Text(
                date,
                style: TextStyle(fontFamily: Fonts.display_font, fontSize: 16, color: Colors.black87)
              )
            ]
          ),
        ),
        //Todo: ListViewBuilder
        InfoCard(title: "Tên lớp học", description: "101-A2", iconData: Icons.schedule, onPressed: (){}),

      ],
    );
  }
}
