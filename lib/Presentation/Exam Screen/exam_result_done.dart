import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:st_teacher_app/Presentation/Exam%20Screen/result_list.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

class ExamResultDone extends StatefulWidget {
  const ExamResultDone({super.key});

  @override
  State<ExamResultDone> createState() => _ExamResultDoneState();
}

class _ExamResultDoneState extends State<ExamResultDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
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
              Spacer(),
              Image.asset(AppImages.greenTick),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Mid Term Result ',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColor.green,
                  ),
                ),
              ),
              Center(
                child: Text(
                  ' Declared Successfully',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColor.green,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  '50 students result uploaded',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.gray,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultList()),
                    );
                  },
                  child: DottedBorder(
                    color: AppColor.blue,
                    strokeWidth: 1.5,
                    dashPattern: [8, 4],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      child: Text(
                        'Show All Students',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColor.blue,
                        ),
                      ),
                    ),
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
