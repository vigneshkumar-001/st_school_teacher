import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:st_teacher_app/Core/Utility/app_loader.dart';
import 'package:st_teacher_app/Core/Widgets/common_container.dart';
import 'package:st_teacher_app/Presentation/Login%20Screen/controller/login_controller.dart';

import '../../../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../Home/home.dart';

class OtpScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? pages;
  const OtpScreen({super.key, this.mobileNumber, this.pages});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  final TextEditingController otp = TextEditingController();
  final LoginController otpController = LoginController();
  String? otpError;
  String verifyCode = '';
  StreamController<ErrorAnimationType>? errorController;
  @override
  Widget build(BuildContext context) {
    String mobileNumber = widget.mobileNumber.toString() ?? '';
    String maskMobileNumber =
        "******" + mobileNumber.substring(mobileNumber.length - 5);
    return Scaffold(
      backgroundColor: AppColor.white,

      body: Obx(() {
        if (otpController.isOtpLoading.value) {
          return AppLoader.circularLoader(AppColor.black);
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomContainer.leftSaitArrow(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                SizedBox(height: 20),
                Text(
                  'Enter OTP',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightBlack,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'OTP sent to $maskMobileNumber, please check and enter below. If you’re not received OTP',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 14,
                    color: AppColor.gray,
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Resend OTP',
                    style: GoogleFont.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blue,
                    ),
                  ),
                ),
                SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PinCodeTextField(
                    onCompleted: (value) async {},

                    autoFocus: otp.text.isEmpty,
                    appContext: context,
                    // pastedTextStyle: TextStyle(
                    //   color: Colors.green.shade600,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    length: 4,

                    // obscureText: true,
                    // obscuringCharacter: '*',
                    // obscuringWidget: const FlutterLogo(size: 24,),
                    blinkWhenObscuring: true,
                    mainAxisAlignment: MainAxisAlignment.start,
                    autoDisposeControllers: false,

                    // validator: (v) {
                    //   if (v == null || v.length != 4)
                    //     return 'Enter valid 4-digit OTP';
                    //   return null;
                    // },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(17),
                      fieldHeight: 60,
                      fieldWidth: 60,
                      selectedColor: AppColor.black,
                      activeColor: AppColor.white,
                      activeFillColor: AppColor.lowLightgray,
                      inactiveColor: AppColor.lowLightgray,
                      selectedFillColor: AppColor.white,
                      fieldOuterPadding: EdgeInsets.symmetric(horizontal: 12),
                      inactiveFillColor: AppColor.lowLightgray,
                    ),
                    cursorColor: AppColor.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    controller: otp,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: AppColor.lightBlack,
                        blurRadius: 5,
                      ),
                    ],
                    // validator: (value) {
                    //   if (value == null || value.length != 4) {
                    //     return 'Please enter a valid 4-digit OTP';
                    //   }
                    //   return null;
                    // },
                    // onCompleted: (value) async {},
                    onChanged: (value) {
                      debugPrint(value);
                      verifyCode = value;

                      if (otpError != null && value.isNotEmpty) {
                        setState(() {
                          otpError = null;
                        });
                      }
                    },

                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
                if (otpError != null)
                  Center(
                    child: Text(
                      otpError!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 30),

                CommonContainer.checkMark(
                  onTap: () {
                    if (otp.text.length != 4) {
                      errorController?.add(ErrorAnimationType.shake);
                      setState(() {
                        otpError = 'Please enter a valid 4-digit OTP';
                      });
                      return;
                    }

                    // Proceed if OTP is valid

                    if (widget.pages == 'splash') {
                      String Otp = otp.text.toString();
                      String mobileNumber =
                          widget.mobileNumber.toString() ?? '';
                      otpController.otpLogin(phone: mobileNumber, otp: Otp);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Home(pages: 'homeScreen'),
                      //   ),
                      // );
                    } else {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => QuizScreen()),
                      // );
                    }
                  },
                  imagePath: AppImages.tick,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
