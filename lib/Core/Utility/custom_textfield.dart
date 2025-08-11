import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';
import 'google_fonts.dart';

class CustomTextField {
  static textWith600({
    required String text,
    double fontSize = 18,
    double hight = 1.5,
    Color? color = AppColor.lightBlack,
  }) {
    return Text(
      text,
      style: GoogleFont.ibmPlexSans(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static quizQuestion({required String sno, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sno, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  static textWithSmall({
    required String text,
    Color? color = AppColor.lightgray,
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

  static Widget richText({
    required String text,
    required String text2,
    bool isBold = false,
    Color text1Color = AppColor.lightBlack,
    Color text2Color = AppColor.lowLightgray,
    double secondFontSize = 15,
    double firstFontSize = 15,
    FontWeight fontWeight1 = FontWeight.normal,
    FontWeight fontWeight2 = FontWeight.normal,
    String hintText = 'Enter Aadhaar Number',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: text,
            style: GoogleFont.ibmPlexSans(
              fontSize: firstFontSize,
              color: text1Color,
              fontWeight: fontWeight1,
            ),
            children: [
              if (text2.isNotEmpty)
                TextSpan(
                  text: isBold ? text2 : ' ( $text2 )',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: fontWeight2,
                    fontSize: secondFontSize,
                    color: text2Color,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
