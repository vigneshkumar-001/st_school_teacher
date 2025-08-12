import 'package:flutter/material.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Login Screen/change_mobile_number.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  // String? selectedSection;
  @override
  Widget build(BuildContext context) {
    final sections = ['A', 'B', 'C'];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      standardText1: '1',
                      standardText2: 'st ',
                      standardText3: 'Standard',
                      sections: sections,
                      selectedSection: selectedSection,
                      onSectionTap: (section) {
                        setState(() {
                          if (selectedSection == section) {
                            selectedSection = null;
                          } else {
                            selectedSection = section;
                          }
                        });
                      },
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: sections.map((section) {
                    //     final isSelected = selectedSection == section;
                    //
                    //     return GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           if (selectedSection == section) {
                    //             selectedSection = null; // toggle off if tapped again
                    //           } else {
                    //             selectedSection = section;
                    //           }
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    //         decoration: BoxDecoration(
                    //           color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                    //           borderRadius: BorderRadius.circular(12),
                    //           border: Border.all(
                    //             color: isSelected ? Colors.blue : Colors.grey,
                    //             width: 2,
                    //           ),
                    //         ),
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               section,
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 18,
                    //                 color: isSelected ? Colors.blue : Colors.black,
                    //               ),
                    //             ),
                    //             if (isSelected) ...[
                    //               SizedBox(height: 8),
                    //               Text(
                    //                 getSectionDetails(section),
                    //                 style: TextStyle(fontSize: 14, color: Colors.black87),
                    //               ),
                    //             ],
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                    // if (selectedSection != null) ...[
                    //   SizedBox(height: 10),
                    //   Container(
                    //     padding: EdgeInsets.all(16),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white.withOpacity(0.7),
                    //       borderRadius: BorderRadius.circular(12),
                    //       border: Border.all(color: Colors.grey),
                    //     ),
                    //     child: Text(
                    //       getSectionDetails(selectedSection!),
                    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    //     ),
                    //   ),
                    // ],
                    SizedBox(height: 25),
                    CommonContainer.myProfileContainer(
                      standardText1: '2',
                      standardText2: 'nd ',
                      standardText3: 'Standard',

                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],

                      sections: ['A', 'B', 'C', 'D', 'E'],
                      backgroundColor: AppColor.profileClass2nd,
                    ),

                    SizedBox(height: 25),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass3rd,
                      standardText1: '3',
                      standardText2: 'rd ',
                      standardText3: 'Standard',
                      sections: ['A', 'B'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 61,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass4th,
                      standardText1: '4',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['A', 'B', 'C'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 36.1,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass5th,
                      standardText1: '5',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['A'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 136,
                        vertical: 18,
                      ),
                      paddings: [EdgeInsets.symmetric(horizontal: 0)],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass6th,
                      standardText1: '6',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['A', 'B', 'C'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 36.1,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass7th,
                      standardText1: '7',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['A', 'B', 'C'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 36.1,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 25),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass8th,
                      standardText1: '8',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['B', 'c'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 61,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 25),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass9th,
                      standardText1: '9',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['A', 'c'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 61,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass10th,
                      standardText1: '10',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['D', 'E', 'F'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 36.1,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass11th,
                      standardText1: '11',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['D', 'E', 'F'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 36.1,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),

                    SizedBox(height: 20),
                    CommonContainer.myProfileContainer(
                      backgroundColor: AppColor.profileClass12th,
                      standardText1: '12',
                      standardText2: 'th ',
                      standardText3: 'Standard',
                      sections: ['D', 'E', 'F'],
                      sectionTextPadding: EdgeInsets.symmetric(
                        horizontal: 36.1,
                        vertical: 18,
                      ),

                      paddings: [
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                        EdgeInsets.symmetric(horizontal: 6),
                      ],
                      containerPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.lowlightWhite, AppColor.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
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
                            title: RichText(
                              text: TextSpan(
                                text: 'Meghna',
                                style: GoogleFont.ibmPlexSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: AppColor.black,
                                ),
                              ),
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
                                        '+91 900 000 0000',
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
                                SizedBox(height: 15),
                                InkWell(
                                  onTap: () {},
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
                    right: 10,
                    bottom: 35,
                    child: InkWell(
                      onTap: () {},
                      child: Image.asset(
                        AppImages.schoolGirl,
                        height: 95,
                        width: 95,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// String getSectionDetails(String section) {
//   switch (section) {
//     case 'A':
//       return 'A - Social Science';
//     case 'B':
//       return 'B - Mathematics';
//     case 'C':
//       return 'C - Science';
//     default:
//       return '';
//   }
// }
