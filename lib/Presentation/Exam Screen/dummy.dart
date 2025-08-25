import 'package:flutter/material.dart';

class MarkEntryScreen extends StatefulWidget {
  const MarkEntryScreen({super.key});

  @override
  State<MarkEntryScreen> createState() => _MarkEntryScreenState();
}

class _MarkEntryScreenState extends State<MarkEntryScreen> {
  // Demo data
  final List<String> students = ['Anjana', 'Arun', 'Bala'];
  final List<String> subjects = [
    'Tamil', 'English', 'Mathematics', 'Science', 'Social Science'
  ];

  late List<List<int?>> marks; // marks[student][subject]
  int studentIndex = 0;
  int subjectIndex = 0; // start at Tamil (index 0)

  @override
  void initState() {
    super.initState();
    marks = List.generate(
      students.length,
          (_) => List<int?>.filled(subjects.length, null, growable: false),
      growable: false,
    );
  }

  // ---------- movement helpers ----------
  void _nextSubject() {
    if (subjectIndex < subjects.length - 1) {
      setState(() => subjectIndex += 1);
    } else {
      _nextStudent(resetSubject: true);
    }
  }

  void _prevSubject() {
    if (subjectIndex > 0) {
      setState(() => subjectIndex -= 1);
    }
  }

  void _nextStudent({bool resetSubject = false}) {
    if (studentIndex < students.length - 1) {
      setState(() {
        studentIndex += 1;
        if (resetSubject) subjectIndex = 0; // back to Tamil
      });
    }
  }

  void _prevStudent() {
    if (studentIndex > 0) {
      setState(() {
        studentIndex -= 1;
        subjectIndex = 0; // keep consistent (start at Tamil)
      });
    }
  }

  // ---------- number pad actions ----------
  void _typeDigit(int d) {
    final current = marks[studentIndex][subjectIndex];
    final nextText =
    (current == null || current == 0) ? '$d' : '${current.toString()}$d';
    var nextVal = int.tryParse(nextText) ?? 0;
    if (nextVal > 100) nextVal = 100; // clamp to 100

    setState(() => marks[studentIndex][subjectIndex] = nextVal);

    // AUTO ADVANCE: once we have 2 digits (10..99) or 100
    final len = nextVal.toString().length;
    if (nextVal == 100 || len >= 2) {
      Future.microtask(_nextSubject);
    }
  }

  void _backspace() {
    final current = marks[studentIndex][subjectIndex];
    if (current == null || current == 0) return;
    final s = current.toString();
    final ns = (s.length <= 1) ? '0' : s.substring(0, s.length - 1);
    setState(() => marks[studentIndex][subjectIndex] = int.tryParse(ns) ?? 0);
  }

  void _clear() {
    setState(() => marks[studentIndex][subjectIndex] = 0);
  }

  // ---------- tiny UI builders ----------
  Widget _pill({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
    double radius = 16,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x14000000),
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: _pill(
            child: Icon(icon, size: 22, color: Colors.black87),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
      ],
    );
  }

  Widget _numKey(String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: _pill(
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        radius: 20,
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  // ---------- build ----------
  @override
  Widget build(BuildContext context) {
    final student = students[studentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F8FB),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Create Quiz', // from your screenshot text area
          style: const TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ---- card with subjects table ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF7FF), // light blue bg like image
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child:
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Column(
                      children: List.generate(subjects.length, (i) {
                        final isActive = i == subjectIndex;
                        final value = marks[studentIndex][i];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: i == subjects.length - 1
                                ? null
                                : const Border(
                              bottom: BorderSide(
                                color: Color(0xFFEDEDED),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  subjects[i],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                    isActive ? FontWeight.w700 : FontWeight.w500,
                                    color: isActive
                                        ? Colors.black87
                                        : Colors.black38, // light for others
                                  ),
                                ),
                              ),
                              Text(
                                value == null || value == 0 ? '--' : '$value',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w600,
                                  color:
                                  isActive ? Colors.black87 : Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ---- keypad + side controls ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // left: Student controls
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _controlButton(
                        icon: Icons.chevron_right,
                        label: 'Next',
                        onTap: () => _nextStudent(resetSubject: true),
                      ),
                      const SizedBox(height: 22),
                      _controlButton(
                        icon: Icons.chevron_left,
                        label: 'Prev',
                        onTap: _prevStudent,
                      ),
                      const SizedBox(height: 6),
                      const Text('Student',
                          style: TextStyle(fontSize: 11, color: Colors.black45)),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // middle: number pad
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: GridView.count(
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _numKey('1', onTap: () => _typeDigit(1)),
                          _numKey('2', onTap: () => _typeDigit(2)),
                          _numKey('3', onTap: () => _typeDigit(3)),
                          _numKey('4', onTap: () => _typeDigit(4)),
                          _numKey('5', onTap: () => _typeDigit(5)),
                          _numKey('6', onTap: () => _typeDigit(6)),
                          _numKey('7', onTap: () => _typeDigit(7)),
                          _numKey('8', onTap: () => _typeDigit(8)),
                          _numKey('9', onTap: () => _typeDigit(9)),
                          _numKey('⌫', onTap: _backspace),
                          _numKey('0', onTap: () => _typeDigit(0)),
                          _numKey('×', onTap: _clear),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // right: Subject controls
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _controlButton(
                        icon: Icons.keyboard_arrow_up,
                        label: 'Up',
                        onTap: _prevSubject,
                      ),
                      const SizedBox(height: 22),
                      _controlButton(
                        icon: Icons.keyboard_arrow_down,
                        label: 'Down',
                        onTap: _nextSubject,
                      ),
                      const SizedBox(height: 6),
                      const Text('Subject',
                          style: TextStyle(fontSize: 11, color: Colors.black45)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
