//
// /*import 'dart:io';
//
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../Core/Utility/app_color.dart';
// import '../../Core/Utility/app_images.dart';
// import '../../Core/Utility/custom_textfield.dart';
// import '../../Core/Utility/google_fonts.dart';
// import '../../Core/Widgets/common_container.dart';
// import '../Attendance/controller/attendance_controller.dart';
// import 'Model/announcement_list_general.dart';
// import 'announcement_create.dart';
// import 'controller/announcement_contorller.dart';
//
// // 👇 import your controller & model (adjust paths!)
//
// class ListGeneral extends StatefulWidget {
//   const ListGeneral({super.key});
//
//   @override
//   State<ListGeneral> createState() => _ListGeneralState();
// }
//
// class _ListGeneralState extends State<ListGeneral> {
//   int selectedIndex = 0;
//   final AttendanceController attendanceController = Get.put(
//     AttendanceController(),
//   );
//
//   // Fetch announcements
//   final AnnouncementContorller annController = Get.put(
//     AnnouncementContorller(),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     // Avoid “setState during build” with a post-frame fetch
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       annController.listAnnouncements();
//     });
//   }
//
//   // ---------------------- Bottom Sheets ----------------------
//
//   void _feesSheet(BuildContext context, AnnouncementItem item) {
//     final dateLabel = _formatDate(item.notifyDate);
//     final items = const ['Shoes', 'Notebooks', 'Tuition Fees']; // demo bullets
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.55,
//           minChildSize: 0.20,
//           maxChildSize: 0.55,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.borderGary,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Header image (network if available)
//                   _TopImage(imageUrl: item.image),
//
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           item.title,
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w500,
//                             color: AppColor.black,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'Due date',
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 12,
//                               color: AppColor.lightgray,
//                             ),
//                           ),
//                           Text(
//                             dateLabel,
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: AppColor.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 4),
//                       Icon(
//                         CupertinoIcons.clock_fill,
//                         size: 30,
//                         color: AppColor.borderGary,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Bullets
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: List.generate(
//                       items.length,
//                       (index) => Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Text(
//                           '${index + 1}. ${items[index]}',
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 16,
//                             color: AppColor.lightBlack,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // Pay CTA (demo)
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ButtonStyle(
//                       padding: MaterialStateProperty.all(EdgeInsets.zero),
//                       shape: MaterialStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       elevation: MaterialStateProperty.all(0),
//                       backgroundColor: MaterialStateProperty.all(
//                         Colors.transparent,
//                       ),
//                     ),
//                     child: Ink(
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [AppColor.blueG1, AppColor.blue],
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 50,
//                         width: double.infinity,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Pay Now',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w800,
//                                 color: AppColor.white,
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             const Icon(
//                               CupertinoIcons.right_chevron,
//                               size: 14,
//                               color: AppColor.white,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _examResult(BuildContext context, AnnouncementItem item) {
//     final dateLabel = _formatDate(item.notifyDate);
//
//     // demo subjects
//     final subjects = const [
//       {'subject': 'Tamil', 'mark': '70'},
//       {'subject': 'English', 'mark': '70'},
//       {'subject': 'Maths', 'mark': '70'},
//       {'subject': 'Science', 'mark': '70'},
//       {'subject': 'Social Science', 'mark': '70'},
//     ];
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.65,
//           minChildSize: 0.20,
//           maxChildSize: 0.65,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.borderGary,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   _TopImage(imageUrl: item.image),
//
//                   const SizedBox(height: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         item.title,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: AppColor.lightBlack,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         dateLabel,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 12,
//                           color: AppColor.gray,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Grade (demo)
//                       RichText(
//                         text: TextSpan(
//                           text: 'A+',
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 38,
//                             fontWeight: FontWeight.w600,
//                             color: AppColor.green,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' Grade',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 38,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColor.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 22),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                         child: DottedLine(
//                           dashColor: AppColor.borderGary,
//                           dashGapLength: 6,
//                           dashLength: 7,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Marks list
//                       Stack(
//                         children: [
//                           Positioned.fill(
//                             child: Image.asset(
//                               AppImages.examResultBCImage,
//                               height: 100,
//                               width: 180,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: subjects.length,
//                             itemBuilder: (context, index) {
//                               final subject = subjects[index];
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0,
//                                   horizontal: 16,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 38.0,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         subject['subject']!,
//                                         style: GoogleFont.ibmPlexSans(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColor.gray,
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       Text(
//                                         subject['mark']!,
//                                         style: GoogleFont.ibmPlexSans(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColor.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                         child: DottedLine(
//                           dashColor: AppColor.borderGary,
//                           dashGapLength: 6,
//                           dashLength: 7,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Center(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 30,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: AppColor.blue,
//                                 width: 1,
//                               ),
//                             ),
//                             child: CustomTextField.textWithSmall(
//                               text: 'Close',
//                               color: AppColor.blue,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _detailsSheet(BuildContext context, AnnouncementItem item) {
//     final dateLabel = _formatDate(item.notifyDate);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.50,
//           minChildSize: 0.20,
//           maxChildSize: 0.80,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.borderGary,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _TopImage(imageUrl: item.image),
//                   const SizedBox(height: 20),
//
//                   Text(
//                     item.title,
//                     style: GoogleFont.ibmPlexSans(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: AppColor.black,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   // Row(
//                   //   children: [
//                   //     _Chip(text: item.category),
//                   //     const SizedBox(width: 8),
//                   //     _Chip(
//                   //       text: item.announcementCategory.replaceAll('_', ' '),
//                   //     ),
//                   //   ],
//                   // ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       const Icon(
//                         CupertinoIcons.clock_fill,
//                         size: 18,
//                         color: AppColor.borderGary,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         dateLabel,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 14,
//                           color: AppColor.lightBlack,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No additional description provided.',
//                     style: GoogleFont.ibmPlexSans(
//                       fontSize: 14,
//                       color: AppColor.gray,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // ---------------------- Helpers ----------------------
//
//   String _formatDate(DateTime? dt) {
//     if (dt == null) return '-';
//     // dd-MMM-yy
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     final dd = dt.day.toString().padLeft(2, '0');
//     final mmm = months[dt.month - 1];
//     final yy = (dt.year % 100).toString().padLeft(2, '0');
//     return '$dd-$mmm-$yy';
//   }
//
//   bool _isAbsoluteUrl(String? s) {
//     if (s == null || s.isEmpty) return false;
//     final uri = Uri.tryParse(s);
//     return uri != null && uri.hasScheme;
//   }
//
//   // Card for one announcement (network background, gradient overlay, title + date)
//   Widget _AnnouncementCard(AnnouncementItem item) {
//     final dateLabel = _formatDate(item.notifyDate);
//
//     void handleTap() {
//       switch (item.announcementCategory.toLowerCase()) {
//         case 'term_fee':
//           _feesSheet(context, item);
//           break;
//         case 'exam_result':
//           _examResult(context, item);
//           break;
//         default:
//           _detailsSheet(context, item);
//       }
//     }
//
//     return GestureDetector(
//       onTap: handleTap,
//       child: Container(
//         height: 170,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           image:
//               _isAbsoluteUrl(item.image)
//                   ? DecorationImage(
//                     image: NetworkImage(item.image!),
//                     fit: BoxFit.cover,
//                   )
//                   : DecorationImage(
//                     image: AssetImage(AppImages.announcement1), // fallback
//                     fit: BoxFit.cover,
//                   ),
//         ),
//         child: Stack(
//           children: [
//             // gradient overlay
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.05),
//                     Colors.black.withOpacity(0.85),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//
//             // content
//             Padding(
//               padding: const EdgeInsets.all(14.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // _Chip(text: item.category),
//                   const Spacer(),
//                   Text(
//                     item.title,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFont.ibmPlexSans(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(
//                         CupertinoIcons.clock_fill,
//                         size: 16,
//                         color: Colors.white70,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         dateLabel,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 13,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------------- Tabs Content ----------------------
//
//   Widget _buildGeneralTab(List<AnnouncementItem> items) {
//     // General: everything except teacher-specific category name
//     final list =
//         items.where((e) {
//           final cat = e.category.toLowerCase();
//           final ac = e.announcementCategory.toLowerCase();
//           return !(cat == 'teachers' || ac.startsWith('teacher'));
//         }).toList();
//
//     if (list.isEmpty) {
//       return _Empty(text: 'No general announcements');
//     }
//
//     return Column(
//       children: [
//         for (final a in list) ...[
//           _AnnouncementCard(a),
//           const SizedBox(height: 20),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildTeacherTab(List<AnnouncementItem> items) {
//     // Teacher tab: teacher_* or category == Teachers
//     final list =
//         items.where((e) {
//           final cat = e.category.toLowerCase();
//           final ac = e.announcementCategory.toLowerCase();
//           return cat == 'teachers' || ac.startsWith('teacher');
//         }).toList();
//
//     if (list.isEmpty) {
//       return _Empty(text: 'No teacher announcements');
//     }
//
//     return Column(
//       children: [
//         for (final a in list) ...[
//           _AnnouncementCard(a),
//           const SizedBox(height: 20),
//         ],
//       ],
//     );
//   }
//
//   // ---------------------- UI ----------------------
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Obx(() {
//           final isLoading = annController.isLoading.value;
//           final error = annController.error.value;
//           final items = annController.items;
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       CommonContainer.NavigatArrow(
//                         image: AppImages.leftSideArrow,
//                         imageColor: AppColor.lightBlack,
//                         container: AppColor.lowLightgray,
//                         onIconTap: () => Navigator.pop(context),
//                         border: Border.all(
//                           color: AppColor.lightgray,
//                           width: 0.3,
//                         ),
//                       ),
//                       const Spacer(),
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const AnnouncementCreate(),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Create Announcement',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColor.blue,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Image.asset(AppImages.doubleArrow, height: 19),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 35),
//                   Center(
//                     child: Text(
//                       'Announcements',
//                       style: GoogleFont.ibmPlexSans(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 26,
//                         color: AppColor.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   if (isLoading) ...[
//                     const SizedBox(height: 120),
//                     const CircularProgressIndicator(),
//                     const SizedBox(height: 120),
//                   ] else if (error.isNotEmpty) ...[
//                     _ErrorView(
//                       message: error,
//                       onRetry: () => annController.listAnnouncements(),
//                     ),
//                   ] else if (items.isEmpty) ...[
//                     _Empty(text: 'No announcements found'),
//                   ] else ...[
//                     if (selectedIndex == 0)
//                       _buildGeneralTab(items)
//                     else
//                       _buildTeacherTab(items),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//
//       // Bottom tab chips
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(color: AppColor.white),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//           child: CommonContainer.statusChips(
//             horizontalPadding: 60,
//             tabs: const [
//               {"label": "General"},
//               {"label": "Teacher"},
//             ],
//             selectedIndex: selectedIndex,
//             onSelect: (i) => setState(() => selectedIndex = i),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ---------------------- Small UI helpers ----------------------
//
// class _TopImage extends StatelessWidget {
//   final String? imageUrl;
//   const _TopImage({required this.imageUrl});
//
//   bool _isAbsoluteUrl(String? s) {
//     if (s == null || s.isEmpty) return false;
//     final uri = Uri.tryParse(s);
//     return uri != null && uri.hasScheme;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isAbsoluteUrl(imageUrl)) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: Image.network(
//           imageUrl!,
//           height: 160,
//           width: double.infinity,
//           fit: BoxFit.cover,
//         ),
//       );
//     }
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: Image.asset(
//         AppImages.announcement1,
//         height: 160,
//         width: double.infinity,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }
//
//
//
// class _Empty extends StatelessWidget {
//   final String text;
//   const _Empty({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 80.0),
//       child: Text(
//         text,
//         style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.gray),
//       ),
//     );
//   }
// }
//
// class _ErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//   const _ErrorView({required this.message, required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 16),
//       child: Column(
//         children: [
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: GoogleFont.ibmPlexSans(fontSize: 14, color: Colors.red),
//           ),
//           const SizedBox(height: 12),
//           TextButton(onPressed: onRetry, child: const Text('Retry')),
//         ],
//       ),
//     );
//   }
// }*/
//
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../Core/Utility/app_color.dart';
// import '../../Core/Utility/app_images.dart';
// import '../../Core/Utility/custom_textfield.dart';
// import '../../Core/Utility/google_fonts.dart';
// import '../../Core/Widgets/common_container.dart';
// import '../Attendance/controller/attendance_controller.dart';
// import 'Model/announcement_list_general.dart';
// import 'announcement_create.dart';
// import 'controller/announcement_contorller.dart';
//
// /// ---------- helpers (top-level) ----------
// String _lc(String? s) => (s ?? '').toLowerCase();
//
// /// Normalizes API image values that might be relative (e.g. "1000181681.jpg")
// String? _normalizeUrl(String? raw) {
//   if (raw == null) return null;
//   final r = raw.trim();
//   if (r.isEmpty) return null;
//   if (Uri.tryParse(r)?.hasScheme == true) return r;
//
//   // Adjust this base to your backend’s actual static path if needed
//   const base =
//       'https://next.fenizotechnologies.com/Adrox/./assets/images/support/';
//   return '$base$r';
// }
//
// class  AnnouncementScreen  extends StatefulWidget {
//   const AnnouncementScreen({super.key});
//
//   @override
//   State<AnnouncementScreen> createState() => _AnnouncementScreenState();
// }
//
// class _ExtraLines {
//   final String line1;
//   final String line2;
//   const _ExtraLines(this.line1, this.line2);
// }
//
// class _AnnouncementScreenState extends State<AnnouncementScreen> {
//   int selectedIndex = 0;
//
//   final AttendanceController attendanceController = Get.put(
//     AttendanceController(),
//   );
//   final AnnouncementContorller annController = Get.put(
//     AnnouncementContorller(),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch after first frame to avoid setState during build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // If your controller method is named `listAnnouncement()`, swap the call below.
//       annController.listAnnouncements();
//     });
//   }
//
//   // ---------------------- Bottom Sheets ----------------------
//
//   void _feesSheet(BuildContext context, AnnouncementItem item) {
//     final dateLabel = _formatDate(item.notifyDate);
//     final items = const ['Shoes', 'Notebooks', 'Tuition Fees']; // demo
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.55,
//           minChildSize: 0.20,
//           maxChildSize: 0.55,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.borderGary,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _TopImage(imageUrl: item.image),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           item.title,
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w500,
//                             color: AppColor.black,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'Due date',
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 12,
//                               color: AppColor.lightgray,
//                             ),
//                           ),
//                           Text(
//                             dateLabel,
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: AppColor.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 4),
//                       Icon(
//                         CupertinoIcons.clock_fill,
//                         size: 30,
//                         color: AppColor.borderGary,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: List.generate(
//                       items.length,
//                       (index) => Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Text(
//                           '${index + 1}. ${items[index]}',
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 16,
//                             color: AppColor.lightBlack,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ButtonStyle(
//                       padding: MaterialStateProperty.all(EdgeInsets.zero),
//                       shape: MaterialStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       elevation: MaterialStateProperty.all(0),
//                       backgroundColor: MaterialStateProperty.all(
//                         Colors.transparent,
//                       ),
//                     ),
//                     child: Ink(
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [AppColor.blueG1, AppColor.blue],
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 50,
//                         width: double.infinity,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Pay Now',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w800,
//                                 color: AppColor.white,
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             const Icon(
//                               CupertinoIcons.right_chevron,
//                               size: 14,
//                               color: AppColor.white,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _examResult(BuildContext context, AnnouncementItem item) {
//     final dateLabel = _formatDate(item.notifyDate);
//
//     final subjects = const [
//       {'subject': 'Tamil', 'mark': '70'},
//       {'subject': 'English', 'mark': '70'},
//       {'subject': 'Maths', 'mark': '70'},
//       {'subject': 'Science', 'mark': '70'},
//       {'subject': 'Social Science', 'mark': '70'},
//     ];
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.65,
//           minChildSize: 0.20,
//           maxChildSize: 0.65,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.borderGary,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _TopImage(imageUrl: item.image),
//                   const SizedBox(height: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         item.title,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: AppColor.lightBlack,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         dateLabel,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 12,
//                           color: AppColor.gray,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       RichText(
//                         text: TextSpan(
//                           text: 'A+',
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 38,
//                             fontWeight: FontWeight.w600,
//                             color: AppColor.green,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' Grade',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 38,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColor.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 22),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                         child: DottedLine(
//                           dashColor: AppColor.borderGary,
//                           dashGapLength: 6,
//                           dashLength: 7,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Stack(
//                         children: [
//                           Positioned.fill(
//                             child: Image.asset(
//                               AppImages.examResultBCImage,
//                               height: 100,
//                               width: 180,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: subjects.length,
//                             itemBuilder: (context, index) {
//                               final subject = subjects[index];
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0,
//                                   horizontal: 16,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 38.0,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         subject['subject']!,
//                                         style: GoogleFont.ibmPlexSans(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColor.gray,
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       Text(
//                                         subject['mark']!,
//                                         style: GoogleFont.ibmPlexSans(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColor.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                         child: DottedLine(
//                           dashColor: AppColor.borderGary,
//                           dashGapLength: 6,
//                           dashLength: 7,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Center(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 30,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: AppColor.blue,
//                                 width: 1,
//                               ),
//                             ),
//                             child: CustomTextField.textWithSmall(
//                               text: 'Close',
//                               color: AppColor.blue,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _detailsSheet(BuildContext context, AnnouncementItem item) {
//     final dateLabel = _formatDate(item.notifyDate);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.50,
//           minChildSize: 0.20,
//           maxChildSize: 0.80,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.borderGary,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _TopImage(imageUrl: item.image),
//                   const SizedBox(height: 20),
//                   Text(
//                     item.title,
//                     style: GoogleFont.ibmPlexSans(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: AppColor.black,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       const Icon(
//                         CupertinoIcons.clock_fill,
//                         size: 18,
//                         color: AppColor.borderGary,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         dateLabel,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 14,
//                           color: AppColor.lightBlack,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No additional description provided.',
//                     style: GoogleFont.ibmPlexSans(
//                       fontSize: 14,
//                       color: AppColor.gray,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // ---------------------- Helpers ----------------------
//
//   String _formatDate(DateTime? dt) {
//     if (dt == null) return '-';
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     final dd = dt.day.toString().padLeft(2, '0');
//     final mmm = months[dt.month - 1];
//     final yy = (dt.year % 100).toString().padLeft(2, '0');
//     return '$dd-$mmm-$yy';
//   }
//
//   Widget _announcementCard(
//     AnnouncementItem item, {
//     IconData? iconData,
//     double overlayVerticalPadding = 9,
//     Color? gradientStartColor,
//     Color? gradientEndColor,
//   }) {
//     final dateLabel = _formatDate(item.notifyDate);
//     final extras = _extrasFor(item, dateLabel);
//
//     void handleTap() {
//       switch (_lc(item.announcementCategory)) {
//         case 'term_fee':
//           _feesSheet(context, item);
//           break;
//         case 'exam_result':
//           _examResult(context, item);
//           break;
//         default:
//           _detailsSheet(context, item);
//       }
//     }
//
//     return GestureDetector(
//       onTap: handleTap,
//       child: SizedBox(
//         height: 170,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(22),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // background image
//               Positioned.fill(
//                 child: _NetworkOrAssetBg(
//                   url: item.image,
//                   asset: AppImages.announcement1,
//                 ),
//               ),
//               // bottom overlay (same look as announcementsScreen)
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         gradientStartColor ?? AppColor.black.withOpacity(0.01),
//                         gradientEndColor ?? AppColor.black,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(22),
//                       bottomRight: Radius.circular(22),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 25,
//                       vertical: overlayVerticalPadding,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 item.title,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFont.ibmPlexSans(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColor.white,
//                                 ),
//                               ),
//                             ),
//                             if (iconData != null ||
//                                 item.notifyDate != null) ...[
//                               const SizedBox(width: 10),
//                               Icon(
//                                 iconData ?? CupertinoIcons.clock_fill,
//                                 size: 22,
//                                 color: AppColor.white,
//                               ),
//                               const SizedBox(width: 8),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (extras.line1.isNotEmpty)
//                                     Text(
//                                       extras.line1,
//                                       style: GoogleFont.ibmPlexSans(
//                                         fontSize: 12,
//                                         color: AppColor.lowLightgray,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   Text(
//                                     extras.line2,
//                                     style: GoogleFont.ibmPlexSans(
//                                       fontSize: 14,
//                                       color: AppColor.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _ExtraLines _extrasFor(AnnouncementItem item, String dateLabel) {
//     final cat = _lc(item.announcementCategory);
//     if (cat == 'term_fee') return _ExtraLines('Due date', dateLabel);
//     if (cat == 'holiday') return _ExtraLines('', dateLabel);
//     if (cat == 'exam_result') return _ExtraLines('', dateLabel);
//     if (cat.startsWith('teacher')) return _ExtraLines('On', dateLabel);
//     return _ExtraLines('', dateLabel);
//   }
//
//   // ---------------------- Tabs Content ----------------------
//
//   Widget _buildGeneralTab(List<AnnouncementItem> items) {
//     final list =
//         items.where((e) {
//           final cat = _lc(e.category);
//           final ac = _lc(e.announcementCategory);
//           return !(cat == 'teachers' || ac.startsWith('teacher'));
//         }).toList();
//
//     if (list.isEmpty) return const _Empty(text: 'No general announcements');
//
//     return Column(
//       children: [
//         for (final a in list) ...[
//           _announcementCard(a),
//           const SizedBox(height: 20),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildTeacherTab(List<AnnouncementItem> items) {
//     final list =
//         items.where((e) {
//           final cat = _lc(e.category);
//           final ac = _lc(e.announcementCategory);
//           return cat == 'teachers' || ac.startsWith('teacher');
//         }).toList();
//
//     if (list.isEmpty) return const _Empty(text: 'No teacher announcements');
//
//     return Column(
//       children: [
//         for (final a in list) ...[
//           _announcementCard(a),
//           const SizedBox(height: 20),
//         ],
//       ],
//     );
//   }
//
//   // ---------------------- UI ----------------------
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Obx(() {
//           final isLoading = annController.isLoading.value;
//           final error = annController.error.value;
//           final items = annController.items;
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       CommonContainer.NavigatArrow(
//                         image: AppImages.leftSideArrow,
//                         imageColor: AppColor.lightBlack,
//                         container: AppColor.lowLightgray,
//                         onIconTap: () => Navigator.pop(context),
//                         border: Border.all(
//                           color: AppColor.lightgray,
//                           width: 0.3,
//                         ),
//                       ),
//                       const Spacer(),
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const AnnouncementCreate(),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Create Announcement',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColor.blue,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Image.asset(AppImages.doubleArrow, height: 19),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 35),
//                   Center(
//                     child: Text(
//                       'Announcements',
//                       style: GoogleFont.ibmPlexSans(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 26,
//                         color: AppColor.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   if (isLoading) ...[
//                     const SizedBox(height: 120),
//                     const CircularProgressIndicator(),
//                     const SizedBox(height: 120),
//                   ] else if (error.isNotEmpty) ...[
//                     _ErrorView(
//                       message: error,
//                       onRetry: () => annController.listAnnouncements(),
//                     ),
//                   ] else if (items.isEmpty) ...[
//                     const _Empty(text: 'No announcements found'),
//                   ] else ...[
//                     if (selectedIndex == 0)
//                       _buildGeneralTab(items)
//                     else
//                       _buildTeacherTab(items),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//
//       // Bottom tab chips
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(color: AppColor.white),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//           child: CommonContainer.statusChips(
//             horizontalPadding: 60,
//             tabs: const [
//               {"label": "General"},
//               {"label": "Teacher"},
//             ],
//             selectedIndex: selectedIndex,
//             onSelect: (i) => setState(() => selectedIndex = i),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ---------------------- Small UI helpers ----------------------
//
// class _TopImage extends StatelessWidget {
//   final String? imageUrl;
//   const _TopImage({required this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 160,
//       width: double.infinity,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: _NetworkOrAssetBg(url: imageUrl, asset: AppImages.announcement1),
//       ),
//     );
//   }
// }
//
// class _NetworkOrAssetBg extends StatelessWidget {
//   final String? url;
//   final String asset;
//   final BoxFit fit;
//   const _NetworkOrAssetBg({
//     required this.url,
//     required this.asset,
//     this.fit = BoxFit.cover,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final normalized = _normalizeUrl(url);
//     if (normalized == null) {
//       return Image.asset(asset, fit: fit);
//     }
//     return Image.network(
//       normalized,
//       fit: fit,
//       // Fallback on any network failure (DNS/404/etc.)
//       errorBuilder: (_, __, ___) => Image.asset(asset, fit: fit),
//     );
//   }
// }
//
// class _Empty extends StatelessWidget {
//   final String text;
//   const _Empty({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 80.0),
//       child: Text(
//         text,
//         style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.gray),
//       ),
//     );
//   }
// }
//
// class _ErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//   const _ErrorView({required this.message, required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 16),
//       child: Column(
//         children: [
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: GoogleFont.ibmPlexSans(fontSize: 14, color: Colors.red),
//           ),
//           const SizedBox(height: 12),
//           TextButton(onPressed: onRetry, child: const Text('Retry')),
//         ],
//       ),
//     );
//   }
// }
//
// /*
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../Core/Utility/app_color.dart';
// import '../../Core/Utility/app_images.dart';
// import '../../Core/Utility/google_fonts.dart';
// import '../../Core/Widgets/common_container.dart';
// import 'Model/announcement_details_response.dart';
// import 'controller/announcement_contorller.dart';
//
//
// /// ---------- small helpers ----------
// String _lc(String? s) => (s ?? '').toLowerCase();
//
// /// Normalize API image values that might be relative (e.g. "1000181681.jpg")
// String? _normalizeUrl(String? raw) {
//   if (raw == null) return null;
//   final r = raw.trim();
//   if (r.isEmpty) return null;
//   final uri = Uri.tryParse(r);
//   if (uri != null && uri.hasScheme) return r;
//
//   // 🔧 Update this base to your real static path if different
//   const base = 'https://next.fenizotechnologies.com/Adrox/./assets/images/support/';
//   return '$base$r';
// }
//
// String _formatDate(DateTime? dt) {
//   if (dt == null) return '-';
//   const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
//   final dd = dt.day.toString().padLeft(2, '0');
//   final mmm = months[dt.month - 1];
//   final yy = (dt.year % 100).toString().padLeft(2, '0');
//   return '$dd-$mmm-$yy';
// }
//
// /// ---------- PAGE ----------
// class AnnouncementDetailPage extends StatefulWidget {
//   final int id;
//   const AnnouncementDetailPage({super.key, required this.id});
//
//   @override
//   State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
// }
//
// class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
//   late final AnnouncementContorller c;
//
//   @override
//   void initState() {
//     super.initState();
//     c = Get.find<AnnouncementContorller>(); // ensure you bound it (Get.put) earlier
//     WidgetsBinding.instance.addPostFrameCallback((_) => c.fetch(widget.id));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Obx(() {
//           if (c.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (c.error.isNotEmpty) {
//             return _ErrorView(
//               message: c.error.value,
//               onRetry: () => c.fetch(widget.id),
//             );
//           }
//           final d = c.detail.value;
//           if (d == null) return const SizedBox.shrink();
//
//           final dateLabel = _formatDate(d.notifyDate);
//           final headerImage = _pickHeaderImage(d);
//
//           return CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: _Header(
//                   title: d.title,
//                   dateLabel: dateLabel,
//                   category: d.category,
//                   announcementCategory: d.announcementCategory,
//                   imageUrl: headerImage,
//                 ),
//               ),
//
//               SliverToBoxAdapter(child: const SizedBox(height: 16)),
//
//               // Main content sections
//               SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 sliver: SliverList.separated(
//                   itemCount: (d.contents ?? const []).length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 16),
//                   itemBuilder: (ctx, i) {
//                     final item = d.contents![i];
//                     switch (item.type) {
//                       case 'paragraph':
//                         return _ParagraphBlock(text: item.content ?? '');
//                       case 'list':
//                         return _ListBlock(items: item.items ?? const []);
//                       case 'image':
//                         return _ImageBlock(url: item.content);
//                       default:
//                         return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ),
//
//               SliverToBoxAdapter(child: const SizedBox(height: 24)),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   /// Use the first "image" from contents if any, otherwise null (asset fallback will be used).
//   String? _pickHeaderImage(AnnouncementDetail d) {
//     final img = (d.contents ?? const <AnnContent>[])
//         .where((e) => _lc(e.type as String?) == 'image')
//         .map((e) => e.content)
//         .firstOrNull;
//     return img;
//   }
// }
//
// /// ---------- HEADER ----------
// class _Header extends StatelessWidget {
//   final String title;
//   final String dateLabel;
//   final String category;
//   final String announcementCategory;
//   final String? imageUrl;
//
//   const _Header({
//     required this.title,
//     required this.dateLabel,
//     required this.category,
//     required this.announcementCategory,
//     required this.imageUrl,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 220,
//       width: double.infinity,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background image with rounded bottom
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(22),
//               bottomRight: Radius.circular(22),
//             ),
//             child: _NetworkOrAssetBg(
//               url: imageUrl,
//               asset: AppImages.announcement1,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // Gradient overlay
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.05),
//                     Colors.black.withOpacity(0.85),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//
//           // Top bar
//           Positioned(
//             top: 12,
//             left: 12,
//             right: 12,
//             child: Row(
//               children: [
//                 CommonContainer.NavigatArrow(
//                   image: AppImages.leftSideArrow,
//                   imageColor: AppColor.white,
//                   container: Colors.black26,
//                   onIconTap: () => Navigator.pop(context),
//                   border: Border.all(color: Colors.white24, width: 0.3),
//                 ),
//                 const Spacer(),
//               ],
//             ),
//           ),
//
//           // Bottom info
//           Positioned(
//             left: 16,
//             right: 16,
//             bottom: 14,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _Chip(text: category),
//                     _Chip(text: announcementCategory.replaceAll('_', ' ')),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(CupertinoIcons.clock_fill, size: 16, color: Colors.white),
//                         const SizedBox(width: 6),
//                         Text(
//                           dateLabel,
//                           style: GoogleFont.ibmPlexSans(fontSize: 13, color: Colors.white70),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   title,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFont.ibmPlexSans(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Chip extends StatelessWidget {
//   final String text;
//   const _Chip({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     if (text.trim().isEmpty) return const SizedBox.shrink();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white30, width: 0.6),
//       ),
//       child: Text(
//         text,
//         style: GoogleFont.ibmPlexSans(fontSize: 12, color: Colors.white),
//       ),
//     );
//   }
// }
//
// /// ---------- CONTENT BLOCKS ----------
// class _ParagraphBlock extends StatelessWidget {
//   final String text;
//   const _ParagraphBlock({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     if (text.trim().isEmpty) return const SizedBox.shrink();
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColor.lightWhite,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         text,
//         style: GoogleFont.ibmPlexSans(fontSize: 15, color: AppColor.lightBlack),
//       ),
//     );
//   }
// }
//
// class _ListBlock extends StatelessWidget {
//   final List<String> items;
//   const _ListBlock({required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) return const SizedBox.shrink();
//
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
//       decoration: BoxDecoration(
//         color: AppColor.lightWhite,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 6.0),
//             child: DottedLine(
//               dashColor: AppColor.borderGary,
//               dashGapLength: 6,
//               dashLength: 7,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ...List.generate(items.length, (i) {
//             final txt = items[i];
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 6.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('•  ', style: TextStyle(fontSize: 18)),
//                   Expanded(
//                     child: Text(
//                       txt,
//                       style: GoogleFont.ibmPlexSans(fontSize: 15, color: AppColor.lightBlack),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//           const SizedBox(height: 6),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 6.0),
//             child: DottedLine(
//               dashColor: AppColor.borderGary,
//               dashGapLength: 6,
//               dashLength: 7,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ImageBlock extends StatelessWidget {
//   final String? url;
//   const _ImageBlock({required this.url});
//
//   @override
//   Widget build(BuildContext context) {
//     final normalized = _normalizeUrl(url);
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: AspectRatio(
//         aspectRatio: 16 / 9,
//         child: (normalized == null)
//             ? Image.asset(AppImages.announcement1, fit: BoxFit.cover)
//             : Image.network(
//           normalized,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) =>
//               Image.asset(AppImages.announcement1, fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }
// }
//
// /// ---------- NET/ASSET BG ----------
// class _NetworkOrAssetBg extends StatelessWidget {
//   final String? url;
//   final String asset;
//   final BoxFit fit;
//   const _NetworkOrAssetBg({
//     required this.url,
//     required this.asset,
//     this.fit = BoxFit.cover,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final normalized = _normalizeUrl(url);
//     if (normalized == null) {
//       return Image.asset(asset, fit: fit);
//     }
//     return Image.network(
//       normalized,
//       fit: fit,
//       errorBuilder: (_, __, ___) => Image.asset(asset, fit: fit),
//     );
//   }
// }
//
// /// ---------- error view ----------
// class _ErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//   const _ErrorView({required this.message, required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 16),
//       child: Column(
//         children: [
//           Text(message, textAlign: TextAlign.center,
//               style: GoogleFont.ibmPlexSans(fontSize: 14, color: Colors.red)),
//           const SizedBox(height: 12),
//           TextButton(onPressed: onRetry, child: const Text('Retry')),
//         ],
//       ),
//     );
//   }
// }
// */
///***********old***********

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:st_teacher_app/Presentation/Exam%20Screen/screens/result_list.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Exam Screen/controller/exam_controller.dart';
import 'Model/announcement_details_response.dart';
import 'Model/announcement_list_general.dart';
import 'announcement_create.dart';
import 'controller/announcement_contorller.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

///*****old********

// class _AnnouncementScreenState extends State<AnnouncementScreen> {
//   final AnnouncementContorller controller = Get.put(AnnouncementContorller());
//   final ExamController examController = Get.put(ExamController());
//
//   int selectedIndex = 0; // 0 = General, 1 = Teacher
//
//   final List<Map<String, String>> subjects = [
//     {'subject': 'Tamil', 'mark': '70'},
//     {'subject': 'English', 'mark': '70'},
//     {'subject': 'Maths', 'mark': '70'},
//     {'subject': 'Science', 'mark': '70'},
//     {'subject': 'Social Science', 'mark': '70'},
//   ];
//
//   void _openFullScreenNetwork(String url) {
//     if (url.isEmpty) return;
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.9),
//       builder:
//           (_) => GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Center(
//               child: InteractiveViewer(
//                 minScale: 0.5,
//                 maxScale: 5,
//                 child: Image.network(url),
//               ),
//             ),
//           ),
//     );
//   }
//
//   // --------- SMALL HELPERS ---------
//   String _norm(String? s) => (s ?? '').trim().toLowerCase();
//
//   DateTime _asDate(dynamic v) {
//     if (v is DateTime) return v;
//     return DateTime.tryParse(v?.toString() ?? '') ??
//         DateTime.fromMillisecondsSinceEpoch(0);
//   }
//
//   // IDs sorted by notifyDate ASC within a given type (with tolerant synonyms)
//   List<int> _dateSortedIds({AnnouncementData? data, String? type}) {
//     final d = data ?? controller.announcementData.value;
//     if (d == null) return const [];
//
//     final wanted = _norm(type);
//
//     bool _matches(String? raw) {
//       final v = _norm(raw);
//       if (wanted.isEmpty) return true; // no filter
//       if (v == wanted) return true;
//       if (wanted == 'exammark' &&
//           (v == 'exam_mark' || v == 'examresult' || v == 'exam_result'))
//         return true;
//       if (wanted == 'exam' && v == 'exams') return true;
//       if (wanted == 'calendar' &&
//           (v == 'event' || v == 'events' || v == 'calendar_event'))
//         return true;
//       if (wanted == 'announcement' && v == 'announcements') return true;
//       if (wanted == 'feepayment' &&
//           (v == 'fee' || v == 'fees' || v == 'fee_payment' || v == 'fee-pay'))
//         return true;
//       return false;
//     }
//
//     final list = d.items.where((e) => _matches(e.type)).toList();
//
//     list.sort((a, b) {
//       final c = _asDate(a.notifyDate).compareTo(_asDate(b.notifyDate));
//       if (c != 0) return c;
//       return a.id.compareTo(b.id);
//     });
//
//     return list.map((e) => e.id).toList();
//   }
//
//   /* List<int> _dateSortedIdsSameTypeAs({
//      required AnnouncementData data,
//      required int id,
//      String? fallbackType, // optional: use when you *know* the type
//    }) {
//      // find the clicked item
//      AnnouncementItem? base;
//      try {
//        base = data.items.firstWhere((e) => e.id == id);
//      } catch (_) {
//        base = null;
//      }
//
//      // decide the wanted type
//      String wanted = _norm(base?.type ?? fallbackType ?? '');
//
//      // if we still don't know the type, safest is to scope to just the current id
//      if (wanted.isEmpty) return [id];
//
//      // matcher with tolerant synonyms
//      bool _typeMatches(String? raw) {
//        final v = _norm(raw);
//
//        if (v == wanted) return true;
//
//        // normalizations / synonyms
//        if (wanted == 'exammark' &&
//            (v == 'exam_mark' || v == 'examresult' || v == 'exam_result'))
//          return true;
//
//        if (wanted == 'exam' && (v == 'exams')) return true;
//
//        if (wanted == 'calendar' &&
//            (v == 'event' || v == 'events' || v == 'calendar_event'))
//          return true;
//
//        if (wanted == 'announcement' && (v == 'announcements')) return true;
//
//        if (wanted == 'feepayment' &&
//            (v == 'fee' || v == 'fees' || v == 'fee_payment' || v == 'fee-pay'))
//          return true;
//
//        return false;
//      }
//
//
//
//      void _openById(BuildContext ctx, int id, {String? forceType}) {
//        final data = controller.announcementData.value;
//        if (data == null) return;
//
//        // find the item & normalize its type
//        AnnouncementItem? item;
//        try {
//          item = data.items.firstWhere((e) => e.id == id);
//        } catch (_) {
//          return;
//        }
//        final t = _norm(forceType ?? item.type);
//
//        // build type-scoped order + current index
//        final order = _dateSortedIds(data: data, type: t);
//        final index = order.indexOf(id);
//
//        switch (t) {
//          case 'feepayment':
//          case 'fee':
//          case 'fees':
//          case 'fee_payment':
//          case 'fee-pay':
//            _feesSheet(ctx, id, order: order, index: index);
//            break;
//
//          case 'announcement':
//          case 'announcements':
//          case 'holiday': // treat like announcement if you want
//            _showAnnouncementDetails(ctx, id, order: order, index: index);
//            break;
//
//          case 'exam':
//          case 'exams':
//            showExamTimeTable(ctx, id, order: order, index: index);
//            break;
//
//          case 'exammark':
//          case 'exam_mark':
//          case 'examresult':
//          case 'exam_result':
//            _examResult(ctx, id, order: order, index: index);
//            break;
//
//          case 'calendar':
//          case 'event':
//          case 'events':
//          case 'calendar_event':
//            _showEventDetails(ctx, id, order: order, index: index);
//            break;
//
//          default:
//            _showAnnouncementDetails(ctx, id, order: order, index: index);
//        }
//      }*/
//
//   Widget _navHeader({
//     required BuildContext ctx,
//     required List<int>? order,
//     required int? index,
//     required bool disabled,
//     VoidCallback? onPrev,
//     VoidCallback? onNext,
//   }) {
//     final hasOrder = order != null && index != null && order.isNotEmpty;
//     final atStart = hasOrder ? index! <= 0 : true;
//     final atEnd = hasOrder ? index! >= order!.length - 1 : true;
//
//     // Treat these as "disabled" states for color + onPressed
//     final prevIsDisabled = (!hasOrder || atStart || disabled);
//     final nextIsDisabled = (!hasOrder || atEnd || disabled);
//
//     // Pick colors: low color when disabled, blue when active
//     final prevColor =
//         prevIsDisabled ? AppColor.blue.withOpacity(0.2) : AppColor.blue;
//     final nextColor =
//         nextIsDisabled ? AppColor.blue.withOpacity(0.2) : AppColor.blue;
//
//     return Row(
//       children: [
//         // PREVIOUS
//         IconButton(
//           icon: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: prevColor),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Row(
//                 children: [
//                   Icon(CupertinoIcons.chevron_left, color: prevColor),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Previous',
//                     style: GoogleFont.ibmPlexSans(
//                       fontWeight: FontWeight.w600,
//                       color: prevColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           onPressed: prevIsDisabled ? null : onPrev,
//         ),
//
//         const Spacer(),
//
//         // NEXT
//         IconButton(
//           icon: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: nextColor),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 25.0,
//                 vertical: 10,
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     'Next',
//                     style: GoogleFont.ibmPlexSans(
//                       fontWeight: FontWeight.w600,
//                       color: nextColor,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Icon(CupertinoIcons.chevron_right, color: nextColor),
//                 ],
//               ),
//             ),
//           ),
//           onPressed: nextIsDisabled ? null : onNext,
//         ),
//       ],
//     );
//   }
//
//   void _feessSheet(BuildContext context) {
//     /* showModalBottomSheet(
//        context: context,
//        isScrollControlled: true,
//        backgroundColor: Colors.transparent,
//        builder: (_) {
//          return DraggableScrollableSheet(
//            initialChildSize: 0.55,
//            minChildSize: 0.20,
//            maxChildSize: 0.55,
//            expand: false,
//            builder: (context, scrollController) {
//              final items = ['Shoes', 'Notebooks', 'Tuition Fees'];
//
//              return Container(
//                decoration: BoxDecoration(
//                  color: AppColor.white,
//                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                ),
//                child: ListView(
//                  controller: scrollController,
//                  padding: const EdgeInsets.all(16),
//                  children: [
//                    Center(
//                      child: Container(
//                        height: 4,
//                        width: 40,
//                        decoration: BoxDecoration(
//                          color: AppColor.grayop,
//                          borderRadius: BorderRadius.circular(2),
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: 20),
//
//                    Image.asset(AppImages.announcement2),
//                    SizedBox(height: 20),
//
//                    Row(
//                      children: [
//                        Expanded(
//                          child: Text(
//                            'Third-Term Fees',
//                            style: GoogleFont.ibmPlexSans(
//                              fontSize: 22,
//                              fontWeight: FontWeight.w500,
//                              color: AppColor.black,
//                            ),
//                          ),
//                        ),
//                        Column(
//                          children: [
//                            Text(
//                              'Due date',
//                              style: GoogleFont.ibmPlexSans(
//                                fontSize: 12,
//                                color: AppColor.lowGrey,
//                              ),
//                            ),
//                            Text(
//                              '12-Dec-25',
//                              style: GoogleFont.ibmPlexSans(
//                                fontSize: 14,
//                                fontWeight: FontWeight.w500,
//                                color: AppColor.black,
//                              ),
//                            ),
//                          ],
//                        ),
//                        SizedBox(width: 4),
//                        Icon(
//                          CupertinoIcons.clock_fill,
//                          size: 30,
//                          color: AppColor.grayop,
//                        ),
//                      ],
//                    ),
//                    SizedBox(height: 20),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: List.generate(
//                        items.length,
//                        (index) => Padding(
//                          padding: const EdgeInsets.only(bottom: 8),
//                          child: Text(
//                            '${index + 1}. ${items[index]}',
//                            style: GoogleFont.ibmPlexSans(
//                              fontSize: 16,
//                              color: AppColor.lightBlack,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: 15),
//
//                    ElevatedButton(
//                      onPressed: () {},
//                      style: ButtonStyle(
//                        padding: MaterialStateProperty.all(EdgeInsets.zero),
//                        shape: MaterialStateProperty.all(
//                          RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(20),
//                          ),
//                        ),
//                        elevation: MaterialStateProperty.all(0),
//                        backgroundColor: MaterialStateProperty.all(
//                          Colors.transparent,
//                        ),
//                      ),
//                      child: Ink(
//                        decoration: BoxDecoration(
//                          gradient: LinearGradient(
//                            colors: [AppColor.blueG1, AppColor.blueG2],
//                            begin: Alignment.topRight,
//                            end: Alignment.bottomRight,
//                          ),
//                          borderRadius: BorderRadius.circular(20),
//                        ),
//                        child: Container(
//                          alignment: Alignment.center,
//                          height: 50,
//                          width: double.infinity,
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              Text(
//                                'Pay Rs.15,000',
//                                style: GoogleFont.ibmPlexSans(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.w800,
//                                  color: AppColor.white,
//                                ),
//                              ),
//                              SizedBox(width: 5),
//                              Icon(
//                                CupertinoIcons.right_chevron,
//                                size: 14,
//                                weight: 20,
//                                color: AppColor.white,
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              );
//            },
//          );
//        },
//      );*/
//   }
//
//   ///*******old _examResult *********///
//   /* void _examResult(BuildContext context) {
//      showModalBottomSheet(
//        context: context,
//        isScrollControlled: true,
//        backgroundColor: Colors.transparent,
//        builder: (_) {
//          return DraggableScrollableSheet(
//            initialChildSize: 0.65,
//            minChildSize: 0.20,
//            maxChildSize: 0.65,
//            expand: false,
//            builder: (context, scrollController) {
//              return Container(
//                decoration: BoxDecoration(
//                  color: AppColor.white,
//                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                ),
//                child: ListView(
//                  controller: scrollController,
//                  padding: const EdgeInsets.all(16),
//                  children: [
//                    Center(
//                      child: Container(
//                        height: 4,
//                        width: 40,
//                        decoration: BoxDecoration(
//                          color: AppColor.borderGary,
//                          borderRadius: BorderRadius.circular(2),
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: 40),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                        Text(
//                          'Third term fees Result',
//                          style: GoogleFont.ibmPlexSans(
//                            fontSize: 18,
//                            fontWeight: FontWeight.w600,
//                            color: AppColor.lightBlack,
//                          ),
//                        ),
//                        SizedBox(height: 7),
//                        RichText(
//                          text: TextSpan(
//                            text: 'A+',
//                            style: GoogleFont.ibmPlexSans(
//                              fontSize: 43,
//                              fontWeight: FontWeight.w600,
//                              color: AppColor.green,
//                            ),
//                            children: [
//                              TextSpan(
//                                text: ' Grade',
//                                style: GoogleFont.ibmPlexSans(
//                                  fontSize: 43,
//                                  fontWeight: FontWeight.w600,
//                                  color: AppColor.black,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                        SizedBox(height: 26),
//                        Padding(
//                          padding: EdgeInsets.symmetric(horizontal: 35.0),
//                          child: DottedLine(
//                            dashColor: AppColor.borderGary,
//                            dashGapLength: 6,
//                            dashLength: 7,
//                          ),
//                        ),
//                        SizedBox(height: 15),
//                        Stack(
//                          children: [
//                            Positioned.fill(
//                              child: Image.asset(
//                                AppImages.examResultBCImage,
//                                height: 100,
//                                width: 180,
//                              ),
//                            ),
//
//                            ListView.builder(
//                              shrinkWrap: true,
//                              physics: NeverScrollableScrollPhysics(),
//                              itemCount: subjects.length,
//                              itemBuilder: (context, index) {
//                                final subject = subjects[index];
//                                return Padding(
//                                  padding: const EdgeInsets.symmetric(
//                                    vertical: 8.0,
//                                    horizontal: 16,
//                                  ),
//                                  child: Padding(
//                                    padding: const EdgeInsets.symmetric(
//                                      horizontal: 38.0,
//                                    ),
//                                    child: Row(
//                                      children: [
//                                        Text(
//                                          subject['subject']!,
//                                          style: GoogleFont.ibmPlexSans(
//                                            fontSize: 14,
//                                            fontWeight: FontWeight.w600,
//                                            color: AppColor.gray,
//                                          ),
//                                        ),
//                                        SizedBox(width: 30),
//                                        Text(
//                                          subject['mark']!,
//                                          style: GoogleFont.ibmPlexSans(
//                                            fontSize: 20,
//                                            fontWeight: FontWeight.w500,
//                                            color: AppColor.black,
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                );
//                              },
//                            ),
//                          ],
//                        ),
//
//                        Padding(
//                          padding: EdgeInsets.symmetric(horizontal: 35.0),
//                          child: DottedLine(
//                            dashColor: AppColor.borderGary,
//                            dashGapLength: 6,
//                            dashLength: 7,
//                          ),
//                        ),
//                        SizedBox(height: 30),
//                        GestureDetector(
//                          onTap: () {
//                            Navigator.pop(context);
//                          },
//                          child: Center(
//                            child: Container(
//                              padding: EdgeInsets.symmetric(
//                                vertical: 12,
//                                horizontal: 30,
//                              ),
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(16),
//                                border: Border.all(
//                                  color: AppColor.blue,
//                                  width: 1,
//                                ),
//                              ),
//                              child: CustomTextField.textWithSmall(
//                                text: 'Close',
//                                color: AppColor.blue,
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              );
//            },
//          );
//        },
//      );
//    }*/
//
//   ///*******new _examResult *********///
//   void _examResult(
//     BuildContext context,
//     int id, {
//     List<int>? order,
//     int? index,
//   }) {
//     int currIndex = index ?? 0;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             void goTo(int nextIndex) {
//               if (order == null || order.isEmpty) return;
//               currIndex = nextIndex.clamp(0, order.length - 1);
//               // If result content depends on ID, fetch here and setSheetState
//               setSheetState(() {});
//             }
//
//             return DraggableScrollableSheet(
//               initialChildSize: 0.65,
//               minChildSize: 0.20,
//               maxChildSize: 0.65,
//               expand: false,
//               builder: (context, scrollController) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: AppColor.white,
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(20),
//                     ),
//                   ),
//                   child: ListView(
//                     controller: scrollController,
//                     padding: const EdgeInsets.all(16),
//                     children: [
//                       Center(
//                         child: Container(
//                           height: 4,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             color: AppColor.borderGary,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//
//                       _navHeader(
//                         ctx: context,
//                         order: order,
//                         index: currIndex,
//                         disabled: false,
//                         onPrev: () => goTo(currIndex - 1),
//                         onNext: () => goTo(currIndex + 1),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // ... your existing result UI (unchanged) ...
//                       // NOTE: if per-ID marks differ, fetch & bind here like in announcements.
//
//                       // Close
//                       const SizedBox(height: 20),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Center(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 30,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: AppColor.blue,
//                                 width: 1,
//                               ),
//                             ),
//                             child: CustomTextField.textWithSmall(
//                               text: 'Close',
//                               color: AppColor.blue,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   ///*******old _showAnnouncementDetails *********///
//   /*   void _showAnnouncementDetails(BuildContext context, int id) async {
//      AnnouncementDetails? details;
//
//      // If already fetched for the same ID, use it directly
//      if (controller.announcementDetails.value != null &&
//          controller.announcementDetails.value!.id == id) {
//        details = controller.announcementDetails.value;
//      } else {
//        // Otherwise fetch from API
//        details = await controller.getAnnouncementDetails(id: id);
//      }
//
//      if (details == null) return;
//
//      showModalBottomSheet(
//        context: context,
//        isScrollControlled: true,
//        backgroundColor: Colors.white,
//        shape: const RoundedRectangleBorder(
//          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//        ),
//        builder: (context) {
//          return DraggableScrollableSheet(
//            expand: false,
//            initialChildSize: 0.75,
//            minChildSize: 0.4,
//            maxChildSize: 0.95,
//            builder: (_, controller) {
//              return SingleChildScrollView(
//                controller: controller,
//                padding: const EdgeInsets.all(20),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                    // Grab Handle
//                    Center(
//                      child: Container(
//                        width: 40,
//                        height: 5,
//                        decoration: BoxDecoration(
//                          color: Colors.grey[400],
//                          borderRadius: BorderRadius.circular(10),
//                        ),
//                      ),
//                    ),
//                    const SizedBox(height: 16),
//
//                    // Image (if exists)
//                    // if (details!.contents.isNotEmpty &&
//                    //     details.contents.first.type == "image")
//                    //   ClipRRect(
//                    //     borderRadius: BorderRadius.circular(16),
//                    //     child: Image.network(
//                    //       details.contents.first.content ?? "",
//                    //       fit: BoxFit.cover,
//                    //     ),
//                    //   ),
//                    const SizedBox(height: 20),
//
//                    // Title
//                    Text(
//                      details?.title.toString() ?? '',
//                      style: const TextStyle(
//                        fontSize: 22,
//                        fontWeight: FontWeight.w700,
//                      ),
//                    ),
//
//                    const SizedBox(height: 8),
//
//                    // Date
//                    Row(
//                      children: [
//                        const Icon(
//                          Icons.calendar_today,
//                          size: 16,
//                          color: Colors.grey,
//                        ),
//                        const SizedBox(width: 6),
//                        Text(
//                          DateFormat('dd-MMM-yyyy').format(
//                            DateTime.parse(details?.notifyDate.toString() ?? ''),
//                          ),
//                          style: const TextStyle(color: Colors.grey),
//                        ),
//                      ],
//                    ),
//
//                    const SizedBox(height: 16),
//
//                    // Content
//                    Text(
//                      details?.content.toString() ?? '',
//                      style: const TextStyle(fontSize: 16, height: 1.5),
//                    ),
//
//                    const SizedBox(height: 20),
//
//                    // Extra dynamic contents
//                    if (details!.contents.isNotEmpty)
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children:
//                            details.contents.map((c) {
//                              if (c.type == "paragraph") {
//                                return Padding(
//                                  padding: const EdgeInsets.only(bottom: 12),
//                                  child: Text(
//                                    c.content ?? "",
//                                    style: const TextStyle(fontSize: 15),
//                                  ),
//                                );
//                              } else if (c.type == "list") {
//                                return Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children:
//                                      c.items
//                                          ?.map(
//                                            (e) => Row(
//                                              children: [
//                                                const Icon(
//                                                  Icons.check,
//                                                  color: Colors.green,
//                                                  size: 18,
//                                                ),
//                                                const SizedBox(width: 6),
//                                                Expanded(child: Text(e)),
//                                              ],
//                                            ),
//                                          )
//                                          .toList() ??
//                                      [],
//                                );
//                              } else if (c.type == "image") {
//                                return Padding(
//                                  padding: const EdgeInsets.symmetric(
//                                    vertical: 10,
//                                  ),
//                                  child: ClipRRect(
//                                    borderRadius: BorderRadius.circular(12),
//                                    child: Image.network(c.content ?? ""),
//                                  ),
//                                );
//                              }
//                              return const SizedBox.shrink();
//                            }).toList(),
//                      ),
//                  ],
//                ),
//              );
//            },
//          );
//        },
//      );
//    }*/
//   ///*******new _showAnnouncementDetails *********///
//   void _showAnnouncementDetails(
//     BuildContext context,
//     int id, {
//     List<int>? order,
//     int? index,
//   }) async {
//     // local state for this sheet
//     int currIndex = index ?? 0;
//     int currId = id;
//
//     AnnouncementDetails? details;
//     Future<void> _load(int _id) async {
//       if (controller.announcementDetails.value != null &&
//           controller.announcementDetails.value!.id == _id) {
//         details = controller.announcementDetails.value;
//       } else {
//         details = await controller.getAnnouncementDetails(id: _id);
//       }
//     }
//
//     await _load(currId);
//     if (details == null) return;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             Future<void> goTo(int nextIndex) async {
//               if (order == null || order.isEmpty) return;
//               currIndex = nextIndex.clamp(0, order.length - 1);
//               currId = order[currIndex];
//               await _load(currId);
//               setSheetState(() {}); // re-render without closing
//             }
//
//             return DraggableScrollableSheet(
//               expand: false,
//               initialChildSize: 0.75,
//               minChildSize: 0.4,
//               maxChildSize: 0.95,
//               builder: (_, controllerScroll) {
//                 return SingleChildScrollView(
//                   controller: controllerScroll,
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Grab handle
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//
//                       // Prev / Next header
//                       _navHeader(
//                         ctx: context,
//                         order: order,
//                         index: currIndex,
//                         disabled: false,
//                         onPrev: () => goTo(currIndex - 1),
//                         onNext: () => goTo(currIndex + 1),
//                       ),
//                       const SizedBox(height: 12),
//
//                       // Title
//                       Text(
//                         details?.title ?? '',
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//
//                       // Date
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.calendar_today,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             DateFormat('dd-MMM-yyyy').format(
//                               DateTime.tryParse(
//                                     details?.notifyDate.toString() ?? '',
//                                   ) ??
//                                   DateTime.now(),
//                             ),
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Content
//                       Text(
//                         details?.content ?? '',
//                         style: const TextStyle(fontSize: 16, height: 1.5),
//                       ),
//                       const SizedBox(height: 16),
//
//                       if (details != null && details!.contents.isNotEmpty)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children:
//                               details!.contents.map((c) {
//                                 if (c.type == "paragraph") {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(bottom: 12),
//                                     child: Text(
//                                       c.content ?? "",
//                                       style: const TextStyle(fontSize: 15),
//                                     ),
//                                   );
//                                 } else if (c.type == "list") {
//                                   return Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children:
//                                         (c.items ?? [])
//                                             .map(
//                                               (e) => Row(
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.check,
//                                                     color: Colors.green,
//                                                     size: 18,
//                                                   ),
//                                                   const SizedBox(width: 6),
//                                                   Expanded(child: Text(e)),
//                                                 ],
//                                               ),
//                                             )
//                                             .toList(),
//                                   );
//                                 } else if (c.type == "image") {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 10,
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(12),
//                                       child: Image.network(c.content ?? ""),
//                                     ),
//                                   );
//                                 }
//                                 return const SizedBox.shrink();
//                               }).toList(),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   ///*******old showExamTimeTable *********///
//   /*  void showExamTimeTable(BuildContext context, int examId) async {
//      // Fetch details if not already fetched
//      if (examController.examDetails.value == null ||
//          examController.examDetails.value!.exam.id != examId) {
//        await examController.getExamDetailsList(examId: examId);
//      }
//
//      final details = examController.examDetails.value;
//      if (details == null) return;
//
//      showModalBottomSheet(
//        context: context,
//        isScrollControlled: true,
//        backgroundColor: Colors.white,
//        shape: const RoundedRectangleBorder(
//          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//        ),
//        builder: (context) {
//          return DraggableScrollableSheet(
//            expand: false,
//            initialChildSize: 0.75,
//            minChildSize: 0.4,
//            maxChildSize: 0.95,
//            builder: (_, scrollController) {
//              return SingleChildScrollView(
//                controller: scrollController,
//                padding: const EdgeInsets.all(20),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                    // Grab Handle
//                    Center(
//                      child: Container(
//                        width: 40,
//                        height: 5,
//                        decoration: BoxDecoration(
//                          color: Colors.grey[400],
//                          borderRadius: BorderRadius.circular(10),
//                        ),
//                      ),
//                    ),
//                    const SizedBox(height: 16),
//
//                    // Timetable Image
//                    const SizedBox(height: 20),
//
//                    // Exam Title
//                    Text(
//                      details.exam.heading ?? '',
//                      style: const TextStyle(
//                        fontSize: 22,
//                        fontWeight: FontWeight.w700,
//                      ),
//                    ),
//
//                    const SizedBox(height: 8),
//
//                    // Exam Dates
//                    Row(
//                      children: [
//                        const Icon(
//                          Icons.calendar_today,
//                          size: 16,
//                          color: Colors.grey,
//                        ),
//                        const SizedBox(width: 6),
//                        Text(
//                          '${details.exam.startDate} to ${details.exam.endDate}',
//                          style: const TextStyle(color: Colors.grey),
//                        ),
//                      ],
//                    ),
//
//                    const SizedBox(height: 16),
//                    if (details.exam.timetableUrl != null &&
//                        details.exam.timetableUrl!.isNotEmpty)
//                      ClipRRect(
//                        borderRadius: BorderRadius.circular(16),
//                        child: Image.network(
//                          details.exam.timetableUrl!,
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                  ],
//                ),
//              );
//            },
//          );
//        },
//      );
//    }*/
//   ///*******new showExamTimeTable *********///
//   void showExamTimeTable(
//     BuildContext context,
//     int examId, {
//     List<int>? order,
//     int? index,
//   }) async {
//     int currIndex = index ?? 0;
//     int currId = examId;
//
//     Future<void> _load(int id) async {
//       if (examController.examDetails.value == null ||
//           examController.examDetails.value!.exam.id != id) {
//         await examController.getExamDetailsList(examId: id);
//       }
//     }
//
//     await _load(currId);
//     final first = examController.examDetails.value;
//     if (first == null) return;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             Future<void> goTo(int nextIndex) async {
//               if (order == null || order.isEmpty) return;
//               currIndex = nextIndex.clamp(0, order.length - 1);
//               currId = order[currIndex];
//               await _load(currId);
//               setSheetState(() {}); // refresh
//             }
//
//             final details = examController.examDetails.value!;
//             return DraggableScrollableSheet(
//               expand: false,
//               initialChildSize: 0.75,
//               minChildSize: 0.4,
//               maxChildSize: 0.95,
//               builder: (_, sc) {
//                 return SingleChildScrollView(
//                   controller: sc,
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//
//                       _navHeader(
//                         ctx: context,
//                         order: order,
//                         index: currIndex,
//                         disabled: false,
//                         onPrev: () => goTo(currIndex - 1),
//                         onNext: () => goTo(currIndex + 1),
//                       ),
//                       const SizedBox(height: 12),
//
//                       Text(
//                         details.exam.heading ?? '',
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.calendar_today,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             '${details.exam.startDate} to ${details.exam.endDate}',
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       if ((details.exam.timetableUrl ?? '').isNotEmpty)
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.network(
//                             details.exam.timetableUrl!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   ///*******old _showEventDetails *********///
//   /*   void _showEventDetails(
//        BuildContext context,
//        String title,
//        DateTime time,
//        String image,
//        ) async {
//      showModalBottomSheet(
//        context: context,
//        isScrollControlled: true,
//        backgroundColor: Colors.white,
//        shape: const RoundedRectangleBorder(
//          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//        ),
//        builder: (context) {
//          return DraggableScrollableSheet(
//            expand: false,
//            initialChildSize: 0.50,
//            minChildSize: 0.4,
//            maxChildSize: 0.95,
//            builder: (_, controller) {
//              return SingleChildScrollView(
//                controller: controller,
//                padding: const EdgeInsets.all(20),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                    // Grab Handle
//                    Center(
//                      child: Container(
//                        width: 40,
//                        height: 5,
//                        decoration: BoxDecoration(
//                          color: Colors.grey[400],
//                          borderRadius: BorderRadius.circular(10),
//                        ),
//                      ),
//                    ),
//
//                    // Image (if exists)
//                    // if (details!.contents.isNotEmpty &&
//                    //     details.contents.first.type == "image")
//                    SizedBox(height: 8),
//                    // Title
//                    Text(
//                      title.toUpperCase(),
//                      style: GoogleFont.ibmPlexSans(
//                        fontSize: 22,
//                        fontWeight: FontWeight.w700,
//                      ),
//                    ),
//
//                    SizedBox(height: 8),
//
//                    Row(
//                      children: [
//                        const Icon(
//                          Icons.calendar_today,
//                          size: 16,
//                          color: Colors.grey,
//                        ),
//                        const SizedBox(width: 6),
//                        Text(
//                          DateFormat(
//                            'dd-MMM-yyyy',
//                          ).format(DateTime.parse(time.toString())),
//                          style: const TextStyle(color: Colors.grey),
//                        ),
//                      ],
//                    ),
//                    SizedBox(height: 25),
//                    GestureDetector(
//                      onTap: () {
//                        _openFullScreenNetwork(image.toString() ?? "");
//                      },
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(16),
//                        child: Image.network(
//                          image.toString() ?? "",
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              );
//            },
//          );
//        },
//      );
//    }*/
//
//   ///*******new _showEventDetails *********///
//   void _showEventDetails(
//     BuildContext context,
//     int id,
//     DateTime notifyDate,
//     String image, {
//     List<int>? order,
//     int? index,
//   }) {
//     final data = controller.announcementData.value;
//     if (data == null) return;
//
//     int currIndex = index ?? 0;
//     int currId = id;
//
//     AnnouncementItem? _get(int _id) {
//       try {
//         return data.items.firstWhere((e) => e.id == _id);
//       } catch (_) {
//         return null;
//       }
//     }
//
//     AnnouncementItem? item = _get(currId);
//     if (item == null) return;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             void goTo(int nextIndex) {
//               if (order == null || order.isEmpty) return;
//               currIndex = nextIndex.clamp(0, order.length - 1);
//               currId = order[currIndex];
//               item = _get(currId);
//               setSheetState(() {});
//             }
//
//             return DraggableScrollableSheet(
//               expand: false,
//               initialChildSize: 0.50,
//               minChildSize: 0.4,
//               maxChildSize: 0.95,
//               builder: (_, controllerScroll) {
//                 return SingleChildScrollView(
//                   controller: controllerScroll,
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//
//                       _navHeader(
//                         ctx: context,
//                         order: order,
//                         index: currIndex,
//                         disabled: false,
//                         onPrev: () => goTo(currIndex - 1),
//                         onNext: () => goTo(currIndex + 1),
//                       ),
//                       const SizedBox(height: 12),
//
//                       Text(
//                         _norm(item?.title).toUpperCase(),
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.calendar_today,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             DateFormat('dd-MMM-yyyy').format(item!.notifyDate),
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//
//                       GestureDetector(
//                         onTap: () => _openFullScreenNetwork(item?.image ?? ""),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.network(
//                             item?.image ?? "",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getCategoryList(showLoader: false);
//
//       if (controller.announcementData.value == null) {
//         controller.getAnnouncement(type: "general");
//       }
//     });
//   }
//
//   // Widget _buildGeneralTab(List<AnnouncementItem> items) {
//   //   // General: everything except teacher-specific category name
//   //   final list =
//   //       items.where((e) {
//   //         final cat = e.category.toLowerCase();
//   //         final ac = e.announcementCategory.toLowerCase();
//   //         return !(cat == 'teachers' || ac.startsWith('teacher'));
//   //       }).toList();
//   //
//   //   return Column(
//   //     children: [
//   //       for (final a in list) ...[
//   //         _AnnouncementCard(a),
//   //         const SizedBox(height: 20),
//   //       ],
//   //     ],
//   //   );
//   // }
//   //
//   // Widget _buildTeacherTab(List<AnnouncementItem> items) {
//   //   // Teacher tab: teacher_* or category == Teachers
//   //   final list =
//   //       items.where((e) {
//   //         final cat = e.category.toLowerCase();
//   //         final ac = e.announcementCategory.toLowerCase();
//   //         return cat == 'teachers' || ac.startsWith('teacher');
//   //       }).toList();
//   //
//   //   return Column(
//   //     children: [
//   //       for (final a in list) ...[
//   //         _AnnouncementCard(a),
//   //         const SizedBox(height: 20),
//   //       ],
//   //     ],
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Obx(() {
//           final data = controller.announcementData.value;
//
//           if (controller.isLoading.value) {
//             return Center(child: AppLoader.circularLoader());
//           }
//
//           if (data == null || data.items.isEmpty) {
//             return Container(
//               padding: EdgeInsets.symmetric(vertical: 80),
//               decoration: BoxDecoration(color: AppColor.white),
//               child: Column(
//                 children: [
//                   Center(
//                     child: Text(
//                       'No announcements available',
//                       style: GoogleFont.ibmPlexSans(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         color: AppColor.gray,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Image.asset(AppImages.noDataFound),
//                 ],
//               ),
//             );
//           }
//
//           return RefreshIndicator(
//             onRefresh: () async {
//               await controller.getAnnouncement(
//                 type: selectedIndex == 0 ? "general" : "teacher",
//               );
//             },
//             child: ListView.builder(
//               physics: BouncingScrollPhysics(),
//               padding: const EdgeInsets.all(15),
//               itemCount: data.items.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: Center(
//                       child: Text(
//                         selectedIndex == 0
//                             ? 'General Announcements'
//                             : 'Teacher Announcements',
//                         style: GoogleFont.ibmPlexSans(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 26,
//                           color: AppColor.black,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//
//                 final item = data.items[index - 1];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: CommonContainer.announcementsScreen(
//                     mainText: item.announcementCategory,
//                     backRoundImage: item.image,
//                     iconData: CupertinoIcons.clock_fill,
//                     additionalText1: "Date",
//                     additionalText2: DateFormat(
//                       "dd-MMM-yy",
//                     ).format(DateTime.parse(item.notifyDate.toString())),
//                     verticalPadding: 12,
//                     gradientStartColor: AppColor.black.withOpacity(0.01),
//                     gradientEndColor: AppColor.black,
//                     onDetailsTap: () async {
//                       if (item.type == "exammark") {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) => ResultList(
//                                   examId: item.id,
//                                   tittle: item.title,
//                                   startDate: '',
//                                   endDate: '',
//                                 ),
//                           ),
//                         );
//                       } else if (item.type == "announcement" ||
//                           item.type == "holiday") {
//                         _showAnnouncementDetails(context, item.id);
//                       } else if (item.type == "exam") {
//                         showExamTimeTable(context, item.id);
//                       } else if (item.type == "calendar") {
//                         print(item.id);
//                         print('calendar');
//                         _showEventDetails(
//                           context,
//                           item.title as int,
//                           item.notifyDate,
//                           item.image,
//                         );
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         }),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: const BoxDecoration(color: Colors.white),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildTabButton("General", 0),
//             _buildTabButton("Teacher", 1),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabButton(String label, int index) {
//     final isSelected = selectedIndex == index;
//     return GestureDetector(
//       onTap: () async {
//         setState(() => selectedIndex = index);
//         // Call API based on selected tab
//         await controller.getAnnouncement(
//           type: selectedIndex == 0 ? "general" : "teacher",
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.shade50 : Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(
//             color: isSelected ? Colors.blue : Colors.grey.shade400,
//             width: 1.5,
//           ),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: isSelected ? Colors.blue : Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
// }

///********new*******

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final AnnouncementContorller controller = Get.put(AnnouncementContorller());
  final ExamController examController = Get.put(ExamController());

  int selectedIndex = 0; // 0 = General, 1 = Teacher

  final List<Map<String, String>> subjects = [
    {'subject': 'Tamil', 'mark': '70'},
    {'subject': 'English', 'mark': '70'},
    {'subject': 'Maths', 'mark': '70'},
    {'subject': 'Science', 'mark': '70'},
    {'subject': 'Social Science', 'mark': '70'},
  ];

  // ============== UTILITIES ==============
  void _openFullScreenNetwork(String url) {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder:
          (_) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Image.network(url),
              ),
            ),
          ),
    );
  }

  String _norm(String? s) => (s ?? '').trim().toLowerCase();

  DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    return DateTime.tryParse(v?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  // IDs sorted by notifyDate ASC within a given type (with tolerant synonyms)
  List<int> _dateSortedIds({AnnouncementData? data, String? type}) {
    final d = data ?? controller.announcementData.value;
    if (d == null) return const [];

    final wanted = _norm(type);

    bool _matches(String? raw) {
      final v = _norm(raw);
      if (wanted.isEmpty) return true; // no filter
      if (v == wanted) return true;
      if (wanted == 'exammark' &&
          (v == 'exam_mark' || v == 'examresult' || v == 'exam_result'))
        return true;
      if (wanted == 'exam' && v == 'exams') return true;
      if (wanted == 'calendar' &&
          (v == 'event' || v == 'events' || v == 'calendar_event'))
        return true;
      if (wanted == 'announcement' && v == 'announcements') return true;
      if (wanted == 'feepayment' &&
          (v == 'fee' || v == 'fees' || v == 'fee_payment' || v == 'fee-pay'))
        return true;
      return false;
    }

    final list = d.items.where((e) => _matches(e.type)).toList();

    list.sort((a, b) {
      final c = _asDate(a.notifyDate).compareTo(_asDate(b.notifyDate));
      if (c != 0) return c;
      return a.id.compareTo(b.id);
    });

    return list.map((e) => e.id).toList();
  }

  // Same-type ids when you only know a clicked id
  List<int> _dateSortedIdsSameTypeAs({
    required AnnouncementData data,
    required int id,
    String? fallbackType,
  }) {
    AnnouncementItem? base;
    try {
      base = data.items.firstWhere((e) => e.id == id);
    } catch (_) {
      base = null;
    }

    final wanted = _norm(base?.type ?? fallbackType ?? '');
    if (wanted.isEmpty) return [id];

    bool _typeMatches(String? raw) {
      final v = _norm(raw);
      if (v == wanted) return true;
      if (wanted == 'exammark' &&
          (v == 'exam_mark' || v == 'examresult' || v == 'exam_result'))
        return true;
      if (wanted == 'exam' && (v == 'exams')) return true;
      if (wanted == 'calendar' &&
          (v == 'event' || v == 'events' || v == 'calendar_event'))
        return true;
      if (wanted == 'announcement' && (v == 'announcements')) return true;
      if (wanted == 'feepayment' &&
          (v == 'fee' || v == 'fees' || v == 'fee_payment' || v == 'fee-pay'))
        return true;
      return false;
    }

    final list = data.items.where((e) => _typeMatches(e.type)).toList();
    if (list.isEmpty) return [id];

    list.sort((a, b) {
      final c = _asDate(a.notifyDate).compareTo(_asDate(b.notifyDate));
      if (c != 0) return c;
      return a.id.compareTo(b.id);
    });

    return list.map((e) => e.id).toList();
  }

  // ============== UNIFIED OPEN ==============
  void _openById(BuildContext ctx, int id, {String? forceType}) {
    final data = controller.announcementData.value;
    if (data == null) return;

    AnnouncementItem? item;
    try {
      item = data.items.firstWhere((e) => e.id == id);
    } catch (_) {
      return;
    }
    final t = _norm(forceType ?? item.type);

    final order = _dateSortedIds(data: data, type: t);
    final index = order.indexOf(id);

    switch (t) {
      case 'feepayment':
      case 'fee':
      case 'fees':
      case 'fee_payment':
      case 'fee-pay':
        _feesSheet(ctx, id, order: order, index: index);
        break;

      case 'announcement':
      case 'announcements':
      case 'holiday':
        _showAnnouncementDetails(ctx, id, order: order, index: index);
        break;

      case 'exam':
      case 'exams':
        showExamTimeTable(ctx, id, order: order, index: index);
        break;

      case 'exammark':
      case 'exam_mark':
      case 'examresult':
      case 'exam_result':
        _examResult(ctx, id, order: order, index: index);
        break;

      case 'calendar':
      case 'event':
      case 'events':
      case 'calendar_event':
        _showEventDetails(ctx, id, order: order, index: index);
        break;

      default:
        _showAnnouncementDetails(ctx, id, order: order, index: index);
    }
  }

  // ============== NAV HEADER ==============
  Widget _navHeader({
    required BuildContext ctx,
    required List<int>? order,
    required int? index,
    required bool disabled,
    VoidCallback? onPrev,
    VoidCallback? onNext,
  }) {
    final hasOrder = order != null && index != null && order.isNotEmpty;
    final atStart = hasOrder ? index! <= 0 : true;
    final atEnd = hasOrder ? index! >= order!.length - 1 : true;

    final prevIsDisabled = (!hasOrder || atStart || disabled);
    final nextIsDisabled = (!hasOrder || atEnd || disabled);

    final prevColor =
        prevIsDisabled ? AppColor.blue.withOpacity(0.2) : AppColor.blue;
    final nextColor =
        nextIsDisabled ? AppColor.blue.withOpacity(0.2) : AppColor.blue;

    return Row(
      children: [
        // PREVIOUS
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: prevColor),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(CupertinoIcons.chevron_left, color: prevColor),
                  const SizedBox(width: 8),
                  Text(
                    'Previous',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      color: prevColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onPressed: prevIsDisabled ? null : onPrev,
        ),

        const Spacer(),

        // NEXT
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: nextColor),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      color: nextColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(CupertinoIcons.chevron_right, color: nextColor),
                ],
              ),
            ),
          ),
          onPressed: nextIsDisabled ? null : onNext,
        ),
      ],
    );
  }

  // ============== SHEETS ==============
  // Fees
  void _feesSheet(
    BuildContext context,
    int id, {
    List<int>? order,
    int? index,
  }) {
    int currIndex = index ?? 0;
    int currId = id;

    final data = controller.announcementData.value;
    if (data == null) return;

    AnnouncementItem? _get(int _id) {
      try {
        return data.items.firstWhere((e) => e.id == _id);
      } catch (_) {
        return null;
      }
    }

    AnnouncementItem? item = _get(currId);
    if (item == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void goTo(int nextIndex) {
              if (order == null || order.isEmpty) return;
              currIndex = nextIndex.clamp(0, order.length - 1);
              currId = order[currIndex];
              item = _get(currId);
              setSheetState(() {});
            }

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.55,
              minChildSize: 0.2,
              maxChildSize: 0.95,
              builder: (context, sc) {
                return SingleChildScrollView(
                  controller: sc,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item?.title ?? 'Fees',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.clock_fill,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd-MMM-yyyy').format(item!.notifyDate),
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if ((item?.image ?? '').isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item!.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => SizedBox.shrink(),
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Proceed to Pay'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _navHeader(
                        ctx: context,
                        order: order,
                        index: currIndex,
                        disabled: false,
                        onPrev: () => goTo(currIndex - 1),
                        onNext: () => goTo(currIndex + 1),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Exam Result
  void _examResult(
    BuildContext context,
    int id, {
    List<int>? order,
    int? index,
  }) {
    int currIndex = index ?? 0;
    int currId = id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void goTo(int nextIndex) {
              if (order == null || order.isEmpty) return;
              currIndex = nextIndex.clamp(0, order.length - 1);
              currId = order[currIndex];

              // Optionally fetch new data here if per-id marks differ
              setSheetState(() {});
            }

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.65,
              minChildSize: 0.20,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                // Replace this with your actual data source
                final subjects = [
                  {'subject': 'Math', 'mark': '95'},
                  {'subject': 'Science', 'mark': '90'},
                  {'subject': 'English', 'mark': '92'},
                ];

                return Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    shrinkWrap:
                        true, // ensures height fits content automatically
                    children: [
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColor.borderGary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Exam Title
                      Text(
                        'Third Term Exam Result',
                        textAlign: TextAlign.center,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 7),

                      // Grade
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'A+',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 43,
                            fontWeight: FontWeight.w600,
                            color: AppColor.green,
                          ),
                          children: [
                            TextSpan(
                              text: ' Grade',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 43,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.borderGary,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Subject Marks
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subjects.length,
                        itemBuilder: (context, i) {
                          final subject = subjects[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 38,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  subject['subject']!,
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.gray,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Text(
                                  subject['mark']!,
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.borderGary,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Close Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.blue,
                                width: 1,
                              ),
                            ),
                            child: CustomTextField.textWithSmall(
                              text: 'Close',
                              color: AppColor.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Prev/Next Navigation
                      _navHeader(
                        ctx: context,
                        order: order,
                        index: currIndex,
                        disabled: false,
                        onPrev: () => goTo(currIndex - 1),
                        onNext: () => goTo(currIndex + 1),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Announcement details
  void _showAnnouncementDetails(
    BuildContext context,
    int id, {
    List<int>? order,
    int? index,
  }) async {
    int currIndex = index ?? 0;
    int currId = id;

    AnnouncementDetails? details;

    // Load announcement details
    Future<void> _load(int _id) async {
      if (controller.announcementDetails.value != null &&
          controller.announcementDetails.value!.id == _id) {
        details = controller.announcementDetails.value;
      } else {
        details = await controller.getAnnouncementDetails(id: _id);
      }
    }

    await _load(currId);
    if (details == null) return;

    // Helper to safely build network images
    Widget buildNetworkImage(String? url) {
      if (url == null || url.isEmpty) return SizedBox.shrink();
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SizedBox.shrink(),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> goTo(int nextIndex) async {
              if (order == null || order.isEmpty) return;
              currIndex = nextIndex.clamp(0, order.length - 1);
              currId = order[currIndex];

              // Load details for the new ID
              await _load(currId);

              // Refresh sheet state
              setSheetState(() {});
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // shrink to fit content
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    details?.title ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd-MMM-yyyy').format(
                          DateTime.tryParse(
                                details?.notifyDate.toString() ?? '',
                              ) ??
                              DateTime.now(),
                        ),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main content
                  Text(
                    details?.content ?? '',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),

                  // Sub-contents (paragraphs, lists, images)
                  if (details != null && details!.contents.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          details!.contents.map((c) {
                            if (c.type == "paragraph") {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  c.content ?? "",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              );
                            } else if (c.type == "list") {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    (c.items ?? []).map((e) {
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(child: Text(e)),
                                        ],
                                      );
                                    }).toList(),
                              );
                            } else if (c.type == "image") {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: buildNetworkImage(c.content),
                              );
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                    ),

                  const SizedBox(height: 20),

                  // Prev/Next navigation
                  _navHeader(
                    ctx: context,
                    order: order,
                    index: currIndex,
                    disabled: false,
                    onPrev: () => goTo(currIndex - 1),
                    onNext: () => goTo(currIndex + 1),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Exam timetable
  void showExamTimeTable(
    BuildContext context,
    int examId, {
    List<int>? order,
    int? index,
  }) async {
    int currIndex = index ?? 0;
    int currId = examId;

    Future<void> _load(int id) async {
      if (examController.examDetails.value == null ||
          examController.examDetails.value!.exam.id != id) {
        await examController.getExamDetailsList(examId: id);
      }
    }

    await _load(currId);
    final details = examController.examDetails.value;
    if (details == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> goTo(int nextIndex) async {
              if (order == null || order.isEmpty) return;
              currIndex = nextIndex.clamp(0, order.length - 1);
              currId = order[currIndex];
              await _load(currId);
              setSheetState(() {});
            }

            // Helper to safely show network image
            Widget buildNetworkImage(String? url) {
              if (url == null || url.isEmpty) return SizedBox.shrink();
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => SizedBox.shrink(),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // shrink to fit content
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Exam heading
                  Text(
                    details.exam.heading ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Dates
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${details.exam.startDate} to ${details.exam.endDate}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Timetable image
                  if ((details.exam.timetableUrl ?? '').isNotEmpty)
                    buildNetworkImage(details.exam.timetableUrl),

                  const SizedBox(height: 20),

                  // Prev/Next navigation
                  _navHeader(
                    ctx: context,
                    order: order,
                    index: currIndex,
                    disabled: false,
                    onPrev: () => goTo(currIndex - 1),
                    onNext: () => goTo(currIndex + 1),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Calendar event
  void _showEventDetails(
    BuildContext context,
    int id, {
    List<int>? order,
    int? index,
  }) {
    final data = controller.announcementData.value;
    if (data == null) return;

    int currIndex = index ?? 0;

    AnnouncementItem? _get(int _id) {
      try {
        return data.items.firstWhere((e) => e.id == _id);
      } catch (_) {
        return null;
      }
    }

    AnnouncementItem? item = _get(id);
    if (item == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void goTo(int nextIndex) {
              if (order == null || order.isEmpty) return;
              final nextIdx = nextIndex.clamp(0, order.length - 1);
              final nextId = order[nextIdx];

              Navigator.pop(context); // Close current sheet
              Future.microtask(() {
                _showEventDetails(
                  context,
                  nextId,
                  order: order,
                  index: nextIdx,
                );
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // shrink to fit content
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    _norm(item?.title).toUpperCase(),
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd-MMM-yyyy').format(item!.notifyDate),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if ((item?.image ?? '').isNotEmpty)
                    GestureDetector(
                      onTap: () => _openFullScreenNetwork(item?.image ?? ""),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item?.image ?? "",
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => SizedBox.shrink(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  _navHeader(
                    ctx: context,
                    order: order,
                    index: currIndex,
                    disabled: false,
                    onPrev: () => goTo(currIndex - 1),
                    onNext: () => goTo(currIndex + 1),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============== LIFECYCLE ==============
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCategoryList(showLoader: false);
      if (controller.announcementData.value == null) {
        controller.getAnnouncement(type: "general");
      }
    });
  }

  // ============== UI ==============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final data = controller.announcementData.value;

          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          if (data == null || data.items.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getAnnouncement(
                  // type: selectedIndex == 0 ? "general" : "teacher",
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // critical
                child: Container(
                  padding: const EdgeInsets.only(top: 80, bottom: 300),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'No announcements available',
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
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getAnnouncement(
                type: selectedIndex == 0 ? "general" : "teacher",
              );
            },
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: data.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
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
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AnnouncementCreate(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Create Announcement',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Image.asset(
                                    AppImages.doubleArrow,
                                    height: 19,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),
                        Center(
                          child: Text(
                            selectedIndex == 0
                                ? 'General Announcements'
                                : 'Teacher Announcements',
                            style: GoogleFont.ibmPlexSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 26,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final item = data.items[index - 1];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CommonContainer.announcementsScreen(
                    mainText: item.announcementCategory,
                    backRoundImage: item.image,
                    iconData: CupertinoIcons.clock_fill,
                    additionalText1: "Date",
                    additionalText2: DateFormat(
                      "dd-MMM-yy",
                    ).format(DateTime.parse(item.notifyDate.toString())),
                    verticalPadding: 12,
                    gradientStartColor: AppColor.black.withOpacity(0.01),
                    gradientEndColor: AppColor.black,
                    onDetailsTap: () {
                      // Unified opener (prevents old signature mistakes):
                      _openById(context, item.id);
                    },
                  ),
                );
              },
            ),
          );
        }),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTabButton("General", 0),
            _buildTabButton("Teacher", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        setState(() => selectedIndex = index);
        await controller.getAnnouncement(
          type: selectedIndex == 0 ? "general" : "teacher",
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFont.ibmPlexSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}
