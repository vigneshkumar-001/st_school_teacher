import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st_teacher_app/Core/Utility/custom_textfield.dart';

import '../Utility/app_color.dart';
import '../Utility/app_images.dart';
import '../Utility/google_fonts.dart';
import 'package:flutter/material.dart';

final FocusNode nextFieldFocusNode = FocusNode();

enum DatePickMode { none, single, range }

class CommonContainer {
  static Menu_Students({
    required String mainText,
    required String subText,
    required String image,
    bool addButton = false,
    VoidCallback? onIconTap,
    VoidCallback? Start,
    Color? color = AppColor.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
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
    bool? blueContainer,
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

  static StudentsList({
    required String mainText,
    String? subText, // 👈 added
    VoidCallback? onIconTap,
    bool blueContainer = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: onIconTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  mainText,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 14,
                    color: AppColor.black,
                  ),
                ),
                Spacer(),
                if (blueContainer)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.blueStdContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      child: Text(
                        '7 out of 10',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColor.blue,
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 10),
                Image.asset(
                  AppImages.rightSideArrow,
                  height: 10,
                  color: AppColor.lightgray,
                ),
              ],
            ),
            if (subText != null) ...[
              SizedBox(height: 4),
              Text(
                subText,
                style: GoogleFont.ibmPlexSans(
                  fontSize: 12,
                  color: AppColor.lightgray,
                ),
              ),
            ],
            SizedBox(height: 10),
            Divider(color: AppColor.lowLightgray),
          ],
        ),
      ),
    );
  }

  /*
    static StudentsList({
      required String mainText,
      VoidCallback? onIconTap,


    static StudentsList({
      required String mainText,
      VoidCallback? onIconTap,

      bool blueContainer = false,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: InkWell(
          onTap: onIconTap,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    mainText,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 14,
                      color: AppColor.black,
                    ),
                  ),
                  Spacer(),
                  if (blueContainer)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.blueStdContainer,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Text(
                          '7 out of 10',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColor.blue,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 10),
                  Image.asset(
                    AppImages.rightSideArrow,
                    height: 10,
                    color: AppColor.lightgray,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: AppColor.lowLightgray),
            ],
          ),
        ),
      );
    }
  */

  static announcementsScreen({
    required String mainText,
    required String backRoundImage,
    required String additionalText1,
    required String additionalText2,
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
          Image.network(backRoundImage),
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
                                  color: AppColor.lowLightgray,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              additionalText2,
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
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
                colors: [AppColor.blueG1, AppColor.blueG2],
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

  static Widget fillingContainer({
    required String text,
    TextEditingController? controller,
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
    FocusNode? focusNode,
    Color borderColor = AppColor.red,
    Color? imageColor,
  }) {
    return FormField<String>(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        final hasError = state.hasError;

        Future<void> _handleDobTap() async {
          if (!isDOB || context == null) return;

          final DateTime startDate = DateTime(2021, 6, 1);
          final DateTime endDate = DateTime(2022, 5, 31);
          final DateTime initialDate = DateTime(2021, 6, 2);

          final pickedDate = await showDatePicker(
            context: context!,
            initialDate: initialDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2025),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  dialogBackgroundColor: AppColor.white,
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.blue,
                    onPrimary: Colors.white,
                    onSurface: AppColor.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: AppColor.blue),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            if (pickedDate.isBefore(startDate) || pickedDate.isAfter(endDate)) {
              ScaffoldMessenger.of(context!).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Invalid Date of Birth!\nPlease select a date between 01-06-2021 and 31-05-2022.',
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            } else {
              controller?.text =
                  "${pickedDate.day.toString().padLeft(2, '0')}-"
                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                  "${pickedDate.year}";
              // optionally move focus
              // FocusScope.of(context!).nextFocus();
              state.didChange(controller?.text ?? '');
            }
          }
        }

        final effectiveInputFormatters =
            isMobile || isAadhaar || isPincode
                ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    isMobile ? 10 : (isAadhaar ? 12 : 6),
                  ),
                ]
                : (inputFormatters ?? const []);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.lightWhite,
                border: Border.all(
                  color: hasError ? AppColor.red : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: flex,
                      child: GestureDetector(
                        onTap: _handleDobTap,
                        child: AbsorbPointer(
                          absorbing: isDOB, // disable keyboard if DOB
                          child: TextFormField(
                            focusNode: focusNode,
                            controller: controller,
                            maxLines: maxLine,
                            maxLength:
                                isMobile
                                    ? 10
                                    : (isAadhaar ? 12 : (isPincode ? 6 : null)),
                            keyboardType: keyboardType,
                            inputFormatters: effectiveInputFormatters,
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                            decoration: const InputDecoration(
                              hintText: '',
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              // we show our own error below; suppress TF default
                              errorText: null,
                            ),
                            onChanged: (v) {
                              state.didChange(v);
                              onChanged?.call(v);
                            },
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
                    const SizedBox(width: 20),

                    if (imagePath != null)
                      InkWell(
                        onTap: () {
                          controller?.clear();
                          state.didChange(''); // clear validation state
                          onDetailsTap?.call();
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

            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
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
    required String CText1,
    required Color backRoundColor,
    Color? backRoundColors,
    Gradient? gradient,
    VoidCallback? onIconTap,
    VoidCallback? onTap,
    String? homeWorkImage,
    String? view,
    required String section,
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
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            CText1,
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.gray,
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
                              horizontal: 18,
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
                        child: Image.asset(
                          AppImages.rightSideArrow,
                          color: AppColor.white,
                          height: 14,
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

  static examHistory({
    required Color backRoundColor,
    required String mainText,
    String? subText1,
    String? subText2,
    String? subText21,
    String? subText3Text,
    required String time,
    VoidCallback? onIconTap,
    Gradient? gradient,
    Color? backRoundColors,
  }) {
    final bool showSubText3 =
        subText3Text != null && subText3Text!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: backRoundColor,
          border: Border.all(color: AppColor.lowLightgray, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainText,
                style: GoogleFont.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColor.black,
                ),
              ),
              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Announce on ',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 11,
                    color: AppColor.gray,
                  ),
                  children: [
                    TextSpan(
                      text: subText1 ?? '',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Scheduled on ',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 11,
                        color: AppColor.gray,
                      ),
                    ),
                    TextSpan(
                      text: subText2 ?? '',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                    TextSpan(
                      text: ' to ',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 11,
                        color: AppColor.gray,
                      ),
                    ),
                    TextSpan(
                      text: subText21 ?? '',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              if (showSubText3)
                RichText(
                  text: TextSpan(
                    text: 'Result filled on ',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 11,
                      color: AppColor.gray,
                    ),
                    children: [
                      TextSpan(
                        // CHANGE: use the actual value
                        text: subText3Text!,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 11,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 11,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Result',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColor.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              AppImages.rightSideArrow,
                              height: 10,
                              color: AppColor.white,
                            ),
                          ],
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

  /*  // inside CommonContainer
    static Widget quizContainer({
      required String leftTextNumber,
      required String leftValue,
      required String rightTextNumber,
      required String rightValue,
      required bool leftSelected,
      required bool rightSelected,
      required bool isQuizCompleted,
      Color? leftBorderColor,
      Color? rightBorderColor,
      VoidCallback? leftOnTap,
      VoidCallback? rightOnTap,
    }) {
      // If right side has no option, render a transparent placeholder
      final bool rightIsPlaceholder =
          rightOnTap == null && rightTextNumber.isEmpty && rightValue.isEmpty;

      return Row(
        children: [
          // LEFT
          Expanded(
            child: GestureDetector(
              onTap: leftOnTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  gradient:
                      leftSelected
                          ? const LinearGradient(
                            colors: [Colors.white, Colors.white],
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
                        color:
                            leftSelected
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

          const SizedBox(width: 20),

          // RIGHT (real card or transparent placeholder)
          Expanded(
            child:
                rightIsPlaceholder
                    ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.transparent, width: 1),
                      ),
                      child: Row(
                        children: const [
                          Expanded(child: SizedBox()),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    )
                    : GestureDetector(
                      onTap: rightOnTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient:
                              rightSelected
                                  ? const LinearGradient(
                                    colors: [Colors.white, Colors.white],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                  : null,
                          color: rightSelected ? null : AppColor.lowLightgray,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                rightSelected
                                    ? (isQuizCompleted
                                        ? AppColor.green
                                        : AppColor.green)
                                    : AppColor.lowLightgray,
                            width: rightSelected ? 3 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField.textWithSmall(
                                text: rightTextNumber,
                              ),
                            ),
                            Expanded(
                              child: CustomTextField.textWithSmall(
                                text: rightValue,
                                fontWeight:
                                    rightSelected
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                color: AppColor.black,
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

      Color? borderColor,
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

                          color: AppColor.black,
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
    }*/

  // inside CommonContainer

  /*  static Widget quizContainer({
    required String leftTextNumber,
    required String leftValue,
    required String rightTextNumber,
    required String rightValue,
    required bool leftSelected, // kept for API compatibility (ignored)
    required bool rightSelected, // kept for API compatibility (ignored)
    required bool isQuizCompleted, // kept for API compatibility (ignored)
    Color? leftBorderColor,
    Color? rightBorderColor,
    VoidCallback? leftOnTap,
    VoidCallback? rightOnTap,
  }) {
    // If right side has no option, render a transparent placeholder
    final bool rightIsPlaceholder =
        rightOnTap == null && rightTextNumber.isEmpty && rightValue.isEmpty;

    final Color lBorder = leftBorderColor ?? AppColor.lowLightgray;
    final Color rBorder =
        rightIsPlaceholder
            ? Colors.transparent
            : (rightBorderColor ?? AppColor.lowLightgray);

    return Row(
      children: [
        // LEFT
        Expanded(
          child: GestureDetector(
            onTap: leftOnTap, // can be null to disable
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.transparent, // ✅ no fill
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: lBorder, // ✅ border color from parent
                  width: 2, // thicker to show clearly
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
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // RIGHT (real card or transparent placeholder)
        Expanded(
          child:
              rightIsPlaceholder
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.transparent, width: 2),
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  )
                  : GestureDetector(
                    onTap: rightOnTap, // can be null to disable
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // ✅ no fill
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: rBorder, // ✅ border color from parent
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField.textWithSmall(
                              text: rightTextNumber,
                            ),
                          ),
                          Expanded(
                            child: CustomTextField.textWithSmall(
                              text: rightValue,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
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

  static Widget quizContainer1({
    required String leftTextNumber,
    required String leftValue,
    required bool isSelected, // kept for API compatibility (ignored)
    Color? borderColor,
    VoidCallback? onTap,
    required bool isQuizCompleted, // kept for API compatibility (ignored)
  }) {
    final Color bColor = borderColor ?? AppColor.lowLightgray;

    return GestureDetector(
      onTap: onTap, // can be null to disable
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.transparent, // ✅ no fill
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: bColor, // ✅ border color from parent
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextField.textWithSmall(
                        text: leftTextNumber,
                        color: AppColor.borderGary,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: CustomTextField.textWithSmall(
                        text: leftValue,
                        color: AppColor.black,
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
  }*/

  static Widget quizContainer({
    required String leftTextNumber,
    required String leftValue,
    required String rightTextNumber,
    required String rightValue,
    required bool leftSelected,
    required bool rightSelected,
    required bool isQuizCompleted,
    Color? leftBorderColor,
    Color? rightBorderColor,
    VoidCallback? leftOnTap,
    VoidCallback? rightOnTap,
  }) {
    final bool rightIsPlaceholder =
        rightOnTap == null && rightTextNumber.isEmpty && rightValue.isEmpty;

    return Row(
      children: [
        // LEFT
        Expanded(
          child: GestureDetector(
            onTap: leftOnTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: leftSelected ? Colors.white : AppColor.lowLightgray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: leftBorderColor ?? AppColor.lowLightgray,
                  width: 2,
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
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // RIGHT
        Expanded(
          child: rightIsPlaceholder
              ? Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              // ❌ FIXED: changed leftSelected → rightSelected
              color: rightSelected ? Colors.white : AppColor.lowLightgray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent, width: 2),
            ),
          )
              : GestureDetector(
            onTap: rightOnTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: rightSelected ? Colors.white : AppColor.lowLightgray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: rightBorderColor ?? AppColor.lowLightgray,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField.textWithSmall(
                      text: rightTextNumber,
                    ),
                  ),
                  Expanded(
                    child: CustomTextField.textWithSmall(
                      text: rightValue,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
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

  static Widget quizContainer1({
    required String leftTextNumber,
    required String leftValue,
    required bool isSelected,
    Color? borderColor,
    VoidCallback? onTap,
    required bool isQuizCompleted,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // ✅ Always white if selected
                color: isSelected ? Colors.white : AppColor.lowLightgray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor ?? AppColor.lowLightgray,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextField.textWithSmall(
                        text: leftTextNumber,
                        color: AppColor.borderGary,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: CustomTextField.textWithSmall(
                        text: leftValue,
                        color: AppColor.black,
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



  static Widget carouselSlider({
    required String mainText1,
    required String mainText2,
    required String iconImage,
    required String bcImage,
    bool isSelect = false,
    Gradient? gradient,
    required int iconHeight,
    required int iconWidth,
    Alignment iconAlignment = Alignment.center,
    double iconYOffset = 0,
    EdgeInsets? iconPadding,

    TextAlign textAlign = TextAlign.start,
    EdgeInsets? textPadding,
  }) {
    final CrossAxisAlignment textCross =
        (textAlign == TextAlign.end)
            ? CrossAxisAlignment.end
            : (textAlign == TextAlign.center)
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Image.asset(bcImage, fit: BoxFit.cover),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 20,
              child: Padding(
                padding:
                    textPadding ?? const EdgeInsets.symmetric(horizontal: 25),

                child: Column(
                  crossAxisAlignment: textCross,
                  children: [
                    Text(
                      mainText1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: textAlign,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: isSelect ? 22 : 15,
                        fontWeight:
                            isSelect ? FontWeight.w800 : FontWeight.w500,

                        color: AppColor.white,
                      ),
                    ),
                    Text(
                      mainText2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: textAlign,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: isSelect ? 22 : 20,
                        fontWeight:
                            isSelect ? FontWeight.w500 : FontWeight.w800,

                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned.fill(
              child: Padding(
                padding:
                    isSelect
                        ? const EdgeInsets.symmetric(horizontal: 0)
                        : const EdgeInsets.symmetric(horizontal: 25),

                child: Align(
                  alignment: iconAlignment,
                  child: Transform.translate(
                    offset: Offset(0, iconYOffset),
                    child: SizedBox(
                      height: iconHeight.toDouble(),
                      width: iconWidth.toDouble(),
                      child: Image.asset(iconImage, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*  static checkMark({required VoidCallback onTap, String? imagePath}) {
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
  }*/

  static Widget myProfileContainer({
    required String standardText1,
    required String standardText2,
    required String standardText3,
    required List<String> sections,
    Map<String, List<String>>? sectionSubjects, // Map section -> subjects
    String? expandedSection, // currently expanded section
    Function(String section)? onSectionTap,
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
      padding:
          containerPadding ??
          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                          : EdgeInsets.only(right: 10);

                  bool isExpanded = section == expandedSection;
                  List<String> subjects = sectionSubjects?[section] ?? [];

                  return Padding(
                    padding: padding,
                    child: InkWell(
                      onTap: () {
                        if (onSectionTap != null) {
                          onSectionTap(
                            isExpanded ? '' : section,
                          ); // collapse if tapped again
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              sectionBgColor ?? AppColor.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.white),
                        ),
                        padding:
                            sectionTextPadding ??
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Text(
                              section,
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                            if (isExpanded && subjects.isNotEmpty) ...[
                              SizedBox(width: 8),
                              Text(
                                '- ${subjects.join(", ")}',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  static Widget studentInfoScreen({
    required String text,
    required TextEditingController controller,
    String? imagePath,
    bool verticalDivider = true,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
    FocusNode? nextFocus,
    Color borderColor = AppColor.red,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime>? onDatePicked,
    DatePickMode datePickMode = DatePickMode.none,
    bool styledRangeText = false,
  }) {
    final DateTime _first = firstDate ?? DateTime(1900, 1, 1);
    final DateTime _last = lastDate ?? DateTime(2100, 12, 31);

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
                        (datePickMode != DatePickMode.none && context != null)
                            ? () async {
                              String dd(int v) => v.toString().padLeft(2, '0');
                              String fmt(DateTime d) =>
                                  '${dd(d.day)}-${dd(d.month)}-${d.year}';

                              if (datePickMode == DatePickMode.single) {
                                final picked = await showDatePicker(
                                  context: context!,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                  builder:
                                      (ctx, child) => Theme(
                                        data: Theme.of(ctx).copyWith(
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
                                      ),
                                );
                                if (picked != null) {
                                  controller.text = fmt(picked);
                                }
                              } else if (datePickMode == DatePickMode.range) {
                                final picked = await showDateRangePicker(
                                  context: context!,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  initialDateRange: DateTimeRange(
                                    start: DateTime.now(),
                                    end: DateTime.now().add(
                                      const Duration(days: 7),
                                    ),
                                  ),
                                  builder:
                                      (ctx, child) => Theme(
                                        data: Theme.of(ctx).copyWith(
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
                                      ),
                                );
                                if (picked != null) {
                                  controller.text =
                                      '${fmt(picked.start)}  to  ${fmt(picked.end)}';
                                }
                              }
                            }
                            : null,

                    child: AbsorbPointer(
                      absorbing: datePickMode != DatePickMode.none,
                      child:
                          styledRangeText
                              ? Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Opacity(
                                    opacity: 0,
                                    child: TextFormField(
                                      controller: controller,
                                      validator: validator,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder<TextEditingValue>(
                                    valueListenable: controller,
                                    builder: (context, value, _) {
                                      final raw = value.text.trim();
                                      if (raw.isEmpty) {
                                        return Text(
                                          text,
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            color: AppColor.gray,
                                          ),
                                        );
                                      }

                                      final parts = raw.split(
                                        RegExp(
                                          r'\s+to\s+',
                                          caseSensitive: false,
                                        ),
                                      );
                                      if (parts.length == 1) {
                                        // single date style
                                        return Text(
                                          parts[0],
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.black,
                                          ),
                                        );
                                      }

                                      final startTxt = parts[0];
                                      final endTxt = parts[1];

                                      return RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: startTxt,
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '   to   ',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.gray,
                                              ),
                                            ),
                                            TextSpan(
                                              text: endTxt,
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                              : TextFormField(
                                controller: controller,
                                validator: validator,
                                readOnly: datePickMode != DatePickMode.none,
                                onChanged: onChanged,
                                maxLines: maxLine,
                                keyboardType: keyboardType,
                                inputFormatters: inputFormatters,
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                  color: AppColor.black,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '',
                                  counterText: '',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Image.asset(
                      imagePath,
                      height: imageSize,
                      width: imageSize,
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
              style: GoogleFont.ibmPlexSans(color: AppColor.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  static Widget padKey(String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.lowLightgray,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFont.ibmPlexSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  static Widget sidePill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 68,
        height: 96,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColor.lowLightgray),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: AppColor.gray, size: 28),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFont.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColor.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget topLinkTab({
    required String text,
    required bool active,
    required VoidCallback onTap,
    bool alignRight = false,
  }) {
    final color = active ? const Color(0xFF2F80ED) : const Color(0xFF9AA0A6);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: 2,
          bottom: 6,
          left: alignRight ? 8 : 0,
          right: alignRight ? 0 : 8,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }

  // CommonContainer.whiteCard(...) – Figma-style white rounded card
  static Widget whiteCard({
    required Widget child,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    EdgeInsets padding = const EdgeInsets.all(6),
    double radius = 12,
    Color? color,
    List<BoxShadow>? shadows,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow:
            shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
      ),
      child: child,
    );
  }

  static Widget searchField({
    required TextEditingController controller,
    required String searchText,
    required ValueChanged<String> onChanged,
    required VoidCallback onClear,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon:
            searchText.isNotEmpty
                ? GestureDetector(
                  onTap: onClear,
                  child: Icon(Icons.clear, size: 20, color: AppColor.gray),
                )
                : null,
        hintText: 'Search',
        hintStyle: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.gray),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 6),
          child: Icon(Icons.search_rounded, size: 20, color: AppColor.gray),
        ),
        filled: true,
        fillColor: AppColor.lowLightgray,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Horizontal chip row like "7 Done / 43 Unfinished"
  static Widget statusChips({
    required List<Map<String, dynamic>> tabs,
    required int selectedIndex,
    required ValueChanged<int> onSelect,
    double horizontalPadding = 40,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColor.blue : AppColor.borderGary,
                    width: 1,
                  ),
                ),
                child: Text(
                  "${tabs[index]['label']}",
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 12,
                    color: isSelected ? AppColor.blue : AppColor.gray,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // inside CommonContainer class
  static Widget totalPill({required int total}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Total $total",
        style: GoogleFont.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColor.blue,
        ),
      ),
    );
  }

  static Widget totalsPill({required int score, required int total}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$score out of $total",
        style: GoogleFont.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColor.blue,
        ),
      ),
    );
  }
}
