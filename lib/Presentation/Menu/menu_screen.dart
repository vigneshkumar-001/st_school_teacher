import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Core/Utility/app_images.dart';
import 'package:st_teacher_app/Core/Utility/google_fonts.dart';
import 'package:st_teacher_app/Core/Widgets/common_container.dart';

import '../Attendance-teacher/attendance_history_teacher.dart';
import '../Attendance/attendance_history.dart';
import '../Attendance/attendance_start.dart';
import '../Homework/homework_create.dart';
import '../Profile/my_profile.dart';
import '../Quiz Screen/quiz_screen_create.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Menu',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 33,
                        fontWeight: FontWeight.w500,
                        color: AppColor.lightBlack,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Close',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 14,
                        color: AppColor.lightBlack,
                      ),
                    ),
                    SizedBox(width: 7),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(AppImages.close, height: 23.2),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Students',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 18,
                    color: AppColor.lightgray,
                  ),
                ),
                SizedBox(height: 15),
                CommonContainer.Menu_Students(
                  onIconTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceHistory(),
                      ),
                    );
                  },
                  mainText: 'Attendance',
                  Start: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceStart(),
                      ),
                    );
                  },
                  subText: 'Start',
                  image: AppImages.Attendance,
                  addButton: true,
                ),
                SizedBox(height: 20),
                CommonContainer.Menu_Students(
                  Start: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeworkCreate()),
                    );
                  },
                  onIconTap: () {},
                  mainText: 'Homework',
                  subText: 'Create',
                  image: AppImages.Homework,
                  addButton: true,
                ),
                SizedBox(height: 20),
                CommonContainer.Menu_Students(
                  Start: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreenCreate(),
                      ),
                    );
                  },
                  onIconTap: () {},
                  mainText: 'Quiz',
                  subText: 'Create',
                  image: AppImages.Quiz,
                  addButton: true,
                ),
                SizedBox(height: 20),
                CommonContainer.Menu_Students(
                  onIconTap: () {},
                  mainText: 'Exam',
                  subText: 'Create',
                  image: AppImages.Exam,
                  addButton: true,
                ),
                SizedBox(height: 20),
                CommonContainer.Menu_Students(
                  onIconTap: () {},
                  mainText: 'Announcement',
                  subText: 'Create',
                  image: AppImages.Announcement,
                  addButton: true,
                ),
                SizedBox(height: 20),
                // CommonContainer.Menu_Students(
                //   onIconTap: () {},
                //   mainText: 'Events',
                //   subText: '',
                //   image: AppImages.Events,
                //   addButton: false,
                // ),
                SizedBox(height: 35),
                Text(
                  'About Me',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 18,
                    color: AppColor.lightgray,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    CommonContainer.menuScrollContainer(
                      onIconTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceHistoryTeacher(),
                          ),
                        );
                      },
                      mainText: 'My\nAttendance',
                      image: AppImages.myAttendance,
                    ),
                    // SizedBox(width: 20),
                    // CommonContainer.menuScrollContainer(
                    //   onIconTap: () {},
                    //   mainText: 'Assigned\nClasses',
                    //   image: AppImages.assignedClasses,
                    // ),
                    SizedBox(width: 20),
                    CommonContainer.menuScrollContainer(
                      onIconTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfile()),
                        );
                      },
                      mainText: 'My\nProfile',
                      image: AppImages.myProfile,
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
