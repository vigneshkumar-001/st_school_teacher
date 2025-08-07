import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Core/Utility/app_images.dart';
import 'package:st_teacher_app/Core/Widgets/common_container.dart';
import 'package:intl/intl.dart';

import '../../Core/Utility/google_fonts.dart';
import 'attendance_history_student.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({super.key});

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  TextEditingController searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;

  final List<Map<String, dynamic>> tabs = [
    {"count": 7, "label": "Full Present"},
    {"count": 2, "label": "Full Absent"},
    {"count": 2, "label": "Morning Absent"},
  ];

  int selectedDateIndex = 0;
  late List<Map<String, dynamic>> monthDates;
  int selectedTab = 0;

  List<DateTime> weekDates = [];

  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late ScrollController _scrollController;

  final List<String> months = List.generate(
    12,
    (index) => DateFormat.MMMM().format(DateTime(0, index + 6)),
  );

  List<Map<String, dynamic>> getFullMonthDates(DateTime currentMonth) {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    // late ScrollController _scrollController;

    return List.generate(lastDay.day, (i) {
      final date = firstDay.add(Duration(days: i));
      return {
        "day": DateFormat.E().format(date),
        "date": date.day,
        "fullDate": date,
        "formattedFullDate": DateFormat('EEEE, dd MMM yyyy').format(date),
      };
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    monthDates = getFullMonthDates(currentMonth);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedDate();
    });
  }

  void scrollToSelectedDate() {
    final index = getFullMonthDates(currentMonth).indexWhere((item) {
      final date = item['fullDate'] as DateTime;
      return selectedDate.day == date.day &&
          selectedDate.month == date.month &&
          selectedDate.year == date.year;
    });

    if (index != -1) {
      final itemWidth = 52.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        offset < 0 ? 0 : offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void showMonthPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => ListView.builder(
            itemCount: months.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(months[index]),
                onTap: () {
                  setState(() {
                    currentMonth = DateTime(DateTime.now().year, index + 6);
                    selectedDate = DateTime(
                      currentMonth.year,
                      currentMonth.month,
                      1,
                    );
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM dd').format(now);
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
                  onIconTap: () => Navigator.pop(context),
                  container: AppColor.white,
                  border: Border.all(color: AppColor.lightgray, width: 0.3),
                ),
                SizedBox(height: 18),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: '7',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 14,
                        color: AppColor.gray,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: 'th ',
                          style: GoogleFont.ibmPlexSans(fontSize: 10),
                        ),
                        TextSpan(
                          text: 'C ',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.gray,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'Section',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Center(
                  child: Text(
                    'Attendance History',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.bcImage,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              AppImages.bcImage,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: showMonthPicker,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateFormat.MMMM().format(
                                                selectedDate,
                                              ),
                                              style: GoogleFont.ibmPlexSans(
                                                color: AppColor.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColor.white,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 85,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        getFullMonthDates(currentMonth).length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          getFullMonthDates(
                                            currentMonth,
                                          )[index];
                                      final date = item['fullDate'] as DateTime;
                                      final isSelected =
                                          selectedDate.day == date.day &&
                                          selectedDate.month == date.month &&
                                          selectedDate.year == date.year;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedDate = date;
                                            scrollToSelectedDate();
                                          });
                                        },
                                        child: Container(
                                          width: 47,
                                          decoration:
                                              isSelected
                                                  ? BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  )
                                                  : null,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item['day'],
                                                style: GoogleFont.ibmPlexSans(
                                                  color:
                                                      isSelected
                                                          ? Colors.blue
                                                          : Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                item['date'].toString(),
                                                style: GoogleFont.ibmPlexSans(
                                                  color:
                                                      isSelected
                                                          ? Colors.blue
                                                          : Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'Students List',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },
                          decoration: InputDecoration(
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

                            contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(tabs.length, (index) {
                              final isSelected = selectedIndex == index;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.5,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.5,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? AppColor.white
                                              : AppColor.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? AppColor.blue
                                                : AppColor.borderGary,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      "${tabs[index]['count']} ${tabs[index]['label']}",
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 12,
                                        color:
                                            isSelected
                                                ? AppColor.blue
                                                : AppColor.gray,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (selectedIndex == 0) ...[
                          CommonContainer.StudentsList(
                            mainText: 'Kanjana',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Juliya',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Marie',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Christiana',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Christiana',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Olivia',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Stella',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Marie',
                            onIconTap: () {},
                          ),
                        ] else if (selectedIndex == 1) ...[
                          CommonContainer.StudentsList(
                            mainText: 'Marie',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Christiana',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Olivia',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Stella',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Marie',
                            onIconTap: () {},
                          ),
                        ] else if (selectedIndex == 2) ...[
                          CommonContainer.StudentsList(
                            mainText: 'Olivia',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Stella',
                            onIconTap: () {},
                          ),
                          CommonContainer.StudentsList(
                            mainText: 'Marie',
                            onIconTap: () {},
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 27),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceHistoryStudent(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.blue, width: 1.5),
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Take Attenedence',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColor.blue,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image.asset(AppImages.doubleArrow, height: 19),
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
