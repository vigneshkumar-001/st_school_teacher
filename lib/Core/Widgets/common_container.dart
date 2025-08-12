import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st_teacher_app/Core/Utility/custom_textfield.dart';

import '../Utility/app_color.dart';
import '../Utility/app_images.dart';
import '../Utility/google_fonts.dart';

final FocusNode nextFieldFocusNode = FocusNode();

class CommonContainer {
  static Menu_Students({
    required String mainText,
    required String subText,
    required String image,
    bool addButton = false,
    VoidCallback? onIconTap,
    VoidCallback? Start,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Image.asset(image, height: 40),
            SizedBox(width: 10),
            Text(
              mainText,
              style: GoogleFont.ibmPlexSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.lightBlack,
              ),
            ),
            Spacer(),

            addButton
                ? InkWell(
                  onTap: Start,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.lowLightBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 18,
                      ),
                      child: Row(
                        children: [
                          Image.asset(AppImages.plus, height: 12.57, width: 13),
                          SizedBox(width: 7),
                          Text(
                            subText,
                            style: GoogleFont.ibmPlexSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColor.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : SizedBox.shrink(),
            SizedBox(width: 10),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppColor.lowLightgray,
            //       borderRadius: BorderRadius.circular(50),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(12.0),
            //       child: Image.asset(AppImages.rightSideArrow, height: 12),
            //     ),
            //   ),
            // ),
            CommonContainer.NavigatArrow(
              image: AppImages.rightSideArrow,
              imageColor: AppColor.lightBlack,
              container: AppColor.lowLightgray,
              onIconTap: onIconTap,
            ),
          ],
        ),
      ),
    );
  }

  static menuScrollContainer({
    required String mainText,
    required String image,
    VoidCallback? onIconTap,
  }) {
    return Container(
      height: 152.6,
      width: 168,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.asset(image, height: 76.6, width: 75.75),

            Row(
              children: [
                Text(
                  mainText,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightBlack,
                  ),
                ),
                Spacer(),
                CommonContainer.NavigatArrow(
                  image: AppImages.rightSideArrow,
                  imageColor: AppColor.blue,
                  container: AppColor.lowLightBlue,
                  onIconTap: onIconTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static NavigatArrow({
    Color? container,
    required String image,
    Color? imageColor,
    VoidCallback? onIconTap,
    Border? border,
  }) {
    return InkWell(
      onTap: onIconTap,
      child: Container(
        decoration: BoxDecoration(
          border: border,
          color: container,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(image, height: 12, color: imageColor),
        ),
      ),
    );
  }

  static StudentsList({required String mainText, VoidCallback? onIconTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        children: [
          InkWell(
            onTap: onIconTap,
            child: Row(
              children: [
                Text(
                  mainText,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 14,
                    color: AppColor.black,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: onIconTap,
                  child: Image.asset(
                    AppImages.rightSideArrow,
                    height: 10,
                    color: AppColor.lightgray,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(color: AppColor.lowLightgray),
        ],
      ),
    );
  }

  static announcementsScreen({
    required String mainText,
    required String backRoundImage,
    required String additionalText1,
    required String additionalText2,
    required String additionalText3,
    required String additionalText4,
    VoidCallback? onDetailsTap,
    IconData? iconData,
    double verticalPadding = 9,
    Color? gradientStartColor,
    Color? gradientEndColor,
  }) {
    return InkWell(
      onTap: onDetailsTap,
      child: Stack(
        children: [
          Image.asset(backRoundImage),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,

            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradientStartColor ?? AppColor.black.withOpacity(0.01),
                    gradientEndColor ?? AppColor.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: verticalPadding,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          mainText,
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                          ),
                        ),
                        Spacer(),
                        Icon(iconData, size: 22, color: AppColor.white),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (additionalText1 != '')
                              Text(
                                additionalText1,
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 12,
                                  color: AppColor.lightgray,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Row(
                              children: [
                                Text(
                                  additionalText2,
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  additionalText3,
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  additionalText4,
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget fillingContainer({
    required String text,
    required TextEditingController controller,
    String? imagePath,
    bool verticalDivider = true,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onDetailsTap,
    double imageSize = 20,
    int? maxLine,
    int flex = 4,
    bool isTamil = false,
    bool isAadhaar = false,
    bool isDOB = false,
    bool isMobile = false,
    bool isPincode = false,
    BuildContext? context,
    FormFieldValidator<String>? validator,
    bool isError = false,
    String? errorText,
    bool? hasError = false,
    FocusNode? focusNode,
    Color borderColor = AppColor.red,
    Color? imageColor,
  }) {
    DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.lightWhite,
            border: Border.all(
              color: isError ? AppColor.red : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: flex,
                  child: GestureDetector(
                    onTap:
                        isDOB && context != null
                            ? () async {
                              final DateTime startDate = DateTime(2021, 6, 1);
                              final DateTime endDate = DateTime(2022, 5, 31);
                              final DateTime initialDate = DateTime(2021, 6, 2);

                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      dialogBackgroundColor: AppColor.white,
                                      colorScheme: ColorScheme.light(
                                        primary: AppColor.blue,
                                        onPrimary: Colors.white,
                                        onSurface: AppColor.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColor.blue,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                if (pickedDate.isBefore(startDate) ||
                                    pickedDate.isAfter(endDate)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Invalid Date of Birth!\nPlease select a date between 01-06-2021 and 31-05-2022.',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  controller.text =
                                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(nextFieldFocusNode);
                                }
                              }
                            }
                            : null,

                    child: AbsorbPointer(
                      absorbing: isDOB,
                      child: TextFormField(
                        focusNode: focusNode,
                        onChanged: onChanged,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller,
                        validator: validator,
                        maxLines: maxLine,
                        maxLength:
                            isMobile
                                ? 10
                                : isAadhaar
                                ? 12
                                : isPincode
                                ? 6
                                : null,
                        // keyboardType:
                        // isMobile || isAadhaar || isPincode
                        //     ? TextInputType.number
                        //     : isDOB
                        //     ? TextInputType.none
                        //     : TextInputType.emailAddress,
                        keyboardType: keyboardType,
                        inputFormatters:
                            isMobile || isAadhaar || isPincode
                                ? [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                    isMobile
                                        ? 10
                                        : isAadhaar
                                        ? 12
                                        : 6,
                                  ),
                                ]
                                : [],
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          color: AppColor.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '',
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                          isDense: true,
                          // errorText: errorText,
                        ),
                      ),
                    ),
                  ),
                ),

                if (verticalDivider)
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
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                SizedBox(width: 20),

                if (imagePath == null)
                  Expanded(
                    child: CustomTextField.textWithSmall(
                      text: text,
                      fontSize: 14,
                      color: AppColor.gray,
                    ),
                  ),
                if (imagePath != null)
                  InkWell(
                    onTap: () {
                      controller.clear();
                      if (onDetailsTap != null) {
                        onDetailsTap();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Image.asset(
                        imagePath,
                        height: imageSize,
                        width: imageSize,
                        color: imageColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  static textWithSmall({
    required String text,
    Color? color = AppColor.gray,
    FontWeight? fontWeight = FontWeight.w500,
    TextAlign? textAlign,
    double? fontSize = 16,
  }) {
    return Text(
      textAlign: textAlign,
      text,
      style: GoogleFont.ibmPlexSans(
        fontSize: fontSize!,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  static addMore({
    required String mainText,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.borderGary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          child: Row(
            children: [
              Image.asset(imagePath!, height: 14),
              SizedBox(width: 5),
              Text(
                mainText,
                style: GoogleFont.ibmPlexSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColor.gray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static homeworkhistory({
    required String homeWorkText,
    required String avatarImage,
    required String mainText,
    String? subText,
    String? done,
    required String smaleText,
    required String time,
    required String className,
    required String aText1,
    required String aText2,
    required Color backRoundColor,
    Color? backRoundColors,
    Gradient? gradient,
    VoidCallback? onIconTap,
    VoidCallback? onTap,
    String? homeWorkImage,
    String? view,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: backRoundColor,
          border: Border.all(color: AppColor.lowLightgray, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeWorkText,
                style: GoogleFont.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColor.gray,
                ),
              ),
              SizedBox(height: 12),
              Text(
                mainText,
                style: GoogleFont.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColor.black,
                ),
              ),
              // SizedBox(height: 6),
              // subText.toString().isEmpty
              //     ? Container()
              //     : Text(
              //       subText ?? '',
              //       style: GoogleFonts.inter(
              //         fontSize: 15,
              //         fontWeight: FontWeight.w500,
              //         color: AppColor.lightBlack,
              //       ),
              //     ),
              // SizedBox(height: 6),
              // Text(
              //   smaleText,
              //   style: GoogleFonts.inter(
              //     fontSize: 12,
              //     color: AppColor.gray,
              //   ),
              // ),
              RichText(
                text: TextSpan(
                  text: subText,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                  children: [
                    TextSpan(
                      text: done,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.gray,
                                  ),
                                ),
                                TextSpan(
                                  text: 'C',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
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
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            time,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColor.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  view != null
                      ? InkWell(
                        onTap: onTap,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColor.borderGary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                            child: Text(
                              view ?? '',
                              style: GoogleFont.inter(
                                fontSize: 12,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
                  InkWell(
                    onTap: onIconTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: gradient == null ? backRoundColors : null,
                        gradient: gradient,
                        border: Border.all(
                          color: AppColor.lowLightgray,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(
                          color: AppColor.white,
                          CupertinoIcons.right_chevron,
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
    );
  }

  static carouselSlider({
    required String mainText1,
    required String mainText2,
    required String iconImage,
    required String bcImage,
    Gradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Image.asset(bcImage, height: 249, width: 187),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      mainText1,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColor.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Flexible(
                    child: Text(
                      mainText2,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: AppColor.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(iconImage, fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static checkMark({required VoidCallback onTap, String? imagePath}) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.blueG1, AppColor.blue],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(17.0),
              child: Image.asset(imagePath ?? '', height: 20, width: 20),
            ),
          ),
        ),
      ),
    );
  }

  static Widget myProfileContainer({
    required String standardText1,
    required String standardText2,
    required String standardText3,
    required List<String> sections,
    VoidCallback? onIconTap,
    List<EdgeInsets>? paddings,
    EdgeInsetsGeometry? containerPadding,
    EdgeInsetsGeometry? sectionTextPadding,
    Color? backgroundColor,
    Color? sectionBgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.profileClass1st,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding:
            containerPadding ??
            const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: standardText1,
                style: GoogleFont.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
                children: [
                  TextSpan(
                    text: standardText2,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  TextSpan(
                    text: standardText3,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 16,

                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              children:
                  sections.asMap().entries.map((entry) {
                    final index = entry.key;
                    final section = entry.value;
                    final padding =
                        paddings != null && paddings.length > index
                            ? paddings[index]
                            : const EdgeInsets.only(right: 10);

                    return Padding(
                      padding: padding,
                      child: InkWell(
                        onTap: onIconTap,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                sectionBgColor ??
                                AppColor.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.white),
                          ),
                          child: Padding(
                            padding:
                                sectionTextPadding ??
                                const EdgeInsets.symmetric(
                                  horizontal: 39,
                                  vertical: 22,
                                ),
                            child: Text(
                              section,
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget quizContainer({
    required String leftTextNumber,
    required String leftValue,
    required String rightTextNumber,
    required String rightValue,
    required bool leftSelected,
    required bool rightSelected,
    required bool isQuizCompleted,
    VoidCallback? leftOnTap,
    VoidCallback? rightOnTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: leftOnTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                gradient:
                    leftSelected
                        ? LinearGradient(
                          colors: [Colors.white, AppColor.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                        : null,
                color: leftSelected ? null : AppColor.lowLightgray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      leftSelected
                          ? (isQuizCompleted ? AppColor.green : AppColor.green)
                          : AppColor.lowLightgray,
                  width: leftSelected ? 3 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField.textWithSmall(text: leftTextNumber),
                  ),
                  Expanded(
                    child: CustomTextField.textWithSmall(
                      text: leftValue,
                      fontWeight:
                          leftSelected ? FontWeight.w800 : FontWeight.w500,
                      // color: leftSelected ? AppColor.blue : AppColor.black,
                      color:
                          leftSelected
                              ? (isQuizCompleted
                                  ? AppColor.green
                                  : AppColor.black)
                              : AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 20),

        Expanded(
          child: GestureDetector(
            onTap: rightOnTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                gradient:
                    rightSelected
                        ? LinearGradient(
                          colors: [Colors.white, AppColor.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                        : null,
                color: rightSelected ? null : AppColor.lowLightgray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      rightSelected
                          ? (isQuizCompleted ? AppColor.green : AppColor.green)
                          : AppColor.lowLightgray,
                  width: rightSelected ? 3 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField.textWithSmall(text: rightTextNumber),
                  ),
                  Expanded(
                    child: CustomTextField.textWithSmall(
                      text: rightValue,
                      fontWeight:
                          rightSelected ? FontWeight.w800 : FontWeight.w500,

                      color:
                          rightSelected
                              ? (isQuizCompleted
                                  ? AppColor.green
                                  : AppColor.green)
                              : AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static quizContainer1({
    required String leftTextNumber,
    required String leftValue,
    required bool isSelected,
    VoidCallback? onTap,
    required bool isQuizCompleted,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.white : AppColor.lowLightgray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected
                          ? (isQuizCompleted ? AppColor.green : AppColor.green)
                          : AppColor.lowLightgray,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextField.textWithSmall(
                        text: leftTextNumber,

                        color: AppColor.borderGary,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: CustomTextField.textWithSmall(
                        text: leftValue,

                        color:
                            isSelected
                                ? (isQuizCompleted
                                    ? AppColor.green
                                    : AppColor.green)
                                : AppColor.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
