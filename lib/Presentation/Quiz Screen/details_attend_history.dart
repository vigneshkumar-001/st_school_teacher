import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_details.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

class DetailsAttendHistory extends StatefulWidget {
  const DetailsAttendHistory({super.key});

  @override
  State<DetailsAttendHistory> createState() => _DetailsAttendHistoryState();
}

class _DetailsAttendHistoryState extends State<DetailsAttendHistory> {
  TextEditingController searchController = TextEditingController();
  String _searchText = '';
  int subjectIndex = 0;
  int selectedIndex = 0;

  final List<Map<String, dynamic>> tabs = [
    {"count": 7, "label": "Done"},
    {"count": 43, "label": "Unfinished"},
  ];

  final List<List<String>> studentsPerTab = [
    ['Kanjana', 'Juliya', 'Marie'],
    ['Christiana', 'Olivia', 'Stella'],
  ];
  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 35),
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
                SizedBox(height: 25),
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
                                SizedBox(height: 12),
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
                                SizedBox(height: 20),
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
                                            SizedBox(width: 10),
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
                                            SizedBox(width: 10),
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
                                            builder: (context) => QuizDetails(),
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
                        SizedBox(height: 25),
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
                        SizedBox(height: 15),
                        TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },

                          decoration: InputDecoration(
                            suffixIcon:
                                _searchText.isNotEmpty
                                    ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          searchController.clear();
                                          _searchText = '';
                                        });
                                      },
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
                        SizedBox(height: 15),
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
                        SizedBox(height: 15),
                        Column(
                          children: List.generate(
                            studentsPerTab[selectedIndex].length,
                            (i) => CommonContainer.StudentsList(
                              blueContainer: true,
                              mainText: studentsPerTab[selectedIndex][i],
                              onIconTap: () {},
                            ),
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
