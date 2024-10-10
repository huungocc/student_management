import 'package:flutter/material.dart';
import 'package:student_management/widgets/widget.dart';
class ScheduleSubject extends StatefulWidget {
  const ScheduleSubject(
      {Key? key}
      ): super(key: key);

  @override
  State<ScheduleSubject> createState() => _ScheduleSubjectState();
}

class _ScheduleSubjectState extends State<ScheduleSubject> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.fromLTRB(15, 20, 20, 15),
           child: Column(
             children: [
              Text(
                  "Lịch trong tuần",
                   style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
               ),
              Text("dd/mm/yyyy - dd/mm/yyyy"),
              SizedBox(height: 30),
               ScheduleInDay(
               dayInWeek: 'Thứ 2',
               date: 'dd/mm/yyyy',
               loadSchedule: () {},
             )
         ],
        ),
       ),
      ),
    );
  }
}
