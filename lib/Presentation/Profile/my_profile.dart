/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_loader.dart';
import 'package:st_teacher_app/Presentation/Login%20Screen/controller/login_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Login Screen/change_mobile_number.dart';
import '../Menu/profile_screen.dart';
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
  final LoginController loginController = Get.put(LoginController());

  void _OTPonMobileNoEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.20,
          maxChildSize: 0.50,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Obx(() {
                final data = controller.teacherDataResponse.value?.data;
                return ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 30,
                        decoration: BoxDecoration(color: AppColor.gray),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: AppColor.lowLightgray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.call),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeMobileNumber(),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Mobile Number',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColor.gray,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data?.profile.mobile.toString() ?? "",
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: AppColor.lightBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeMobileNumber(),
                            ),
                          );
                        },
                        child: Image.asset(
                          AppImages.rightSideArrow,
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen()),
                        );
                      },
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            data?.profile.profileImg ?? '',
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),

                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColor.gray,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Profile Picture',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: AppColor.lightBlack,
                              ),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(),
                              ),
                            );
                          },
                          child: Image.asset(
                            AppImages.rightSideArrow,
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getTeacherClassData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          final teacherDataResponse = controller.teacherDataResponse.value;

          if (teacherDataResponse == null) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 80),
              decoration: BoxDecoration(color: AppColor.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'No data found',
                      style: GoogleFont.ibmPlexSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColor.gray,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Image.asset(AppImages.noDataFound),
                ],
              ),
            );
          }

          final profile = teacherDataResponse.data.profile;
          final classes = teacherDataResponse.data.classes;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        alignment: Alignment(-4, -0.8),
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
                                      fontSize: 22,
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
                                    _OTPonMobileNoEdit(context);
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
                                            'Logout',
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
                                                loginController.logout();
                                                // Navigator.pushReplacement(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder:
                                                //         (context) =>
                                                //   ChangeMobileNumber(
                                                //               page: 'splash',
                                                //             ),
                                                //
                                                //   ),
                                                // );
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
                                        'Logout',
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
                    bottom: 25,
                    child: InkWell(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:
                            (profile?.profileImg?.isNotEmpty ?? false)
                                ? CachedNetworkImage(
                                  imageUrl: profile.profileImg ?? '',
                                  fit: BoxFit.cover,
                                  height: 110,
                                  width: 110,
                                  placeholder:
                                      (context, url) => Container(
                                        height: 180,
                                        alignment: Alignment.center,
                                        child: const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                )
                                : Container(
                                  height: 110,
                                  width: 110,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        // Image.network(
                        //   profile.profileImg ?? '', // safely pass empty string if null
                        //   height: 80,
                        //   width: 80,
                        //   fit: BoxFit.cover,
                        //   errorBuilder: (context, error, stackTrace) {
                        //     // Fallback if image is invalid or failed to load
                        //     return Container(
                        //       height: 80,
                        //       width: 80,
                        //       color: Colors.grey.shade200,
                        //       child: const Icon(
                        //         Icons.broken_image,
                        //         size: 40,
                        //         color: Colors.grey,
                        //       ),
                        //     );
                        //   },
                        // ),
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
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Login Screen/change_mobile_number.dart';
import '../Login Screen/controller/login_controller.dart';
import '../Menu/profile_screen.dart';
import 'controller/teacher_data_controller.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Map<String, String?> expandedSections = {};

  final TeacherDataController controller = Get.put(TeacherDataController());
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getTeacherClassData();
    });
  }

  // -------------------- Reusable: No data view (TOP area) --------------------
  Widget _buildNoData() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(color: AppColor.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'No data found',
            style: GoogleFont.ibmPlexSans(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColor.gray,
            ),
          ),
          Image.asset(AppImages.noDataFound),
        ],
      ),
    );
  }

  // -------------------- BottomSheet: change mobile/picture -------------------
  void _OTPonMobileNoEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.20,
          maxChildSize: 0.50,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Obx(() {
                final data = controller.teacherDataResponse.value?.data;
                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 30,
                        decoration: BoxDecoration(color: AppColor.gray),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: AppColor.lowLightgray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.call),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangeMobileNumber(),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Mobile Number',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColor.gray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (data?.profile.mobile ?? '').toString(),
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: AppColor.lightBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangeMobileNumber(),
                            ),
                          );
                        },
                        child: Image.asset(
                          AppImages.rightSideArrow,
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            data?.profile.profileImg ?? '',
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColor.gray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Profile Picture',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: AppColor.lightBlack,
                              ),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: Image.asset(
                            AppImages.rightSideArrow,
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          },
        );
      },
    );
  }

  // -------------------- Bottom profile Stack (ALWAYS visible) ----------------
  Widget _bottomProfile(BuildContext context, dynamic profile) {
    // fallbacks if profile is null
    final String staffName = (profile?.staffName ?? 'Teacher').toString();
    final String mobile = (profile?.mobile ?? '—').toString();
    final String? profileImg = profile?.profileImg as String?;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.profileBCImage),
              fit: BoxFit.cover,
              alignment: const Alignment(-4, -0.8),
            ),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColor.lowlightWhite, AppColor.lowlightWhite],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImages.profileContainerImage, fit: BoxFit.cover),
                const SizedBox(height: 20),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          staffName,
                          maxLines: 2,
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
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
                        onTap: () => _OTPonMobileNoEdit(context),
                        child: Row(
                          children: [
                            Text(
                              mobile == '—' ? mobile : '+91 $mobile',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColor.lightBlack,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Image.asset(
                                AppImages.numberAdd,
                                height: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColor.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: Text(
                                  'Logout',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to log out?',
                                  style: GoogleFont.ibmPlexSans(fontSize: 14),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFont.ibmPlexSans(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => loginController.logout(),
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
                            const SizedBox(width: 15),
                            Text(
                              'Logout',
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

        // Profile image floating at bottom-right
        Positioned(
          right: 30,
          bottom: 40,
          child: InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:
                  (profileImg != null && profileImg.isNotEmpty)
                      ? CachedNetworkImage(
                        imageUrl: profileImg,
                        fit: BoxFit.cover,
                        height: 110,
                        width: 110,
                        placeholder:
                            (context, url) => SizedBox(
                              height: 110,
                              width: 110,
                              child: const Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                      )
                      : Container(
                        height: 110,
                        width: 110,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------- Top content (classes list) -------------------------
  Widget _buildTopContent(List classes) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
            const SizedBox(height: 25),
            Text(
              'Assigned Classes',
              style: GoogleFont.ibmPlexSans(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 20),

            ...classes.map((classInfo) {
              // classInfo should have: className, sections(List<String>), subjects(List<{name}>)
              final List sections = classInfo.sections ?? [];
              final List subjects = classInfo.subjects ?? [];
              final Map<String, List<String>> sectionSubjects = {
                for (var s in sections)
                  s.toString():
                      subjects.map<String>((e) => e.name.toString()).toList(),
              };

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonContainer.myProfileContainer(
                    standardText1: classInfo.className,
                    standardText2: '',
                    standardText3: ' Standard',
                    sections: sections.cast<String>(),
                    sectionSubjects: sectionSubjects,
                    expandedSection: expandedSections[classInfo.className],
                    onSectionTap: (section) {
                      setState(() {
                        if (expandedSections[classInfo.className] == section) {
                          expandedSections[classInfo.className] =
                              null; // collapse
                        } else {
                          expandedSections[classInfo.className] = section;
                        }
                      });
                    },
                    paddings: List.generate(
                      sections.length,
                      (index) => const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    containerPadding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------- BUILD ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          final resp = controller.teacherDataResponse.value;
          final profile = resp?.data?.profile; // dynamic (safe)
          final classes = (resp?.data?.classes ?? []) as List;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP: either list (when classes present) OR "No data found"
              Expanded(
                child:
                    classes.isEmpty
                        ? _buildNoData()
                        : _buildTopContent(classes),
              ),

              // BOTTOM: always visible (uses safe fallbacks if profile is null)
              _bottomProfile(context, profile),
            ],
          );
        }),
      ),
    );
  }
}
