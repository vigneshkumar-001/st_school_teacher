import 'package:flutter/material.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          child: SingleChildScrollView(
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
                    'Today Messages',
                    style: GoogleFont.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lightBlueC1,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lightBlueC1,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lowLightYellow,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lowLightNavi,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                    ],
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
