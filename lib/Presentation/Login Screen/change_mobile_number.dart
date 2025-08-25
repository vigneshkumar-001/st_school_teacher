import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:st_teacher_app/Core/Utility/app_loader.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../../../../Core/Utility/app_color.dart' show AppColor;
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';

import '../../Core/Widgets/common_container.dart';

import 'controller/login_controller.dart';

import 'otp_screen.dart';
import 'package:get/get.dart';

class ChangeMobileNumber extends StatefulWidget {
  final String? page;
  const ChangeMobileNumber({super.key, this.page});

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController mobileNumberController = TextEditingController();
  bool _showClear = false;
  bool _isFormatting = false;
  String errorText = '';

  final List<String> images1 = [
    AppImages.advertisement3,
    AppImages.advertisement4,
  ];
  final List<String> images = [
    AppImages.advertisement1,
    AppImages.advertisement2,
  ];

  @override
  void initState() {
    super.initState();
    mobileNumberController.clear();
  }

  void _formatPhoneNumber(String value) {
    setState(() {
      errorText = '';
    });
    if (_isFormatting) return;

    _isFormatting = true;
    String digitsOnly = value.replaceAll(' ', '');

    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 4 || i == 7) {
        formatted += ' ';
      }
      formatted += digitsOnly[i];
    }

    mobileNumberController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    _isFormatting = false;
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    if (widget.page == 'splash') ...[
                      Image.asset(AppImages.schoolLogo1),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Enter Mobile Number',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ] else ...[
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Change to New Mobile Number',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.lowLightgray,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:
                              mobileNumberController.text.isNotEmpty
                                  ? AppColor.black
                                  : AppColor.lowLightgray,
                          width: mobileNumberController.text.isNotEmpty ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+91',
                                style: GoogleFont.inter(
                                  fontSize: 14,
                                  color: AppColor.gray,
                                ),
                              ),
                              Text(
                                'India',
                                style: GoogleFont.inter(
                                  fontSize: 10,
                                  color: AppColor.gray,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          SizedBox(height: 35, child: VerticalDivider()),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 9,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: mobileNumberController,
                              keyboardType: TextInputType.phone,
                              style: GoogleFont.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                              maxLength: 12,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                _formatPhoneNumber(value);
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: '9000 000 000',
                                hintStyle: GoogleFont.inter(
                                  color: AppColor.borderGary,
                                  fontSize: 20,
                                ),
                                border: InputBorder.none,
                                suffixIcon:
                                    mobileNumberController.text.isNotEmpty
                                        ? GestureDetector(
                                          onTap: () {
                                            mobileNumberController.clear();
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              right: 8,
                                            ),
                                            child: Text(
                                              'Clear',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.lightgray,
                                              ),
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 4),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          errorText,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Obx(() {
                      return AppButton.button(
                        text: 'Get OTP',
                        loader:
                            loginController.isLoading.value
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : null,
                        width: double.infinity,
                        onTap: () {
                          final String mbl = mobileNumberController.text
                              .replaceAll(' ', '');
                          if (mbl.isEmpty) {
                            setState(() {
                              errorText = 'Mobile Number is Required';
                            });
                          } else if (mbl.length != 10) {
                            setState(() {
                              errorText =
                                  'Mobile Number must be exactly 10 digits';
                            });
                          } else {
                            setState(() {
                              errorText = '';
                            });
                            /*7904005315*/
                            /*8870210295*/
                            AppLogger.log.i(mbl);
                            loginController.mobileNumberLogin(mbl);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            widget.page == 'splash'
                ? Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColor.splash, Colors.white],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          if (!isKeyboardOpen) ...[
                            SizedBox(
                              height: 120,
                              child: CarouselSlider(
                                items:
                                    images.map((imagePath) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          imagePath,
                                          fit: BoxFit.cover,
                                          width: 280, // 👈 2 images per screen
                                        ),
                                      );
                                    }).toList(),
                                options: CarouselOptions(

                                  height: 120,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  viewportFraction:
                                      0.75, // 👈 ensures 2 per screen
                                  enlargeCenterPage: false,
                                  padEnds: false,
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            SizedBox(
                              height: 120,
                              child: CarouselSlider(
                                items:
                                    images1.map((imagePath) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          imagePath,
                                          fit: BoxFit.cover,
                                          width: 280, // 👈 2 images per screen
                                        ),
                                      );
                                    }).toList(),
                                options: CarouselOptions(
                                  height: 120,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  viewportFraction:
                                      0.75, // 👈 ensures 2 per screen
                                  enlargeCenterPage: false,
                                  padEnds: false,
                                  reverse: true,
                                ),
                              ),
                            ),

                            /*  CarouselSlider(
                              items:
                                  images.map((imagePath) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        width: 265,
                                      ),
                                    );
                                  }).toList(),
                              options: CarouselOptions(
                                height: 120,
                                autoPlayInterval: Duration(seconds: 3),
                                viewportFraction: 0.75,   // 👈 two images fit in one view
                                enlargeCenterPage: false, // 👈 no zoom on center image
                                disableCenter: true,      // 👈 removes centering
                                autoPlay: true,
                                // viewportFraction: 0.70,
                                // enlargeCenterPage: false,
                              ),
                            ),
                            SizedBox(height: 20),
                            CarouselSlider(
                              items:
                                  images1.map((imagePath) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        width: 320,
                                      ),
                                    );
                                  }).toList(),
                              options: CarouselOptions(
                                height: 115,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                viewportFraction: 0.85,
                                enlargeCenterPage: false,
                                reverse: true,
                              ),
                            ),*/
                            SizedBox(height: 25),
                          ],
                        ],
                      ),
                    ),

                    Positioned(
                      top: 0,
                      right: 15,
                      child: CustomTextField.textWithSmall(
                        text: 'We Are',
                        color: AppColor.weAreColor,
                        fontSize: 47,
                      ),
                    ),
                  ],
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
