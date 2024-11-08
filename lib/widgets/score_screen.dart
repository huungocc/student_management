import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Map<String, Map<String, String>> _pendingChanges = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _loadScoreData();
  }

  @override
  void dispose() {
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _checkPermission() async {
    isTeacher = await _authService.hasPermission([UserRole.teacher]);
    setState(() {});
  }

  void _calculateFinalScoreAndStatus(Map<String, String> score) {
    // Lấy điểm quá trình và điểm thi
    final processScore = double.tryParse(score['process'] ?? '');
    final examScore = double.tryParse(score['exam'] ?? '');

    // Tính tổng kết TK và cập nhật trạng thái TT
    if (processScore != null && examScore != null) {
      final finalScore = processScore * 0.3 + examScore * 0.7;
      score['finalScore'] = _formatScore(finalScore.toString());

      // Đặt trạng thái Đạt hoặc Học lại dựa trên điểm TK
      score['status'] = finalScore >= 4.0 ? 'Đạt' : 'Học lại';
    } else {
      score['finalScore'] = '';
      score['status'] = '';
    }
  }

  Future<void> _loadScoreData() async {
    final scores = await _classService.loadStudentScores(widget.className);
    setState(() {
      _scores.clear();
      _scores.addAll(List<Map<String, String>>.from(scores));

      // Áp dụng tính toán TK và TT cho mỗi sinh viên
      for (var score in _scores) {
        final email = score['email']!;
        if (!_focusNodes.containsKey('${email}_process')) {
          _focusNodes['${email}_process'] = FocusNode();
        }
        if (!_focusNodes.containsKey('${email}_exam')) {
          _focusNodes['${email}_exam'] = FocusNode();
        }

        // Tính TK và TT
        _calculateFinalScoreAndStatus(score);
      }
    });
  }

  void _savePendingChange(int index, String column, String value) {
    final student = _scores[index];
    final studentEmail = student['email']!;

    if (!_pendingChanges.containsKey(studentEmail)) {
      _pendingChanges[studentEmail] = {
        'process': student['process'] ?? '',
        'exam': student['exam'] ?? '',
      };
    }

    // Cập nhật điểm cho cột QT hoặc Thi
    _pendingChanges[studentEmail]![column] = value;
    _scores[index][column] = value;

    // Tính toán lại TK và TT sau khi sửa điểm
    _calculateFinalScoreAndStatus(student);
  }

  // Kiểm tra giá trị điểm có hợp lệ không
  bool _isValidScore(String value) {
    if (value.isEmpty) return true; // Cho phép trường trống

    try {
      final score = double.parse(value);
      return score >= 0 && score <= 10;
    } catch (e) {
      return false;
    }
  }

  // Format điểm số để hiển thị
  String _formatScore(String value) {
    if (value.isEmpty) return '';

    try {
      final score = double.parse(value);
      // Nếu là số nguyên, không hiển thị phần thập phân
      if (score == score.roundToDouble()) {
        return score.toStringAsFixed(0);
      }
      // Nếu có phần thập phân, giới hạn 1 chữ số sau dấu phẩy
      return score.toStringAsFixed(1);
    } catch (e) {
      return value;
    }
  }

  Future<void> _applyAllChanges() async {
    // Kiểm tra tất cả các giá trị điểm trước khi cập nhật
    bool hasInvalidScore = false;
    String invalidMessage = '';

    for (final entry in _pendingChanges.entries) {
      final changes = entry.value;

      if (changes['process']!.isNotEmpty && !_isValidScore(changes['process']!)) {
        hasInvalidScore = true;
        invalidMessage = 'Điểm quá trình không hợp lệ';
        break;
      }

      if (changes['exam']!.isNotEmpty && !_isValidScore(changes['exam']!)) {
        hasInvalidScore = true;
        invalidMessage = 'Điểm thi không hợp lệ';
        break;
      }
    }

    if (hasInvalidScore) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(invalidMessage),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      for (final entry in _pendingChanges.entries) {
        final studentEmail = entry.key;
        final changes = entry.value;

        await _classService.updateStudentScore(
          widget.className,
          studentEmail,
          changes['process']!,
          changes['exam']!,
        );
      }

      _pendingChanges.clear();

      setState(() {
        isTeacher = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật điểm thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi cập nhật điểm: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        final email = score['email']!;
        return ExpandableTableRow(
          firstCell: _buildCell(score['name']?.isEmpty ?? true ? email : score['name']!),
          cells: [
            isTeacher
                ? _buildEditableCell(
              index,
              email,
              'process',
              score['process'] ?? '',
              _focusNodes['${email}_process']!,
            )
                : _buildCell(_formatScore(score['process'] ?? '')),
            isTeacher
                ? _buildEditableCell(
              index,
              email,
              'exam',
              score['exam'] ?? '',
              _focusNodes['${email}_exam']!,
            )
                : _buildCell(_formatScore(score['exam'] ?? '')),
            _buildCell(score['finalScore'] ?? ''),
            _buildCell(score['status'] ?? ''),
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

  ExpandableTableCell _buildEditableCell(
      int index,
      String email,
      String field,
      String initialValue,
      FocusNode focusNode,
      ) {
    return ExpandableTableCell(
      child: StatefulBuilder(
        builder: (context, setInnerState) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              initialValue: _formatScore(initialValue),
              focusNode: focusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                // Chỉ cho phép nhập số và dấu chấm
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
                // Giới hạn giá trị từ 0-10
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) return newValue;
                  try {
                    final score = double.parse(newValue.text);
                    if (score <= 10) return newValue;
                  } catch (e) {}
                  return oldValue;
                }),
              ],
              onChanged: (value) {
                if (value.isEmpty || _isValidScore(value)) {
                  // Lưu điểm mới và tính lại kết quả
                  _savePendingChange(index, field, value);
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                errorText: initialValue.isNotEmpty && !_isValidScore(initialValue)
                    ? 'Điểm không hợp lệ'
                    : null,
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          );
        },
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
                  if (!isTeacher) {
                    _pendingChanges.clear();
                    _loadScoreData();
                  }
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
                fixedSize: const Size(130, 30),
                backgroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _applyAllChanges,
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}