import 'package:flutter/material.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

class AttendanceHistoryStudent extends StatefulWidget {
  const AttendanceHistoryStudent({super.key});

  @override
  State<AttendanceHistoryStudent> createState() =>
      _AttendanceHistoryStudentState();
}

class _AttendanceHistoryStudentState extends State<AttendanceHistoryStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            ],
          ),
        ),
      ),
    );
  }
}
