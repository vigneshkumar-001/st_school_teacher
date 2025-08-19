import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_loader.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Login Screen/change_mobile_number.dart';
import 'controller/teacher_data_controller.dart';
import 'package:get/get.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Map<String, String?> expandedSections = {};

  final TeacherDataController controller = Get.put(TeacherDataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader(AppColor.black));
          }

          final teacherDataResponse = controller.teacherDataResponse.value;

          if (teacherDataResponse == null) {
            return Center(child: Text("No data found"));
          }

          final profile = teacherDataResponse.data.profile;
          final classes = teacherDataResponse.data.classes;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonContainer.NavigatArrow(
                          image: AppImages.leftSideArrow,
                          imageColor: AppColor.lightBlack,
                          container: AppColor.lowLightgray,
                          onIconTap: () => Navigator.pop(context),
                          border: Border.all(
                            color: AppColor.lightgray,
                            width: 0.3,
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Assigned Classes',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        /*    ...classes.map((classInfo) {
                          // Convert className like "1" or "10" to separate number and suffix

                          return Column(
                            children: [
                              CommonContainer.myProfileContainer(
                                standardText1: classInfo.className,
                                standardText2: '',
                                standardText3: ' Standard',
                                sections: classInfo.sections,
                                sectionTextPadding: EdgeInsets.symmetric(
                                  horizontal: 36,
                                  vertical: 15,
                                ),
                                paddings: List.generate(
                                  classInfo.sections.length,
                                  (index) => EdgeInsets.symmetric(horizontal: 6),
                                ),
                                containerPadding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }).toList(),*/
                        ...classes.map((classInfo) {
                          // In your state, keep a map like Map<String, String?> expandedSectionsPerClass;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonContainer.myProfileContainer(
                                standardText1: classInfo.className,
                                standardText2: '',
                                standardText3: ' Standard',
                                sections: classInfo.sections,
                                sectionSubjects: {
                                  for (var s in classInfo.sections)
                                    s:
                                    classInfo.subjects
                                        .map((e) => e.name)
                                        .toList(),
                                },
                                expandedSection:
                                expandedSections[classInfo.className],

                                onSectionTap: (section) {
                                  setState(() {
                                    if (expandedSections['${classInfo.className}'] ==
                                        section) {
                                      expandedSections['${classInfo.className}'] =
                                      null; // collapse if same tapped
                                    } else {
                                      expandedSections['${classInfo.className}'] =
                                          section;
                                    }
                                  });
                                },
                                paddings: List.generate(
                                  classInfo.sections.length,
                                      (index) =>
                                      EdgeInsets.symmetric(horizontal: 6),
                                ),
                                containerPadding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.profileBCImage),
                        fit: BoxFit.cover,
                        alignment: Alignment(-8, -0.8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColor.lowlightWhite,
                          AppColor.lowlightWhite,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: 15, left: 15, bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppImages.profileContainerImage,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    maxLines: 2,
                                    profile.staffName,
                                    style: GoogleFont.ibmPlexSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(child: Text('')),
                              ],
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ChangeMobileNumber(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        '+91 ${profile.mobile}',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: AppColor.lightBlack,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Image.asset(
                                          AppImages.numberAdd,
                                          height: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: AppColor.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          title: Text(
                                            'Log Out',
                                            style: GoogleFont.ibmPlexSans(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to log out?',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 14,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.gray,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                        ChangeMobileNumber(
                                                          page: 'splash',
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Log Out',
                                                style: GoogleFont.ibmPlexSans(
                                                  color: AppColor.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(AppImages.logOut, height: 20),
                                      SizedBox(width: 15),
                                      Text(
                                        'LogOut',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColor.red,
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
                  Positioned(
                    right: 35,
                    bottom: 20,
                    child: InkWell(
                      onTap: () {},
                      child: Image.asset(
                        AppImages.schoolGirl,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}