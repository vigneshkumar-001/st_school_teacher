/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // for GoogleFonts.inter
import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_details.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart'; // your GoogleFont helper
import '../../Core/Widgets/common_container.dart';

class DetailsAttendHistory extends StatefulWidget {
  const DetailsAttendHistory({super.key});

  @override
  State<DetailsAttendHistory> createState() => _DetailsAttendHistoryState();
}

class _DetailsAttendHistoryState extends State<DetailsAttendHistory> {
  final TextEditingController searchController = TextEditingController();
  String _searchText = '';
  int selectedIndex = 0; // 0 = Done, 1 = Unfinished

  // Sample data (replace with your real lists / API)
  final List<Map<String, dynamic>> studentsFilled = const [
    {"name": "Kanjana", "score": 7, "total": 10},
    {"name": "Juliya", "score": 9, "total": 10},
    {"name": "Marie", "score": 7, "total": 10},
    {"name": "Christiana", "score": 7, "total": 10},
    {"name": "Olivia", "score": 7, "total": 10},
    {"name": "Stella", "score": 7, "total": 10},
  ];

  final List<Map<String, dynamic>> studentsUnfinished = const [
    {"name": "Harish", "score": 0, "total": 10},
    {"name": "Anita", "score": 0, "total": 10},
    {"name": "Ravi", "score": 0, "total": 10},
    {"name": "Kumar", "score": 0, "total": 10},
    {"name": "Nisha", "score": 0, "total": 10},
  ];

  void _navigateToStudent(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizDetails(studentName: name)),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter lists against search text
    final doneFiltered =
        studentsFilled.where((m) {
          if (_searchText.isEmpty) return true;
          final name = (m['name'] ?? '').toString();
          return name.toLowerCase().contains(_searchText.toLowerCase());
        }).toList();

    final unfinishedFiltered =
        studentsUnfinished.where((m) {
          if (_searchText.isEmpty) return true;
          final name = (m['name'] ?? '').toString();
          return name.toLowerCase().contains(_searchText.toLowerCase());
        }).toList();

    // Current tab's data
    final current = selectedIndex == 0 ? doneFiltered : unfinishedFiltered;

    // Dynamic counts in the Tab labels (respond to search)
    final doneCount = doneFiltered.length;
    final unfinishedCount = unfinishedFiltered.length;

    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonContainer.NavigatArrow(
                  image: AppImages.leftSideArrow,
                  imageColor: AppColor.lightBlack,
                  container: AppColor.lowLightgray,
                  onIconTap: () => Navigator.pop(context),
                  border: Border.all(color: AppColor.lightgray, width: 0.3),
                ),
                const SizedBox(height: 35),
                Center(
                  child: Text(
                    'Quiz Attend History',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // ===== Top summary card (kept as your original) =====
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.lowLightBlue,
                            border: Border.all(
                              color: AppColor.lowLightgray,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Science ',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.gray,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Lorem ipsum donae',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColor.black,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '7 out 50 ',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Done',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.black.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 25,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: '7',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.gray,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'th ',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColor.gray,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: 'C',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: AppColor.gray,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              width: 2,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.grey.shade200,
                                                    Colors.grey.shade300,
                                                    Colors.grey.shade200,
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(1),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '4.30Pm',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: AppColor.gray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const QuizDetails(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            color: AppColor.borderGary,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            'View',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                        Center(
                          child: Text(
                            'Students List',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ===== Search =====
                        TextField(
                          controller: searchController,
                          onChanged:
                              (value) => setState(() => _searchText = value),
                          decoration: InputDecoration(
                            suffixIcon:
                                _searchText.isNotEmpty
                                    ? GestureDetector(
                                      onTap:
                                          () => setState(() {
                                            searchController.clear();
                                            _searchText = '';
                                          }),
                                      child: Icon(
                                        Icons.clear,
                                        size: 20,
                                        color: AppColor.gray,
                                      ),
                                    )
                                    : null,
                            hintText: 'Search',
                            hintStyle: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.gray,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 25.0,
                                right: 6,
                              ),
                              child: Icon(
                                Icons.search_rounded,
                                size: 20,
                                color: AppColor.gray,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColor.lowLightgray,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: AppColor.lowLightgray,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: AppColor.lowLightgray,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ===== Tabs (pill-style) + list (no TabController needed) =====
                        DefaultTabController(
                          length: 2,
                          initialIndex: selectedIndex,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                onTap: (i) => setState(() => selectedIndex = i),
                                isScrollable: true,
                                dividerColor: Colors.transparent,
                                dividerHeight: 0,
                                // Hide default indicator; we'll draw our own borders per tab
                                indicator: const BoxDecoration(),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelPadding:
                                    EdgeInsets
                                        .zero, // we'll handle padding in the child

                                tabs: List.generate(2, (index) {
                                  final bool isSel = selectedIndex == index;
                                  final String label =
                                      index == 0
                                          ? "$doneCount Done"
                                          : "$unfinishedCount Unfinished";

                                  return Tab(
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 6.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.5,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSel
                                                ? AppColor.white
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color:
                                              isSel
                                                  ? AppColor.blue
                                                  : AppColor
                                                      .borderGary, // ✅ blue vs gray
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        label,
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          color:
                                              isSel
                                                  ? AppColor.blue
                                                  : AppColor
                                                      .gray, // text color match
                                          fontWeight:
                                              isSel
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              SizedBox(height: 15),

                              // Current tab's list
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: current.length,
                                separatorBuilder:
                                    (_, __) => Divider(
                                      color: AppColor.lowLightgray,
                                      height: 1,
                                    ),
                                itemBuilder: (_, i) {
                                  final item = current[i];
                                  final name = item['name'] as String;
                                  final score = item['score'] ?? 0;
                                  final total = item['total'] as int;

                                  return ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    // Row click → navigate with name
                                    onTap: () => _navigateToStudent(name),
                                    title: Text(
                                      name,
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 14,
                                        color: AppColor.lightBlack,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CommonContainer.totalsPill(
                                          score: score,
                                          total: total,
                                        ),
                                        SizedBox(width: 10),
                                        Image.asset(
                                          AppImages.rightSideArrow,
                                          color: AppColor.lightgray,
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

// lib/Presentation/Quiz Screen/details_attend_history.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/consents.dart';

import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_details.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/date_and_time_convert.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'Model/quiz_attend_response.dart';
import 'attend_history_specific_student.dart';
import 'controller/quiz_controller.dart';

class DetailsAttendHistory extends StatefulWidget {
  /// This is actually the classId used by your API
  final int quizId;
  final String? dateLabel;

  const DetailsAttendHistory({super.key, required this.quizId, this.dateLabel});

  @override
  State<DetailsAttendHistory> createState() => _DetailsAttendHistoryState();
}

class _DetailsAttendHistoryState extends State<DetailsAttendHistory> {
  final QuizController c =
      Get.isRegistered<QuizController>()
          ? Get.find<QuizController>()
          : Get.put(QuizController());

  final TextEditingController searchController = TextEditingController();
  String _searchText = '';
  int selectedIndex = 0; // 0 = Done, 1 = Pending/Unfinished

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.loadQuizAttendByClass(code: widget.quizId);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _navigateToStudent({
    required int studentId,
    required String name,
    required int quizId,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AttendHistorySpecificStudent(
              studentName: name,
              studentId: studentId,
              quizId: quizId,
              revealOnOpen: true,
            ),
      ),
    );
  }

  String? _formatDateLabel(String? label) {
    if (label == null || label.trim().isEmpty) return null;
    final now = DateTime.now();
    final lower = label.toLowerCase().trim();
    if (lower == 'today') return DateFormat('MMM d, y').format(now);
    if (lower == 'yesterday') {
      return DateFormat(
        'MMM d, y',
      ).format(now.subtract(const Duration(days: 1)));
    }
    final cleaned = label.replaceAll(',', '').trim();
    for (final loc in const ['en_US', 'en']) {
      try {
        final parsed = DateFormat('MMM d y', loc).parse('$cleaned ${now.year}');
        return DateFormat('MMM d, y', loc).format(parsed);
      } catch (_) {}
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          if (c.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          final AttendSummaryData? data = c.attendSummary.value;
          if (data == null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonContainer.NavigatArrow(
                    image: AppImages.leftSideArrow,
                    imageColor: AppColor.lightBlack,
                    container: AppColor.lowLightgray,
                    onIconTap: () => Navigator.pop(context),
                    border: Border.all(color: AppColor.lightgray, width: 0.3),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Text(
                      c.lastError.value.isEmpty ? 'No data found' : 'Oops',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  if (c.lastError.value.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      c.lastError.value,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 13,
                        color: AppColor.gray,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          // Data (null-safe)
          final QuizSummary q = data.quiz;
          final List<StudentDone> done =
              (data.studentsDone ?? const <StudentDone>[]);
          final List<StudentUnfinished> unfinished =
              (data.studentsUnfinished ?? const <StudentUnfinished>[]);

          // Search helper
          bool _match(String s) =>
              _searchText.isEmpty ||
              s.toLowerCase().contains(_searchText.toLowerCase());

          // Filtered views
          final List<StudentDone> doneFiltered =
              done.where((s) => _match(s.name)).toList();

          final List<StudentUnfinished> unfinishedFiltered =
              unfinished.where((u) => _match(u.name)).toList();

          // Counts for tab pills (filtered counts feel natural when searching)
          final int doneCount = doneFiltered.length;
          final int unfinishedCount = unfinishedFiltered.length;

          // Optional date label
          final String? dateText = _formatDateLabel(widget.dateLabel);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonContainer.NavigatArrow(
                  image: AppImages.leftSideArrow,
                  imageColor: AppColor.lightBlack,
                  container: AppColor.lowLightgray,
                  onIconTap: () => Navigator.pop(context),
                  border: Border.all(color: AppColor.lightgray, width: 0.3),
                ),
                const SizedBox(height: 35),

                Center(
                  child: Text(
                    'Quiz Attend History',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                if (dateText != null) ...[
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      dateText,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 12,
                        color: AppColor.gray,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 25),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // header card
                          Container(
                            decoration: BoxDecoration(
                              color: AppColor.lowLightBlue,
                              border: Border.all(
                                color: AppColor.lowLightgray,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    q.subject,
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    q.title,
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          '${q.doneStudentsCount} out ${q.totalStudents} ',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Done',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: AppColor.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.black.withOpacity(
                                            0.05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                q.className,
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.gray,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                width: 2,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.grey.shade200,
                                                      Colors.grey.shade300,
                                                      Colors.grey.shade200,
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                DateAndTimeConvert.formatDateTime(
                                                  showTime: true,
                                                  showDate: false,
                                                  q.time.toString(),
                                                ),

                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: AppColor.gray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            AppLogger.log.i(
                                              "${q.id},${q.title}",
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => QuizDetails(
                                                      classId: q.id,
                                                      studentName: q.title,
                                                      revealOnOpen: true,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                color: AppColor.borderGary,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 10,
                                                  ),
                                              child: Text(
                                                'View',
                                                style: GoogleFont.inter(
                                                  fontSize: 12,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),
                          Center(
                            child: Text(
                              'Students List',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          TextField(
                            controller: searchController,
                            onChanged:
                                (value) => setState(() => _searchText = value),
                            decoration: InputDecoration(
                              suffixIcon:
                                  _searchText.isNotEmpty
                                      ? GestureDetector(
                                        onTap:
                                            () => setState(() {
                                              searchController.clear();
                                              _searchText = '';
                                            }),
                                        child: Icon(
                                          Icons.clear,
                                          size: 20,
                                          color: AppColor.gray,
                                        ),
                                      )
                                      : null,
                              hintText: 'Search',
                              hintStyle: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.gray,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 25.0,
                                  right: 6,
                                ),
                                child: Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                  color: AppColor.gray,
                                ),
                              ),
                              filled: true,
                              fillColor: AppColor.lowLightgray,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: AppColor.lowLightgray,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: AppColor.lowLightgray,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Tabs + content
                          Expanded(
                            child: DefaultTabController(
                              length: 2,
                              initialIndex: selectedIndex,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TabBar(
                                    onTap:
                                        (i) =>
                                            setState(() => selectedIndex = i),
                                    isScrollable: true,
                                    dividerColor: Colors.transparent,
                                    dividerHeight: 0,
                                    indicator: const BoxDecoration(),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelPadding: EdgeInsets.zero,
                                    tabs: [
                                      _pillTab(
                                        label: "$doneCount Done",
                                        selected: selectedIndex == 0,
                                      ),
                                      _pillTab(
                                        label: "$unfinishedCount Unfinished",
                                        selected: selectedIndex == 1,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        // DONE tab
                                        ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount: doneFiltered.length,
                                          separatorBuilder:
                                              (_, __) => Divider(
                                                color: AppColor.lowLightgray,
                                                height: 1,
                                              ),
                                          itemBuilder: (_, i) {
                                            final s = doneFiltered[i];
                                            return ListTile(
                                              dense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              onTap: () {
                                                AppLogger.log.i(
                                                  '${s.id}${s.name}${q.id}',
                                                );
                                                _navigateToStudent(
                                                  studentId: s.id,
                                                  name: s.name,
                                                  quizId: q.id, // ← was classId
                                                );
                                              },
                                              title: Text(
                                                s.name,
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 14,
                                                  color: AppColor.lightBlack,
                                                ),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CommonContainer.totalsPill(
                                                    score: s.score,
                                                    total: s.total,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Image.asset(
                                                    AppImages.rightSideArrow,
                                                    color: AppColor.lightgray,
                                                    height: 12,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        // UNFINISHED tab
                                        ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount: unfinishedFiltered.length,
                                          separatorBuilder:
                                              (_, __) => Divider(
                                                color: AppColor.lowLightgray,
                                                height: 1,
                                              ),
                                          itemBuilder: (_, i) {
                                            final u =
                                                unfinishedFiltered[i]; // StudentUnfinished
                                            final String name = u.name;

                                            return ListTile(
                                              dense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              onTap: () {
                                                AppLogger.log.i(
                                                  '${u.id} =  ${u.name} = ${q.id}',
                                                );
                                                  _navigateToStudent(
                                                    studentId: u.id,
                                                    name: name,
                                                    quizId: q.id,
                                                  );
                                              },
                                              title: Text(
                                                name,
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 14,
                                                  color: AppColor.lightBlack,
                                                ),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColor.lowLightgray,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      'Not attempted',
                                                      style:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 11,
                                                            color:
                                                                AppColor.gray,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Image.asset(
                                                    AppImages.rightSideArrow,
                                                    color: AppColor.lightgray,
                                                    height: 12,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Tab _pillTab({required String label, required bool selected}) {
    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 6.5),
        padding: const EdgeInsets.symmetric(horizontal: 16.5, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColor.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColor.blue : AppColor.borderGary,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFont.ibmPlexSans(
            fontSize: 12,
            color: selected ? AppColor.blue : AppColor.gray,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
