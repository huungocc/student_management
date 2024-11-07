import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

import '../managers/manager.dart';
import '../services/service.dart';

class Score extends StatefulWidget {
  final String className;

  const Score({super.key, this.className = ''});

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  final AuthService _authService = AuthService();
  final ClassService _classService = ClassService();
  bool isTeacher = false;

  final List<Map<String, String>> _scores = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _loadScoreData();
  }

  Future<void> _checkPermission() async {
    isTeacher = await _authService.hasPermission([UserRole.teacher]);
    setState(() {});
  }

  Future<void> _loadScoreData() async {
    final scores = await _classService.loadStudentScores(widget.className);
    setState(() {
      _scores.clear();
      _scores.addAll(List<Map<String, String>>.from(scores));
    });
    print(scores);
  }

  Future<void> _updateStudentScore(int index, String process, String exam) async {
    final student = _scores[index];
    await _classService.updateStudentScore(widget.className, student['email']!, process, exam);
    setState(() {
      _scores[index]['process'] = process;
      _scores[index]['exam'] = exam;
    });
  }

  ExpandableTableCell _buildCell(String content, {Color? backgroundColor, Color? textColor, FontWeight? fontWeight}) {
    return ExpandableTableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          border: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontSize: 14,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  ExpandableTableCell _buildHeaderCell(String content) {
    return _buildCell(
      content,
      backgroundColor: Colors.blueGrey[50],
      textColor: Colors.black,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildExpandableTable() {
    return ExpandableTable(
      key: UniqueKey(),
      firstHeaderCell: _buildHeaderCell('Họ tên'),
      headers: [
        ExpandableTableHeader(cell: _buildHeaderCell('QT')),
        ExpandableTableHeader(cell: _buildHeaderCell('Thi')),
        ExpandableTableHeader(cell: _buildHeaderCell('TK')),
        ExpandableTableHeader(cell: _buildHeaderCell('TT')),
      ],
      rows: List.generate(_scores.length, (index) {
        final score = _scores[index];
        return ExpandableTableRow(
          firstCell: _buildCell(score['email']!),
          cells: [
            isTeacher
                ? _buildEditableCell(index, score['process']!, (value) {
              score['process'] = value;
            })
                : _buildCell(score['process']!),
            isTeacher
                ? _buildEditableCell(index, score['exam']!, (value) {
              score['exam'] = value;
            })
                : _buildCell(score['exam']!),
            _buildCell(score['finalScore']!),
            _buildCell(score['status']!),
          ],
        );
      }),
      headerHeight: 40,
      defaultsRowHeight: 60,
      defaultsColumnWidth: 60,
      firstColumnWidth: 150,
      visibleScrollbar: true,
    );
  }

  ExpandableTableCell _buildEditableCell(int index, String initialValue, Function(String) onChanged) {
    return ExpandableTableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: TextEditingController(text: initialValue),
          onChanged: (value) {
            onChanged(value);
            _updateStudentScore(index, value, value);
          },
          decoration: const InputDecoration(border: InputBorder.none),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Điểm',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(isTeacher ? Icons.edit_outlined : Icons.edit),
              onPressed: () {
                setState(() {
                  isTeacher = !isTeacher;
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _buildExpandableTable(),
      ),
      bottomNavigationBar: Visibility(
        visible: isTeacher,
        child: BottomAppBar(
          height: 60,
          color: Colors.white70,
          child: Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(130, 30),
                backgroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                setState(() {
                  isTeacher = !isTeacher;
                });
              },
              child: Text(
                "OK",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
