import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utility/app_color.dart';
import '../Utility/app_images.dart';
import '../Utility/google_fonts.dart';

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
      width: 145,
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
      padding: const EdgeInsets.symmetric(vertical: 5),
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
          SizedBox(height: 10),
          Divider(color: AppColor.lowLightgray),
        ],
      ),
    );
  }
}
