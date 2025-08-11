import 'package:flutter/material.dart';

import 'app_color.dart';
import 'google_fonts.dart';
class AppButton {
  static button({
    BuildContext? context,
    VoidCallback? onTap,
    required String text,
    Widget? loader, // Pass a widget like CircularProgressIndicator
    double fontSize = 16,
    bool isBorder = false,
    FontWeight? fontWeight = FontWeight.w700,
    double? width = 200,
    double? height = 60,
    String? image,
  }) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: isBorder ? AppColor.white : null,
            gradient: isBorder
                ? null
                : LinearGradient(
              colors: [AppColor.blueG1, AppColor.blue.withOpacity(0.9)],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
            ),
            border: isBorder ? Border.all(color: AppColor.blueG1, width: 2) : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: onTap,
            child: loader != null
                ? loader // Show loader instead of text
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: isBorder ? AppColor.blue : AppColor.white,
                  ),
                ),
                if (image != null) ...[
                  SizedBox(width: 15),
                  Image.asset(image, height: 20),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class AppButton {
  static button({
    BuildContext? context,
    VoidCallback? onTap,
    required String text,
    Widget? loader,
    double fontSize = 16,
    bool isBorder = false,

    FontWeight? fontWeight = FontWeight.w700,
    double? width = 200,
    double? height = 60,
    String? image,
  }) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: isBorder ? AppColor.white : null,
            gradient:
                isBorder
                    ? null
                    : LinearGradient(
                      colors: [AppColor.blueG1, AppColor.blue.withOpacity(0.9)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                    ),
            border:
                isBorder ? Border.all(color: AppColor.blueG1, width: 2) : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: isBorder ? AppColor.blue : AppColor.white,
                  ),
                ),
                SizedBox(width: 15),

                image != null ? Image.asset(image, height: 20) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
