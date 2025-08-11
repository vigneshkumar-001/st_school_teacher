import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'homework_history.dart';

class HomeworkCreatePreview extends StatefulWidget {
  const HomeworkCreatePreview({super.key});

  @override
  State<HomeworkCreatePreview> createState() => _HomeworkCreatePreviewState();
}

class _HomeworkCreatePreviewState extends State<HomeworkCreatePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                    'Homework Preview',
                    style: GoogleFont.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow.withOpacity(0.2),
                    //   ], // gradient top to bottom
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    // ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(AppImages.homeworkPreviewImage1),
                              SizedBox(height: 20),
                              Image.asset(AppImages.homeworkPreviewImage2),
                              SizedBox(height: 20),
                              Text(
                                'Draw Single cell',
                                style: GoogleFont.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Vestibulum non ipsum risus. Quisque et sem eu \nvelit varius pellentesque et sit amet diam. Phasellus \neros libero, finibus eu magna vel, viverra pharetra \nvelit. Nullam congue sapien neque, dapibus \ndignissim magna elementum at. Class aptent taciti \nsociosqu ad litora torquent per conubia nostra, per \ninceptos himenaeos.',
                                style: GoogleFont.inter(
                                  fontSize: 12,
                                  color: AppColor.gray,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                '1.Task',
                                style: GoogleFont.inter(
                                  fontSize: 12,
                                  color: AppColor.gray,
                                ),
                              ),
                              Text(
                                '2.Tksa',
                                style: GoogleFont.inter(
                                  fontSize: 12,
                                  color: AppColor.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 25,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.black.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child: Image.asset(AppImages.avatar1),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Science Homework',
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.black.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.clock_fill,
                                          size: 35,
                                          color: AppColor.lightBlack
                                              .withOpacity(0.3),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '4.30Pm',
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '18.Jul.25',
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.gray,
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
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.lowLightgray,
                                  border: Border.all(
                                    color: AppColor.lowLightBlue,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 9,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              color: AppColor.gray,
                                              CupertinoIcons.left_chevron,
                                              size: 20,
                                            ),
                                            SizedBox(width: 11),
                                            Text(
                                              'Back to Edit',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.gray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              AppButton.button(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeworkHistory(),
                                    ),
                                  );
                                },
                                width: 145,
                                height: 60,
                                text: 'Publish',
                                image: AppImages.buttonArrow,
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
