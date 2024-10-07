import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:student_management/widgets/info_card.dart';
import 'package:student_management/widgets/schedule_in_day.dart';
import 'package:student_management/widgets/schedule_subject.dart';
import '../managers/manager.dart';

class Classname extends StatefulWidget {
  const Classname({super.key});

  @override
  State<Classname> createState() => _ClassnameState();
}

class _ClassnameState extends State<Classname> {
  final TextEditingController _controllerContentClass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.nameClass,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: Fonts.display_font,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
          )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                maxLines: 3,
                minLines: 3,
                controller: _controllerContentClass,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: Fonts.display_font),
                decoration: InputDecoration(
                    hintText: "Nội dung lớp học",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.teacher,
                      style: TextStyle(
                          fontFamily: Fonts.display_font,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Spacer()
                  ],
                ),
              ),
              InfoCard(
                  title: "title",
                  description: "description",
                  iconData: Icons.school_outlined,
                  onPressed: () {}),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.student,
                      style: TextStyle(
                          fontFamily: Fonts.display_font,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Spacer()
                  ],
                ),
              ),
              InfoCard(
                  title: "title",
                  description: "description",
                  iconData: Icons.school_outlined,
                  onPressed: () {}),
              InfoCard(
                  title: "title",
                  description: "description",
                  iconData: Icons.school_outlined,
                  onPressed: () {}),
              InfoCard(
                  title: "title",
                  description: "description",
                  iconData: Icons.school_outlined,
                  onPressed: () {}),
              InfoCard(
                  title: "title",
                  description: "description",
                  iconData: Icons.school_outlined,
                  onPressed: () {}),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          height: 60,
          color: Colors.white70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 30),
                    backgroundColor: Colors.teal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "diem",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: Fonts.display_font,
                        fontSize: 16),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 30),
                    backgroundColor: Colors.teal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.edit,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: Fonts.display_font,
                        fontSize: 16),
                  )),
            ],
          )),
    );
  }
}
