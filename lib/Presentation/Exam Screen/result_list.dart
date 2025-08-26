import 'package:flutter/material.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../../Core/Utility/custom_app_button.dart';
import 'exam_result.dart';

class ResultList extends StatefulWidget {
  const ResultList({super.key});
  @override
  State<ResultList> createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  final TextEditingController searchController = TextEditingController();
  String _searchText = '';
  int selectedIndex = 0;

  static const double _outerStretchLeft = 52; // left tab stretch
  static const double _outerStretchRight =
      36; // right tab stretch (make smaller to reduce overshoot)
  static const double _innerStretch = 6;
  static const double _vPad = -8;

  final List<List<String>> studentsPerTab = const [
    ['Kanjana', 'Juliya', 'Marie'],
    ['Christiana', 'Olivia', 'Stella'],
  ];
  final List<Map<String, dynamic>> studentsFilled = [
    {"name": "Kanjana", "total": 430},
    {"name": "Juliya", "total": 320},
    {"name": "Marie", "total": 414},
    {"name": "Christiana", "total": 265},
    {"name": "Olivia", "total": 215},
    {"name": "Stella", "total": 364},
    {"name": "Marie", "total": 414},
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  EdgeInsets _indicatorPaddingFor(int index) {
    const outer = 52.0, inner = 10.0, vPad = -8.0;
    const rightBias = 6.0; // trims the right cap a bit
    return index == 0
        ? const EdgeInsets.fromLTRB(-outer, vPad, -inner, vPad)
        : const EdgeInsets.fromLTRB(-inner, vPad, -(outer - rightBias), vPad);
  }

  void _navigateToStudent(String name) {
    if (name != 'Kanjana') return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExamResult()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      length: 2, // provide the controller here
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
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
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Mid Term Exam Result',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ===== TAB STRIP + CONNECTOR + CARD =====
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final ctrl = DefaultTabController.of(context)!;
                      return AnimatedBuilder(
                        animation: ctrl.animation!,
                        builder: (context, _) {
                          final idx = ctrl.index; // 0 or 1
                          final students = studentsPerTab[selectedIndex];

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // --- Tab strip ---
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 0.5,
                                ),
                                child: TabBar(
                                  controller: ctrl,
                                  isScrollable: true,
                                  tabs: const [
                                    Tab(text: '10 Mark Filled'),
                                    Tab(text: '10 Mark Unfilled'),
                                  ],
                                  labelColor: AppColor.blue,
                                  unselectedLabelColor: AppColor.gray,

                                  // White cap (rounded top, flat bottom)
                                  indicator: const BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(18),
                                      bottom: Radius.zero,
                                    ),
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorPadding: _indicatorPaddingFor(
                                    idx,
                                  ), // asymmetric stretch

                                  labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 8,
                                  ),
                                  dividerColor: Colors.transparent,
                                  overlayColor: const MaterialStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                  splashFactory: NoSplash.splashFactory,
                                  labelStyle: GoogleFont.ibmPlexSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // --- Big white card with content ---
                              Positioned.fill(
                                top: 60,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TabBarView(
                                    controller: ctrl,
                                    children: [
                                      // ===== Tab 1 =====
                                      SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 20),
                                            CommonContainer.searchField(
                                              controller: searchController,
                                              searchText: _searchText,
                                              onChanged:
                                                  (v) => setState(
                                                    () => _searchText = v,
                                                  ),
                                              onClear:
                                                  () => setState(() {
                                                    searchController.clear();
                                                    _searchText = '';
                                                  }),
                                            ),
                                            const SizedBox(height: 20),

                                            CommonContainer.statusChips(
                                              tabs: const [
                                                {"label": "Mark View"},
                                                {"label": "Rank View"},
                                              ],
                                              selectedIndex: selectedIndex,
                                              onSelect:
                                                  (i) => setState(
                                                    () => selectedIndex = i,
                                                  ),
                                            ),
                                            const SizedBox(height: 12),

                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: studentsFilled.length,
                                              separatorBuilder:
                                                  (_, __) => Divider(
                                                    color:
                                                        AppColor.lowLightgray,
                                                    height: 1,
                                                  ),
                                              itemBuilder: (_, i) {
                                                final item = studentsFilled[i];
                                                final name =
                                                    item['name'] as String;
                                                final total =
                                                    item['total'] as int;

                                                return ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  title: Text(
                                                    name,
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 14,
                                                          color:
                                                              AppColor
                                                                  .lightBlack,
                                                        ),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CommonContainer.totalPill(
                                                        total: total,
                                                      ), // 👈 using CommonContainer
                                                      const SizedBox(width: 10),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                  onTap:
                                                      () => _navigateToStudent(
                                                        name,
                                                      ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ===== Tab 2 =====
                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            AppButton.button(
                                              width: 320,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            ExamResult(),
                                                  ),
                                                );
                                              },
                                              text: 'Start Mark Filling',
                                              image: AppImages.buttonArrow,
                                            ),
                                            const SizedBox(height: 16),

                                            CommonContainer.searchField(
                                              controller: searchController,
                                              searchText: _searchText,
                                              onChanged:
                                                  (v) => setState(
                                                    () => _searchText = v,
                                                  ),
                                              onClear:
                                                  () => setState(() {
                                                    searchController.clear();
                                                    _searchText = '';
                                                  }),
                                            ),
                                            const SizedBox(height: 12),

                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  studentsPerTab[1].length,
                                              separatorBuilder:
                                                  (_, __) => Divider(
                                                    color:
                                                        AppColor.lowLightgray,
                                                    height: 1,
                                                  ),
                                              itemBuilder: (_, i) {
                                                final name =
                                                    studentsPerTab[1][i];
                                                return ListTile(
                                                  title: Text(
                                                    name,
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 14,
                                                          color:
                                                              AppColor
                                                                  .lightBlack,
                                                        ),
                                                  ),
                                                  trailing: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16,
                                                  ),
                                                  onTap:
                                                      () => _navigateToStudent(
                                                        name,
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
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // ===== /TAB + CARD =====
          ),
        ),
      ),
    );
  }
}
