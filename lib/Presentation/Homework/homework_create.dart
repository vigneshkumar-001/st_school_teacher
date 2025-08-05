import 'package:flutter/material.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

class HomeworkCreate extends StatefulWidget {
  const HomeworkCreate({super.key});

  @override
  State<HomeworkCreate> createState() => _HomeworkCreateState();
}

class _HomeworkCreateState extends State<HomeworkCreate> {
  final List<Map<String, String>> classData = [
    {'grade': '8', 'section': 'A'},
    {'grade': '8', 'section': 'B'},
    {'grade': '8', 'section': 'C'},
    {'grade': '9', 'section': 'A'},
    {'grade': '9', 'section': 'C'},
  ];

  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Column(
              children: [
                Row(
                  children: [
                    CommonContainer.NavigatArrow(
                      image: AppImages.leftSideArrow,
                      imageColor: AppColor.lightBlack,
                      container: AppColor.lowLightgray,
                      onIconTap: () => Navigator.pop(context),
                      border: Border.all(color: AppColor.lightgray, width: 0.3),
                    ),
                    Spacer(),
                    Text(
                      'History',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.gray,
                      ),
                    ),
                    SizedBox(width: 8),
                    Image.asset(AppImages.historyImage, height: 24),
                  ],
                ),
                SizedBox(height: 35),
                Text(
                  'Create Homework',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: AppColor.black,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: AppColor.white),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: AppColor.lightgray),
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: classData.length,
                                  itemBuilder: (context, index) {
                                    final item = classData[index];
                                    final isSelected = index == selectedIndex;
                                    final grade = item['grade']!;
                                    final section = item['section']!;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        width: 80,
                                        height: isSelected ? 160 : 100,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          boxShadow:
                                              isSelected
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.blue
                                                          .withOpacity(0.2),
                                                      blurRadius: 10,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ]
                                                  : [],
                                          border:
                                              isSelected
                                                  ? Border.all(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  )
                                                  : null,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (isSelected)
                                              Text(
                                                '${grade}th',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            else
                                              Text(
                                                grade,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            SizedBox(height: 8),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    isSelected
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      bottom: Radius.circular(
                                                        24,
                                                      ),
                                                    ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                section,
                                                style: TextStyle(
                                                  color:
                                                      isSelected
                                                          ? Colors.white
                                                          : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSuffix(int number) {
    if (number == 1) return "st";
    if (number == 2) return "nd";
    if (number == 3) return "rd";
    return "th";
  }
}
