// import 'dart:io';
//
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../Core/Utility/app_color.dart';
// import '../../Core/Utility/app_images.dart';
// import '../../Core/Utility/custom_app_button.dart';
// import '../../Core/Utility/google_fonts.dart';
// import '../../Core/Widgets/common_container.dart';
// import '../Homework/controller/teacher_class_controller.dart';
// import 'announcement_screen.dart';
//
// enum SectionType { image, paragraph, list }
//
// class SectionItem {
//   final SectionType type;
//   XFile? image;
//   String paragraph;
//   List<String> listPoints;
//
//   SectionItem.image(this.image)
//     : type = SectionType.image,
//       paragraph = '',
//       listPoints = [];
//
//   SectionItem.paragraph(this.paragraph)
//     : type = SectionType.paragraph,
//       image = null,
//       listPoints = [];
//
//   SectionItem.list(this.listPoints)
//     : type = SectionType.list,
//       image = null,
//       paragraph = '';
// }
//
// class AnnouncementCreate extends StatefulWidget {
//   const AnnouncementCreate({super.key});
//
//   @override
//   State<AnnouncementCreate> createState() => _AnnouncementCreateState();
// }
//
// class _AnnouncementCreateState extends State<AnnouncementCreate> {
//   List<String> _listTextFields = [];
//   final List<TextEditingController> _listControllers = [];
//   List<TextEditingController> descriptionControllers = [];
//   final _formKey = GlobalKey<FormState>();
//   bool _listSectionOpened = false;
//   bool showParagraphField = false;
//   List<SectionItem> _sections = [];
//   int selectedIndex = 0;
//   int subjectIndex = 0;
//   String? selectedSubject;
//   int? selectedSubjectId;
//   int? selectedClassId;
//   XFile? _permanentImage;
//   final List<XFile?> _pickedImages = [];
//   final ImagePicker _picker = ImagePicker();
//   final TextEditingController Description = TextEditingController();
//   final TextEditingController Category = TextEditingController();
//
//
//
//   Future<void> _pickImage() async {
//     final picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _pickedImages.add(picked);
//       });
//     }
//   }
//
//   Future<void> _pickPermanentImage() async {
//     final picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _permanentImage = picked; // store it in the single field
//       });
//     }
//   }
//
//   final TeacherClassController teacherClassController = Get.put(
//     TeacherClassController(),
//   );
//
//   void _removeImage(int index) {
//     setState(() {
//       _pickedImages.removeAt(index);
//     });
//   }
//
//   void _openListSection() {
//     if (!_listSectionOpened) {
//       setState(() {
//         _listSectionOpened = true;
//         _listTextFields.add('');
//       });
//     }
//   }
//
//   void _addMoreListPoint() {
//     setState(() {
//       _listTextFields.add('');
//     });
//   }
//
//   void _removeListItem(int index) {
//     setState(() {
//       _listTextFields.removeAt(index);
//
//       if (_listTextFields.isEmpty) {
//         _listSectionOpened = false;
//       }
//     });
//   }
//
//   bool showClearIcon = false;
//   TextEditingController headingController = TextEditingController();
//
//   void addDescriptionField() {
//     setState(() {
//       descriptionControllers.add(TextEditingController());
//     });
//   }
//
//   // Remove a description at index
//   void removeDescriptionField(int index) {
//     setState(() {
//       descriptionControllers[index].dispose(); // prevent memory leak
//       descriptionControllers.removeAt(index);
//     });
//   }
//
//   int _getTypeIndex(SectionType type, int globalIndex) {
//     int count = 0;
//     for (int i = 0; i <= globalIndex; i++) {
//       if (_sections[i].type == type) {
//         count++;
//       }
//     }
//     return count;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     teacherClassController.getTeacherClass().then((_) {
//       if (teacherClassController.classList.isNotEmpty) {
//         selectedClassId = teacherClassController.classList[0].id;
//         selectedIndex = 0;
//       }
//       if (teacherClassController.subjectList.isNotEmpty) {
//         selectedSubjectId = teacherClassController.subjectList[0].id;
//         subjectIndex = 0;
//         selectedSubject = teacherClassController.subjectList[0].name;
//       }
//       setState(() {}); // update UI after setting defaults
//     });
//
//     descriptionControllers.add(TextEditingController());
//
//     headingController.addListener(() {
//       setState(() {
//         showClearIcon = headingController.text.isNotEmpty;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     headingController.dispose();
//     super.dispose();
//   }
//
//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
//   }
//
//   bool _validateAtLeastOneDescriptionFilled() {
//     final legacy = descriptionControllers.any((c) => c.text.trim().isNotEmpty);
//     final modular = _sections.any(
//       (s) => s.type == SectionType.paragraph && s.paragraph.trim().isNotEmpty,
//     );
//     return legacy || modular;
//   }
//
//   void _validateAndProceed() {
//     FocusScope.of(context).unfocus();
//
//     // Trigger TextFormFields’ validators
//     if (!_formKey.currentState!.validate()) return;
//
//     // Extra guards for Class/Subject
//     if (selectedClassId == null &&
//         (teacherClassController.selectedClass.value == null &&
//             teacherClassController.classList.isEmpty)) {
//       _showSnack('Please select a class.');
//       return;
//     }
//     if (selectedSubjectId == null &&
//         teacherClassController.subjectList.isEmpty) {
//       _showSnack('Please select a subject.');
//       return;
//     }
//
//     // At least 1 description paragraph overall (keep this if you still want the global rule)
//     if (!_validateAtLeastOneDescriptionFilled()) {
//       _showSnack('Please enter at least one description.');
//       return;
//     }
//
//     // ok → collect & go
//     final selected =
//         (teacherClassController.selectedClass.value ??
//             (teacherClassController.classList.isNotEmpty
//                 ? teacherClassController.classList.first
//                 : null));
//
//     final paragraphs = <String>[
//       // legacy descriptions
//       ...descriptionControllers
//           .map((c) => c.text)
//           .where((t) => t.trim().isNotEmpty),
//       // modular paragraph sections
//       ..._sections
//           .where(
//             (s) =>
//                 s.type == SectionType.paragraph &&
//                 s.paragraph.trim().isNotEmpty,
//           )
//           .map((s) => s.paragraph),
//     ];
//
//     final images =
//         _sections
//             .where((s) => s.type == SectionType.image && s.image != null)
//             .map((s) => File(s.image!.path))
//             .toList();
//
//     final listPoints = [
//       // legacy list block
//       ..._listTextFields.where((t) => t.trim().isNotEmpty),
//       // modular list sections
//       ..._sections
//           .where((s) => s.type == SectionType.list)
//           .expand((s) => s.listPoints)
//           .where((t) => t.trim().isNotEmpty),
//     ];
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (_) => ListGeneral(
//               listPoints: listPoints,
//               subjectId: selectedSubjectId,
//               subjects: selectedSubject ?? '',
//               selectedClassId: selected?.id ?? selectedClassId,
//               description: paragraphs,
//               images: images,
//               permanentImage:
//                   _permanentImage != null ? File(_permanentImage!.path) : null,
//               heading: headingController.text,
//             ),
//       ),
//     );
//   }
//
//   // final List<Map<String, String>> classData = [
//   //   // {'grade': '8', 'section': 'A'},
//   //   // {'grade': '8', 'section': 'B'},
//   //   // {'grade': '8', 'section': 'C'},
//   //   // {'grade': '9', 'section': 'A'},
//   //   // {'grade': '9', 'section': 'C'},
//   // ];
//
//   // final List<Map<String, dynamic>> tabs = [
//   //   {"label": "Social Science"},
//   //   {"label": "English"},
//   // ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.lowLightgray,
//       body: SafeArea(
//         child: Obx(() {
//           final classes = teacherClassController.classList;
//           final subjects = teacherClassController.subjectList;
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
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
//                       Spacer(),
//                       InkWell(
//                         onTap: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (context) => ListGeneral(),
//                           //   ),
//                           // );
//                         },
//                         child: Row(
//                           children: [
//                             Text(
//                               'History',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColor.gray,
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             Image.asset(AppImages.historyImage, height: 24),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 35),
//                   Center(
//                     child: Text(
//                       'Create Announcement',
//                       style: GoogleFont.ibmPlexSans(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 22,
//                         color: AppColor.black,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppColor.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 20,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Class',
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               color: AppColor.black,
//                             ),
//                           ),
//                           SizedBox(height: 30),
//
//                           /* SizedBox(
//                             height: 100,
//                             child: Stack(
//                               clipBehavior: Clip.none,
//                               children: [
//                                 Positioned.fill(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           AppColor.white.withOpacity(0.3),
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.white.withOpacity(0.3),
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.topRight,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 Positioned(
//                                   top: -20,
//                                   bottom: -20,
//                                   left: 0,
//                                   right: 0,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount:
//                                         teacherClassController.classList.length,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 2,
//                                     ),
//                                     itemBuilder: (context, index) {
//                                       final item =
//                                           teacherClassController
//                                               .classList[index];
//                                       final grade = item.name;
//                                       final section = item.section;
//                                       final isSelected = index == selectedIndex;
//
//                                       return GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             selectedIndex = index;
//                                             selectedClassId = item.id;
//                                           });
//                                         },
//                                         child: AnimatedContainer(
//                                           duration: Duration(milliseconds: 40),
//                                           curve: Curves.easeInOut,
//                                           width: 90,
//                                           height: isSelected ? 120 : 80,
//                                           margin: const EdgeInsets.symmetric(
//                                             horizontal: 0,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color:
//                                                 isSelected
//                                                     ? AppColor.white
//                                                     : Colors.transparent,
//                                             borderRadius: BorderRadius.circular(
//                                               24,
//                                             ),
//                                             border:
//                                                 isSelected
//                                                     ? Border.all(
//                                                       color: AppColor.blueG1,
//                                                       width: 1.5,
//                                                     )
//                                                     : null,
//                                             boxShadow:
//                                                 isSelected
//                                                     ? [
//                                                       BoxShadow(
//                                                         color: AppColor.white
//                                                             .withOpacity(0.5),
//                                                         blurRadius: 10,
//                                                         offset: Offset(0, 4),
//                                                       ),
//                                                     ]
//                                                     : [],
//                                           ),
//                                           child:
//                                               isSelected
//                                                   ? Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       SizedBox(height: 8),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           ShaderMask(
//                                                             shaderCallback:
//                                                                 (
//                                                                   bounds,
//                                                                 ) => const LinearGradient(
//                                                                   colors: [
//                                                                     AppColor
//                                                                         .blueG1,
//                                                                     AppColor
//                                                                         .blue,
//                                                                   ],
//                                                                   begin:
//                                                                       Alignment
//                                                                           .topLeft,
//                                                                   end:
//                                                                       Alignment
//                                                                           .bottomRight,
//                                                                 ).createShader(
//                                                                   Rect.fromLTWH(
//                                                                     0,
//                                                                     0,
//                                                                     bounds
//                                                                         .width,
//                                                                     bounds
//                                                                         .height,
//                                                                   ),
//                                                                 ),
//                                                             blendMode:
//                                                                 BlendMode.srcIn,
//                                                             child: Text(
//                                                               '${grade}',
//                                                               style: GoogleFont.ibmPlexSans(
//                                                                 fontSize: 28,
//                                                                 color:
//                                                                     Colors
//                                                                         .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets.only(
//                                                                   top: 8.0,
//                                                                 ),
//                                                             child: ShaderMask(
//                                                               shaderCallback:
//                                                                   (
//                                                                     bounds,
//                                                                   ) => const LinearGradient(
//                                                                     colors: [
//                                                                       AppColor
//                                                                           .blueG1,
//                                                                       AppColor
//                                                                           .blue,
//                                                                     ],
//                                                                     begin:
//                                                                         Alignment
//                                                                             .topLeft,
//                                                                     end:
//                                                                         Alignment
//                                                                             .bottomRight,
//                                                                   ).createShader(
//                                                                     Rect.fromLTWH(
//                                                                       0,
//                                                                       0,
//                                                                       bounds
//                                                                           .width,
//                                                                       bounds
//                                                                           .height,
//                                                                     ),
//                                                                   ),
//                                                               blendMode:
//                                                                   BlendMode
//                                                                       .srcIn,
//                                                               child: Text(
//                                                                 'th',
//                                                                 style: GoogleFont.ibmPlexSans(
//                                                                   fontSize: 14,
//                                                                   color:
//                                                                       Colors
//                                                                           .white,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Container(
//                                                         height: 55,
//                                                         width: double.infinity,
//                                                         decoration: const BoxDecoration(
//                                                           gradient: LinearGradient(
//                                                             colors: [
//                                                               AppColor.blueG1,
//                                                               AppColor.blue,
//                                                             ],
//                                                             begin:
//                                                                 Alignment
//                                                                     .topLeft,
//                                                             end:
//                                                                 Alignment
//                                                                     .topRight,
//                                                           ),
//                                                           borderRadius:
//                                                               BorderRadius.vertical(
//                                                                 bottom:
//                                                                     Radius.circular(
//                                                                       22,
//                                                                     ),
//                                                               ),
//                                                         ),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text(
//                                                           section,
//                                                           style:
//                                                               GoogleFont.ibmPlexSans(
//                                                                 fontSize: 20,
//                                                                 color:
//                                                                     AppColor
//                                                                         .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   )
//                                                   : Center(
//                                                     child: Column(
//                                                       mainAxisSize:
//                                                           MainAxisSize.min,
//                                                       children: [
//                                                         Container(
//                                                           padding:
//                                                               const EdgeInsets.symmetric(
//                                                                 horizontal: 20,
//                                                                 vertical: 3,
//                                                               ),
//                                                           decoration: BoxDecoration(
//                                                             color:
//                                                                 AppColor.white,
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   20,
//                                                                 ),
//                                                           ),
//                                                           child: Text(
//                                                             grade,
//                                                             style:
//                                                                 GoogleFont.ibmPlexSans(
//                                                                   fontSize: 14,
//                                                                   color:
//                                                                       AppColor
//                                                                           .gray,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                 ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         Text(
//                                                           section,
//                                                           style: GoogleFont.ibmPlexSans(
//                                                             fontSize: 20,
//                                                             color:
//                                                                 AppColor
//                                                                     .lightgray,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),*/
//                           SizedBox(
//                             height: 100,
//                             child: Stack(
//                               clipBehavior: Clip.none,
//                               children: [
//                                 Positioned.fill(
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           AppColor.white.withOpacity(0.3),
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.lowLightgray,
//                                           AppColor.white.withOpacity(0.3),
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.topRight,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: -20,
//                                   bottom: -20,
//                                   left: 0,
//                                   right: 0,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: classes.length,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 2,
//                                     ),
//                                     itemBuilder: (context, index) {
//                                       final item = classes[index];
//                                       final isSelected = index == selectedIndex;
//
//                                       return GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             selectedIndex = index;
//                                             selectedClassId = item.id;
//                                             teacherClassController
//                                                 .selectedClass
//                                                 .value = item;
//                                           });
//                                         },
//                                         child: AnimatedContainer(
//                                           duration: const Duration(
//                                             milliseconds: 120,
//                                           ),
//                                           curve: Curves.easeInOut,
//                                           width: 90,
//                                           height: isSelected ? 120 : 80,
//                                           margin: const EdgeInsets.symmetric(
//                                             horizontal: 0,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color:
//                                                 isSelected
//                                                     ? AppColor.white
//                                                     : Colors.transparent,
//                                             borderRadius: BorderRadius.circular(
//                                               24,
//                                             ),
//                                             border:
//                                                 isSelected
//                                                     ? Border.all(
//                                                       color: AppColor.blueG1,
//                                                       width: 1.5,
//                                                     )
//                                                     : null,
//                                             boxShadow:
//                                                 isSelected
//                                                     ? [
//                                                       BoxShadow(
//                                                         color: AppColor.white
//                                                             .withOpacity(0.5),
//                                                         blurRadius: 10,
//                                                         offset: const Offset(
//                                                           0,
//                                                           4,
//                                                         ),
//                                                       ),
//                                                     ]
//                                                     : [],
//                                           ),
//                                           child:
//                                               isSelected
//                                                   ? Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       const SizedBox(height: 8),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           ShaderMask(
//                                                             shaderCallback:
//                                                                 (
//                                                                   bounds,
//                                                                 ) => const LinearGradient(
//                                                                   colors: [
//                                                                     AppColor
//                                                                         .blueG1,
//                                                                     AppColor
//                                                                         .blue,
//                                                                   ],
//                                                                   begin:
//                                                                       Alignment
//                                                                           .topLeft,
//                                                                   end:
//                                                                       Alignment
//                                                                           .bottomRight,
//                                                                 ).createShader(
//                                                                   Rect.fromLTWH(
//                                                                     0,
//                                                                     0,
//                                                                     bounds
//                                                                         .width,
//                                                                     bounds
//                                                                         .height,
//                                                                   ),
//                                                                 ),
//                                                             blendMode:
//                                                                 BlendMode.srcIn,
//                                                             child: Text(
//                                                               item.name,
//                                                               style: GoogleFont.ibmPlexSans(
//                                                                 fontSize: 28,
//                                                                 color:
//                                                                     Colors
//                                                                         .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets.only(
//                                                                   top: 8.0,
//                                                                 ),
//                                                             child: ShaderMask(
//                                                               shaderCallback:
//                                                                   (
//                                                                     bounds,
//                                                                   ) => const LinearGradient(
//                                                                     colors: [
//                                                                       AppColor
//                                                                           .blueG1,
//                                                                       AppColor
//                                                                           .blue,
//                                                                     ],
//                                                                     begin:
//                                                                         Alignment
//                                                                             .topLeft,
//                                                                     end:
//                                                                         Alignment
//                                                                             .bottomRight,
//                                                                   ).createShader(
//                                                                     Rect.fromLTWH(
//                                                                       0,
//                                                                       0,
//                                                                       bounds
//                                                                           .width,
//                                                                       bounds
//                                                                           .height,
//                                                                     ),
//                                                                   ),
//                                                               blendMode:
//                                                                   BlendMode
//                                                                       .srcIn,
//                                                               child: Text(
//                                                                 'th',
//                                                                 style: GoogleFont.ibmPlexSans(
//                                                                   fontSize: 14,
//                                                                   color:
//                                                                       Colors
//                                                                           .white,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Container(
//                                                         height: 55,
//                                                         width: double.infinity,
//                                                         decoration: BoxDecoration(
//                                                           gradient:
//                                                               const LinearGradient(
//                                                                 colors: [
//                                                                   AppColor
//                                                                       .blueG1,
//                                                                   AppColor.blue,
//                                                                 ],
//                                                                 begin:
//                                                                     Alignment
//                                                                         .topLeft,
//                                                                 end:
//                                                                     Alignment
//                                                                         .topRight,
//                                                               ),
//                                                           borderRadius:
//                                                               const BorderRadius.vertical(
//                                                                 bottom:
//                                                                     Radius.circular(
//                                                                       22,
//                                                                     ),
//                                                               ),
//                                                         ),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text(
//                                                           item.section,
//                                                           style:
//                                                               GoogleFont.ibmPlexSans(
//                                                                 fontSize: 20,
//                                                                 color:
//                                                                     AppColor
//                                                                         .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   )
//                                                   : Center(
//                                                     child: Column(
//                                                       mainAxisSize:
//                                                           MainAxisSize.min,
//                                                       children: [
//                                                         Container(
//                                                           padding:
//                                                               const EdgeInsets.symmetric(
//                                                                 horizontal: 20,
//                                                                 vertical: 3,
//                                                               ),
//                                                           decoration: BoxDecoration(
//                                                             color:
//                                                                 AppColor.white,
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   20,
//                                                                 ),
//                                                           ),
//                                                           child: Text(
//                                                             item.name,
//                                                             style:
//                                                                 GoogleFont.ibmPlexSans(
//                                                                   fontSize: 14,
//                                                                   color:
//                                                                       AppColor
//                                                                           .gray,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                 ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         Text(
//                                                           item.section,
//                                                           style: GoogleFont.ibmPlexSans(
//                                                             fontSize: 20,
//                                                             color:
//                                                                 AppColor
//                                                                     .lightgray,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           SizedBox(height: 40),
//                           Text(
//                             'Category',
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               color: AppColor.black,
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           CommonContainer.fillingContainer(
//                             onDetailsTap: () {
//                               Category.clear();
//                               setState(() => showClearIcon = false);
//                             },
//
//                             text: '',
//                             controller: Category,
//                             verticalDivider: false,
//                             imagePath: AppImages.downArrow,
//                             imageSize: 11,
//                             validator: (v) {
//                               if (v == null || v.trim().isEmpty)
//                                 return 'Category is required';
//                               if (v.trim().length < 3)
//                                 return 'Category must be at least 3 characters';
//                               return null;
//                             },
//                             onChanged:
//                                 (v) => setState(
//                                   () => showClearIcon = v.isNotEmpty,
//                             ),
//
//                           ),
//                           SizedBox(height: 25),
//                           Text(
//                             'Heading',
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               color: AppColor.black,
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           CommonContainer.fillingContainer(
//                             onDetailsTap: () {
//                               headingController.clear();
//                               setState(() => showClearIcon = false);
//                             },
//                             imagePath: showClearIcon ? AppImages.close : null,
//                             imageColor: AppColor.gray,
//                             text: '',
//                             controller: headingController,
//                             verticalDivider: false,
//                             validator: (v) {
//                               if (v == null || v.trim().isEmpty)
//                                 return 'Heading is required';
//                               if (v.trim().length < 3)
//                                 return 'Heading must be at least 3 characters';
//                               return null;
//                             },
//                             onChanged:
//                                 (v) => setState(
//                                   () => showClearIcon = v.isNotEmpty,
//                                 ),
//                           ),
//                           SizedBox(height: 25),
//                           Column(
//                             children: List.generate(
//                               descriptionControllers.length,
//                               (index) {
//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'Description',
//                                           style: GoogleFont.ibmPlexSans(
//                                             fontSize: 14,
//                                             color: AppColor.black,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         if (descriptionControllers.length > 1)
//                                           GestureDetector(
//                                             onTap:
//                                                 () => removeDescriptionField(
//                                                   index,
//                                                 ),
//                                             child: Image.asset(
//                                               AppImages.close,
//                                               height: 22,
//                                               color: AppColor.gray,
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     CommonContainer.fillingContainer(
//                                       maxLine: 10,
//                                       text: '',
//                                       controller: descriptionControllers[index],
//                                       verticalDivider: false,
//                                       validator: (v) {
//                                         if (v == null || v.trim().isEmpty)
//                                           return 'Description is required';
//                                         if (v.trim().length < 3)
//                                           return 'Please enter at least 3 characters';
//                                         return null;
//                                       },
//                                     ),
//                                     const SizedBox(height: 16),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//
//                           if (_listSectionOpened) ...[
//                             const SizedBox(height: 20),
//                             Text(
//                               'List',
//                               style: GoogleFont.ibmPlexSans(fontSize: 14),
//                             ),
//                             const SizedBox(height: 12),
//                             ListView.builder(
//                               itemCount: _listTextFields.length,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 14),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 20,
//                                       vertical: 12,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.lightWhite,
//                                       borderRadius: BorderRadius.circular(18),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           'List ${index + 1}',
//                                           style: GoogleFont.ibmPlexSans(
//                                             fontSize: 14,
//                                             color: AppColor.gray,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         Container(
//                                           width: 2,
//                                           height: 30,
//                                           decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 Colors.grey.shade200,
//                                                 Colors.grey.shade300,
//                                                 Colors.grey.shade200,
//                                               ],
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               1,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         Expanded(
//                                           child: TextField(
//                                             controller: _listControllers[index],
//                                             decoration: InputDecoration(
//                                               hintStyle: GoogleFont.ibmPlexSans(
//                                                 fontSize: 14,
//                                                 color: AppColor.gray,
//                                               ),
//                                               border: InputBorder.none,
//                                             ),
//                                             onChanged:
//                                                 (value) =>
//                                                     _listTextFields[index] =
//                                                         value,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 8),
//                                         GestureDetector(
//                                           onTap: () => _removeListItem(index),
//                                           child: Image.asset(
//                                             AppImages.close,
//                                             height: 26,
//                                             color: AppColor.gray,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                             GestureDetector(
//                               onTap: _addMoreListPoint,
//                               child: DottedBorder(
//                                 color: AppColor.blue,
//                                 strokeWidth: 1.5,
//                                 dashPattern: const [8, 4],
//                                 borderType: BorderType.RRect,
//                                 radius: const Radius.circular(20),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 14,
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     'Add List ${_listTextFields.length + 1} Point',
//                                     style: GoogleFont.ibmPlexSans(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14,
//                                       color: AppColor.blue,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                           ListView.builder(
//                             itemCount: _sections.length,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               final item = _sections[index];
//                               switch (item.type) {
//                                 case SectionType.image:
//                                   return _buildImageContainer(item, index);
//                                 case SectionType.paragraph:
//                                   return _buildParagraphContainer(item, index);
//                                 case SectionType.list:
//                                   return _buildListContainer(item, index);
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 25),
//
//                           // Add buttons
//                           Row(
//                             children: [
//                               Text(
//                                 'Add',
//                                 style: GoogleFont.ibmPlexSans(
//                                   fontSize: 14,
//                                   color: AppColor.black,
//                                 ),
//                               ),
//                               const SizedBox(width: 25),
//                               CommonContainer.addMore(
//                                 onTap:
//                                     () => setState(
//                                       () => _sections.add(
//                                         SectionItem.image(null),
//                                       ),
//                                     ),
//                                 mainText: 'Image',
//                                 imagePath: AppImages.picherImageDark,
//                               ),
//                               const SizedBox(width: 10),
//                               CommonContainer.addMore(
//                                 onTap:
//                                     () => setState(
//                                       () => _sections.add(
//                                         SectionItem.paragraph(''),
//                                       ),
//                                     ),
//                                 mainText: 'Paragraph',
//                                 imagePath: AppImages.paragraph,
//                               ),
//                               const SizedBox(width: 10),
//                               CommonContainer.addMore(
//                                 onTap:
//                                     () => setState(
//                                       () =>
//                                           _sections.add(SectionItem.list([''])),
//                                     ),
//                                 mainText: 'List',
//                                 imagePath: AppImages.list,
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 40),
//
//                           // Preview (validates)
//                           AppButton.button(
//                             onTap: _validateAndProceed,
//                             width: 145,
//                             height: 60,
//                             text: 'Preview',
//                             image: AppImages.buttonArrow,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildParagraphContainer(SectionItem item, int index) {
//     final paragraphNumber = _getTypeIndex(SectionType.paragraph, index);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // title + remove
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Description $paragraphNumber',
//                 style: GoogleFont.ibmPlexSans(
//                   fontSize: 14,
//                   color: AppColor.black,
//                 ),
//               ),
//               InkWell(
//                 onTap: () => setState(() => _sections.removeAt(index)),
//                 child: Image.asset(
//                   AppImages.close,
//                   height: 26,
//                   color: AppColor.gray,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           CommonContainer.fillingContainer(
//             maxLine: 5,
//             text: item.paragraph,
//             controller: null,
//             verticalDivider: false,
//             onChanged: (val) => setState(() => item.paragraph = val),
//             // ✅ Same validator rules as Heading
//             validator: (v) {
//               if (v == null || v.trim().isEmpty)
//                 return 'Description is required';
//               if (v.trim().length < 3)
//                 return 'Please enter at least 3 characters';
//               return null;
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildListContainer(SectionItem item, int index) {
//     final listNumber = _getTypeIndex(SectionType.list, index);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 18.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // title + remove
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'List $listNumber',
//                 style: GoogleFont.ibmPlexSans(
//                   fontSize: 14,
//                   color: AppColor.black,
//                 ),
//               ),
//               InkWell(
//                 onTap: () => setState(() => _sections.removeAt(index)),
//                 child: Image.asset(
//                   AppImages.close,
//                   height: 26,
//                   color: AppColor.gray,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // dynamic points
//           ListView.builder(
//             itemCount: item.listPoints.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, listIndex) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 14),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColor.lightWhite,
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         'List ${listIndex + 1}',
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 14,
//                           color: AppColor.gray,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         width: 2,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.grey.shade200,
//                               Colors.grey.shade300,
//                               Colors.grey.shade200,
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(1),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           controller: TextEditingController(
//                             text: item.listPoints[listIndex],
//                           ),
//                           decoration: InputDecoration(
//                             hintStyle: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               color: AppColor.gray,
//                             ),
//                             border: InputBorder.none,
//                           ),
//                           onChanged:
//                               (value) => item.listPoints[listIndex] = value,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       GestureDetector(
//                         onTap:
//                             () => setState(
//                               () => item.listPoints.removeAt(listIndex),
//                             ),
//                         child: Image.asset(
//                           AppImages.close,
//                           height: 26,
//                           color: AppColor.gray,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           GestureDetector(
//             onTap: () => setState(() => item.listPoints.add('')),
//             child: DottedBorder(
//               color: AppColor.blue,
//               strokeWidth: 1.5,
//               dashPattern: const [8, 4],
//               borderType: BorderType.RRect,
//               radius: const Radius.circular(20),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Add List ${item.listPoints.length + 1} Point',
//                   style: GoogleFont.ibmPlexSans(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                     color: AppColor.blue,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImageContainer(SectionItem item, int index) {
//     final imageNumber = _getTypeIndex(SectionType.image, index);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // title + remove
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Image-$imageNumber',
//                 style: GoogleFont.ibmPlexSans(
//                   fontSize: 14,
//                   color: AppColor.black,
//                 ),
//               ),
//               InkWell(
//                 onTap: () => setState(() => _sections.removeAt(index)),
//                 child: Image.asset(
//                   AppImages.close,
//                   height: 26,
//                   color: AppColor.gray,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//
//           // upload
//           GestureDetector(
//             onTap: () async {
//               final picked = await _picker.pickImage(
//                 source: ImageSource.gallery,
//               );
//               if (picked != null) {
//                 setState(() => item.image = picked);
//               }
//             },
//             child: DottedBorder(
//               borderType: BorderType.RRect,
//               radius: const Radius.circular(20),
//               color: AppColor.lightgray,
//               strokeWidth: 1.5,
//               dashPattern: const [8, 4],
//               padding: const EdgeInsets.all(1),
//               child: Container(
//                 height: 120,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: AppColor.lightWhite,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     if (item.image == null)
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(AppImages.uploadImage, height: 30),
//                             const SizedBox(width: 10),
//                             Text(
//                               'Upload',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColor.lightgray,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     else ...[
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           File(item.image!.path),
//                           width: 200,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const Spacer(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 35.0),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 10.0),
//                               child: InkWell(
//                                 onTap: () => setState(() => item.image = null),
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                       AppImages.close,
//                                       height: 26,
//                                       color: AppColor.gray,
//                                     ),
//                                     Text(
//                                       'Clear',
//                                       style: GoogleFont.ibmPlexSans(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w400,
//                                         color: AppColor.lightgray,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getSuffix(int number) {
//     if (number == 1) return "st";
//     if (number == 2) return "nd";
//     if (number == 3) return "rd";
//     return "th";
//   }
// }

import 'package:path/path.dart' as path;

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Homework/controller/teacher_class_controller.dart';
import 'Model/category_list_response.dart';
import 'controller/announcement_contorller.dart';
import 'announcement_screen.dart';

enum SectionType { image, paragraph, list }

class SectionItem {
  final SectionType type;
  XFile? image;
  String paragraph;
  List<String> listPoints;

  SectionItem.image(this.image)
    : type = SectionType.image,
      paragraph = '',
      listPoints = [];

  SectionItem.paragraph(this.paragraph)
    : type = SectionType.paragraph,
      image = null,
      listPoints = [];

  SectionItem.list(this.listPoints)
    : type = SectionType.list,
      image = null,
      paragraph = '';
}

class AnnouncementCreate extends StatefulWidget {
  final String? className;
  final String? section;
  const AnnouncementCreate({super.key, this.className, this.section});

  @override
  State<AnnouncementCreate> createState() => _AnnouncementCreateState();
}

class _AnnouncementCreateState extends State<AnnouncementCreate> {
  // ---------- form + controllers ----------
  final _formKey = GlobalKey<FormState>();
  final AnnouncementContorller announcementController = Get.put(
    AnnouncementContorller(),
  );

  final TextEditingController headingController = TextEditingController();
  final TextEditingController Category = TextEditingController();
  final TextEditingController Description = TextEditingController();

  bool showHeadingClear = false;

  // ---------- legacy list section ----------
  final List<String> _listTextFields = [];
  final List<TextEditingController> _listControllers = [];
  bool _listSectionOpened = false;

  // ---------- legacy descriptions ----------
  final List<TextEditingController> descriptionControllers = [];

  // ---------- modular sections ----------
  final List<SectionItem> _sections = [];

  // ---------- selection state ----------
  int selectedIndex = 0;
  int subjectIndex = 0;
  int selectedCategoryId = 0;
  String? selectedSubject;
  int? selectedSubjectId;
  int? selectedClassId;

  // ---------- images ----------
  XFile? _permanentImage;
  final List<XFile?> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  // ---------- deps ----------
  final AnnouncementContorller announcementContorller = Get.put(
    AnnouncementContorller(),
  );

  final TeacherClassController teacherClassController = Get.put(
    TeacherClassController(),
  );
  bool showCategoryClear = false;

  Future<void> _openCategorySheet() async {
    final selected = await showModalBottomSheet<CategoryData>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Category",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Category list
                  Expanded(
                    child: Obx(() {
                      final categories = announcementController.categoryData;
                      if (categories.isEmpty) {
                        return const Center(child: Text("No categories found"));
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        itemCount: categories.length,
                        separatorBuilder:
                            (_, __) => const Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                        itemBuilder: (context, i) {
                          final category = categories[i];
                          final isSelected =
                              category.name == Category.text.trim();

                          return ListTile(
                            title: Text(
                              category.name.replaceAll('_', ' ').toUpperCase(),
                              style: TextStyle(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isSelected ? Colors.blue : Colors.black87,
                              ),
                            ),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                    )
                                    : null,
                            onTap: () => Navigator.of(context).pop(category),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        Category.text = selected.name.replaceAll('_', ' ').toUpperCase();
        selectedCategoryId = selected.id;
        showCategoryClear = true;
      });
    }
  }

  // GetX controller for API

  // Category UI helpers

  // ---------- helpers ----------
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImages.add(picked);
      });
    }
  }

  Future<void> _pickPermanentImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _permanentImage = picked;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  void _openListSection() {
    if (!_listSectionOpened) {
      setState(() {
        _listSectionOpened = true;
        _listTextFields.add('');
        _listControllers.add(TextEditingController());
      });
    }
  }

  void _addMoreListPoint() {
    setState(() {
      _listTextFields.add('');
      _listControllers.add(TextEditingController());
    });
  }

  void _removeListItem(int index) {
    setState(() {
      _listTextFields.removeAt(index);
      _listControllers.removeAt(index).dispose();
      if (_listTextFields.isEmpty) _listSectionOpened = false;
    });
  }

  void addDescriptionField() {
    setState(() {
      descriptionControllers.add(TextEditingController());
    });
  }

  void removeDescriptionField(int index) {
    setState(() {
      descriptionControllers[index].dispose();
      descriptionControllers.removeAt(index);
    });
  }

  int _getTypeIndex(SectionType type, int globalIndex) {
    int count = 0;
    for (int i = 0; i <= globalIndex; i++) {
      if (_sections[i].type == type) count++;
    }
    return count;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  bool _validateAtLeastOneDescriptionFilled() {
    final legacy = descriptionControllers.any((c) => c.text.trim().isNotEmpty);
    final modular = _sections.any(
      (s) => s.type == SectionType.paragraph && s.paragraph.trim().isNotEmpty,
    );
    return legacy || modular;
  }

  Future<void> _validateAndProceed() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final selected =
        (announcementContorller.classList.isNotEmpty
            ? announcementContorller.classList.first
            : null);

    // Collect text pieces
    final paragraphs = <String>[
      ...descriptionControllers
          .map((c) => c.text)
          .where((t) => t.trim().isNotEmpty),
      ..._sections
          .where(
            (s) =>
                s.type == SectionType.paragraph &&
                s.paragraph.trim().isNotEmpty,
          )
          .map((s) => s.paragraph),
    ];

    final listPoints = <String>[
      ..._listTextFields.where((t) => t.trim().isNotEmpty),
      ..._sections
          .where((s) => s.type == SectionType.list)
          .expand((s) => s.listPoints)
          .where((t) => t.trim().isNotEmpty),
    ];

    final sectionImages =
        _sections
            .where((s) => s.type == SectionType.image && s.image != null)
            .map((s) => File(s.image!.path))
            .toList();

    // Main description (maps to "content" in your JSON)
    final String mainDescription =
        paragraphs.isNotEmpty ? paragraphs.first.trim() : '';

    // Build "contents" array in desired shape
    final List<Map<String, dynamic>> contents = [];

    // Add extra paragraphs (skip the first, which is the mainDescription)
    for (var i = 1; i < paragraphs.length; i++) {
      final p = paragraphs[i].trim();
      if (p.isNotEmpty) {
        contents.add({"type": "paragraph", "content": p});
      }
    }

    // Add a single list block with items
    if (listPoints.isNotEmpty) {
      contents.add({"type": "list", "items": List<String>.from(listPoints)});
    }

    // Add image content entries (content = filename; backend will replace with URL after upload)

    // Files to upload (permanent header + section images)
    final imageFiles = <File>[
      if (_permanentImage != null) File(_permanentImage!.path),
      ...sectionImages,
    ];

    // Category keys
    // announcementCategory like "exam_result" (key from your picker)

    // Optional notify date; include only if you actually set it
    // final String? notifyDate = _notifyDate?.toIso8601String().split('.').first;

    await announcementContorller.createAnnouncement(
      context: context,
      showLoader: true,
      classId: selected?.id ?? selectedClassId,

      // Maps to your JSON:
      // "title": ...
      heading: headingController.text.trim(),

      // "content": ...
      description: mainDescription,

      // Extra fields to match your JSON contract
      category: 'Student', // "category": "Student"
      announcementCategoryId: selectedCategoryId,

      publish: true,
      contents: contents,
      imageFiles: imageFiles,
      // notifyDate: notifyDate, // uncomment if supported
    );
  }

  /* Future<void> _validateAndProceed() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // if (selectedClassId == null &&
    //     (teacherClassController.selectedClass.value == null &&
    //         announcementContorller.classList.isEmpty)) {
    //   _showSnack('Please select a class.');
    //   return;
    // }
    // if (selectedSubjectId == null &&
    //     announcementContorller.subjectList.isEmpty) {
    //   _showSnack('Please select a subject.');
    //   return;
    // }
    // if (!_validateAtLeastOneDescriptionFilled()) {
    //   _showSnack('Please enter at least one description.');
    //   return;
    // }

    final selected =
        (announcementContorller.classList.isNotEmpty
            ? announcementContorller.classList.first
            : null);

    final paragraphs = <String>[
      ...descriptionControllers
          .map((c) => c.text)
          .where((t) => t.trim().isNotEmpty),
      ..._sections
          .where(
            (s) =>
                s.type == SectionType.paragraph &&
                s.paragraph.trim().isNotEmpty,
          )
          .map((s) => s.paragraph),
    ];

    final imageFiles = <File>[
      if (_permanentImage != null) File(_permanentImage!.path),
      ...sectionImages,
    ];

    final listPoints = [
      ..._listTextFields.where((t) => t.trim().isNotEmpty),
      ..._sections
          .where((s) => s.type == SectionType.list)
          .expand((s) => s.listPoints)
          .where((t) => t.trim().isNotEmpty),
    ];
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder:
    //         (_) => ListGeneral(
    //           listPoints: listPoints,
    //
    //           subjects: Category.text.trim(),
    //           selectedClassId: selected?.id ?? selectedClassId,
    //           description: paragraphs,
    //           images: images,
    //           permanentImage:
    //               _permanentImage != null ? File(_permanentImage!.path) : null,
    //           heading: headingController.text,
    //         ),
    //   ),
    // );

    List<Map<String, dynamic>> contents = [];

    // Add list items
    for (var listItem in listPoints) {
      contents.add({"type": "list", "content": listItem});
    }

    // Add paragraph contents
    if (paragraphs.length > 1) {
      for (var i = 1; i < paragraphs.length; i++) {
        var para = paragraphs[i];
        if (para.trim().isNotEmpty) {
          contents.add({"type": "paragraph", "content": para});
        }
      }
    }
    String mainDescription = paragraphs.isNotEmpty ? paragraphs[0] : '';
    await announcementContorller.createAnnouncement(
      context: context,
      showLoader: true,
      classId: selected?.id ?? selectedClassId,

      heading: headingController.text,
      description: mainDescription,
      publish: true,
      contents: contents,
      imageFiles: imageFiles,
    );
  }*/

  // ---------- lifecycle ----------
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await announcementController.getCategoryList();
      if (teacherClassController.classList.isNotEmpty) {
        final defaultClass = teacherClassController.classList.firstWhere(
          (c) =>
              c.name == (widget.className ?? c.name) &&
              c.section == (widget.section ?? c.section),
          orElse: () => teacherClassController.classList.first,
        );
        teacherClassController.selectedClass.value = defaultClass;
        selectedIndex = teacherClassController.classList.indexOf(defaultClass);
        selectedClassId = defaultClass.id;
      }

      if (teacherClassController.subjectList.isNotEmpty) {
        subjectIndex = 0;
        selectedSubject = teacherClassController.subjectList[0].name;
        selectedSubjectId = teacherClassController.subjectList[0].id;
      }

      setState(() {});
    });
    descriptionControllers.add(TextEditingController());

    headingController.addListener(() {
      setState(() => showHeadingClear = headingController.text.isNotEmpty);
    });
    Category.addListener(() {
      setState(() => showCategoryClear = Category.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    headingController.dispose();
    Category.dispose();
    Description.dispose();

    for (final c in descriptionControllers) {
      c.dispose();
    }
    for (final c in _listControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          final classes = teacherClassController.classList;
          final subjects = teacherClassController.subjectList;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
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
                                builder: (context) => AnnouncementScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'History',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.gray,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(AppImages.historyImage, height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Center(
                      child: Text(
                        'Create Announcement',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Class picker strip
                            Text(
                              'Class',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.black,
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              height: 100,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColor.white.withOpacity(0.3),
                                            AppColor.lowLightgray,
                                            AppColor.lowLightgray,
                                            AppColor.lowLightgray,
                                            AppColor.lowLightgray,
                                            AppColor.lowLightgray,
                                            AppColor.white.withOpacity(0.3),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.topRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -20,
                                    bottom: -20,
                                    left: 0,
                                    right: 0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: classes.length,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = classes[index];
                                        final isSelected =
                                            index == selectedIndex;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              selectedClassId = item.id;
                                              teacherClassController
                                                  .selectedClass
                                                  .value = item;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 120,
                                            ),
                                            curve: Curves.easeInOut,
                                            width: 90,
                                            height: isSelected ? 120 : 80,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 0,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? AppColor.white
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border:
                                                  isSelected
                                                      ? Border.all(
                                                        color: AppColor.blueG1,
                                                        width: 1.5,
                                                      )
                                                      : null,
                                              boxShadow:
                                                  isSelected
                                                      ? [
                                                        BoxShadow(
                                                          color: AppColor.white
                                                              .withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: const Offset(
                                                            0,
                                                            4,
                                                          ),
                                                        ),
                                                      ]
                                                      : [],
                                            ),
                                            child:
                                                isSelected
                                                    ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ShaderMask(
                                                              shaderCallback:
                                                                  (
                                                                    bounds,
                                                                  ) => const LinearGradient(
                                                                    colors: [
                                                                      AppColor
                                                                          .blueG1,
                                                                      AppColor
                                                                          .blue,
                                                                    ],
                                                                    begin:
                                                                        Alignment
                                                                            .topLeft,
                                                                    end:
                                                                        Alignment
                                                                            .bottomRight,
                                                                  ).createShader(
                                                                    Rect.fromLTWH(
                                                                      0,
                                                                      0,
                                                                      bounds
                                                                          .width,
                                                                      bounds
                                                                          .height,
                                                                    ),
                                                                  ),
                                                              blendMode:
                                                                  BlendMode
                                                                      .srcIn,
                                                              child: Text(
                                                                item.name,
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontSize: 28,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    top: 8.0,
                                                                  ),
                                                              child: ShaderMask(
                                                                shaderCallback:
                                                                    (
                                                                      bounds,
                                                                    ) => const LinearGradient(
                                                                      colors: [
                                                                        AppColor
                                                                            .blueG1,
                                                                        AppColor
                                                                            .blue,
                                                                      ],
                                                                      begin:
                                                                          Alignment
                                                                              .topLeft,
                                                                      end:
                                                                          Alignment
                                                                              .bottomRight,
                                                                    ).createShader(
                                                                      Rect.fromLTWH(
                                                                        0,
                                                                        0,
                                                                        bounds
                                                                            .width,
                                                                        bounds
                                                                            .height,
                                                                      ),
                                                                    ),
                                                                blendMode:
                                                                    BlendMode
                                                                        .srcIn,
                                                                child: Text(
                                                                  'th',
                                                                  style: GoogleFont.ibmPlexSans(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 55,
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                            gradient: const LinearGradient(
                                                              colors: [
                                                                AppColor.blueG1,
                                                                AppColor.blue,
                                                              ],
                                                              begin:
                                                                  Alignment
                                                                      .topLeft,
                                                              end:
                                                                  Alignment
                                                                      .topRight,
                                                            ),
                                                            borderRadius:
                                                                const BorderRadius.vertical(
                                                                  bottom:
                                                                      Radius.circular(
                                                                        22,
                                                                      ),
                                                                ),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            item.section,
                                                            style:
                                                                GoogleFont.ibmPlexSans(
                                                                  fontSize: 20,
                                                                  color:
                                                                      AppColor
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                    : Center(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 3,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color:
                                                                      AppColor
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                ),
                                                            child: Text(
                                                              item.name,
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 14,
                                                                color:
                                                                    AppColor
                                                                        .gray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            item.section,
                                                            style: GoogleFont.ibmPlexSans(
                                                              fontSize: 20,
                                                              color:
                                                                  AppColor
                                                                      .lightgray,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Category
                            Text(
                              'Category',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _openCategorySheet, // open bottom sheet
                              child: AbsorbPointer(
                                child: CommonContainer.fillingContainer(
                                  onDetailsTap: () {
                                    Category.clear();
                                    setState(() => showCategoryClear = false);
                                  },
                                  imagePath:
                                      showCategoryClear
                                          ? AppImages.close
                                          : AppImages.downArrow,
                                  imageColor: AppColor.gray,
                                  text:
                                      Category.text
                                          .toUpperCase(), // <-- display uppercase
                                  controller: Category,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Category is required';
                                    }
                                    return null;
                                  },
                                  imageSize: 11,
                                ),
                              ),
                            ),

                            // GestureDetector(
                            //   onTap: _openCategorySheet, // open bottom sheet
                            //   child: AbsorbPointer(
                            //     // prevent keyboard
                            //     child: CommonContainer.fillingContainer(
                            //       onDetailsTap: () {
                            //         Category.clear();
                            //         setState(() => showCategoryClear = false);
                            //       },
                            //       imagePath:
                            //           showCategoryClear
                            //               ? AppImages.close
                            //               : AppImages.downArrow,
                            //       imageColor: AppColor.gray,
                            //       text: '',
                            //       controller: Category,
                            //       verticalDivider: false,
                            //       imageSize: 11,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 25),

                            // Heading
                            Text(
                              'Heading',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CommonContainer.fillingContainer(
                              onDetailsTap: () {
                                headingController.clear();
                                setState(() => showHeadingClear = false);
                              },
                              imagePath:
                                  showHeadingClear ? AppImages.close : null,
                              imageColor: AppColor.gray,
                              text: '',
                              controller: headingController,
                              verticalDivider: false,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Heading is required';
                                }
                                if (v.trim().length < 3) {
                                  return 'Heading must be at least 3 characters';
                                }
                                return null;
                              },
                              onChanged:
                                  (v) => setState(
                                    () => showHeadingClear = v.isNotEmpty,
                                  ),
                            ),

                            const SizedBox(height: 25),

                            // Legacy descriptions
                            Column(
                              children: List.generate(
                                descriptionControllers.length,
                                (index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Description',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 14,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (descriptionControllers.length > 1)
                                            GestureDetector(
                                              onTap:
                                                  () => removeDescriptionField(
                                                    index,
                                                  ),
                                              child: Image.asset(
                                                AppImages.close,
                                                height: 22,
                                                color: AppColor.gray,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      CommonContainer.fillingContainer(
                                        maxLine: 10,
                                        text: '',
                                        controller:
                                            descriptionControllers[index],
                                        verticalDivider: false,
                                        validator: (v) {
                                          // Only require the first description; others optional
                                          if (index == 0) {
                                            if (v == null || v.trim().isEmpty) {
                                              return 'Description is required';
                                            }
                                            if (v.trim().length < 3) {
                                              return 'Please enter at least 3 characters';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            // Trigger to add another legacy description
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child: TextButton.icon(
                            //     onPressed: addDescriptionField,
                            //     icon: const Icon(Icons.add),
                            //     label: const Text('Add another description'),
                            //   ),
                            // ),
                            //
                            // // Legacy list section (collapsed by default)
                            // if (!_listSectionOpened)
                            //   Align(
                            //     alignment: Alignment.centerLeft,
                            //     child: TextButton.icon(
                            //       onPressed: _openListSection,
                            //       icon: const Icon(Icons.list),
                            //       label: const Text('Add List Section'),
                            //     ),
                            //   ),
                            //
                            // if (_listSectionOpened) ...[
                            //   const SizedBox(height: 20),
                            //   Text(
                            //     'List',
                            //     style:
                            //     GoogleFont.ibmPlexSans(fontSize: 14),
                            //   ),
                            //   const SizedBox(height: 12),
                            //   ListView.builder(
                            //     itemCount: _listTextFields.length,
                            //     shrinkWrap: true,
                            //     physics:
                            //     const NeverScrollableScrollPhysics(),
                            //     itemBuilder: (context, index) {
                            //       // Safety sync (in case of hot reload or state mismatch)
                            //       if (_listControllers.length <= index) {
                            //         _listControllers.add(
                            //           TextEditingController(
                            //             text: _listTextFields[index],
                            //           ),
                            //         );
                            //       }
                            //
                            //       return Padding(
                            //         padding:
                            //         const EdgeInsets.only(bottom: 14),
                            //         child: Container(
                            //           padding:
                            //           const EdgeInsets.symmetric(
                            //             horizontal: 20,
                            //             vertical: 12,
                            //           ),
                            //           decoration: BoxDecoration(
                            //             color: AppColor.lightWhite,
                            //             borderRadius:
                            //             BorderRadius.circular(18),
                            //           ),
                            //           child: Row(
                            //             children: [
                            //               Text(
                            //                 'List ${index + 1}',
                            //                 style:
                            //                 GoogleFont.ibmPlexSans(
                            //                   fontSize: 14,
                            //                   color: AppColor.gray,
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 10),
                            //               Container(
                            //                 width: 2,
                            //                 height: 30,
                            //                 decoration: BoxDecoration(
                            //                   gradient: LinearGradient(
                            //                     begin: Alignment.topCenter,
                            //                     end:
                            //                     Alignment.bottomCenter,
                            //                     colors: [
                            //                       Colors.grey.shade200,
                            //                       Colors.grey.shade300,
                            //                       Colors.grey.shade200,
                            //                     ],
                            //                   ),
                            //                   borderRadius:
                            //                   BorderRadius.circular(1),
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 10),
                            //               Expanded(
                            //                 child: TextField(
                            //                   controller:
                            //                   _listControllers[index],
                            //                   decoration: InputDecoration(
                            //                     hintStyle: GoogleFont
                            //                         .ibmPlexSans(
                            //                       fontSize: 14,
                            //                       color: AppColor.gray,
                            //                     ),
                            //                     border: InputBorder.none,
                            //                   ),
                            //                   onChanged: (value) =>
                            //                   _listTextFields[index] =
                            //                       value,
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 8),
                            //               GestureDetector(
                            //                 onTap: () =>
                            //                     _removeListItem(index),
                            //                 child: Image.asset(
                            //                   AppImages.close,
                            //                   height: 26,
                            //                   color: AppColor.gray,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            //   GestureDetector(
                            //     onTap: _addMoreListPoint,
                            //     child: DottedBorder(
                            //       color: AppColor.blue,
                            //       strokeWidth: 1.5,
                            //       dashPattern: const [8, 4],
                            //       borderType: BorderType.RRect,
                            //       radius: const Radius.circular(20),
                            //       child: Container(
                            //         padding: const EdgeInsets.symmetric(
                            //           vertical: 14,
                            //         ),
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           'Add List ${_listTextFields.length + 1} Point',
                            //           style: GoogleFont.ibmPlexSans(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 14,
                            //             color: AppColor.blue,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ],
                            const SizedBox(height: 20),

                            // Modular sections renderer
                            ListView.builder(
                              itemCount: _sections.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = _sections[index];
                                switch (item.type) {
                                  case SectionType.image:
                                    return _buildImageContainer(item, index);
                                  case SectionType.paragraph:
                                    return _buildParagraphContainer(
                                      item,
                                      index,
                                    );
                                  case SectionType.list:
                                    return _buildListContainer(item, index);
                                }
                              },
                            ),

                            const SizedBox(height: 25),

                            // Add buttons row (modular)
                            Row(
                              children: [
                                Text(
                                  'Add',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    color: AppColor.black,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                CommonContainer.addMore(
                                  onTap:
                                      () => setState(
                                        () => _sections.add(
                                          SectionItem.image(null),
                                        ),
                                      ),
                                  mainText: 'Image',
                                  imagePath: AppImages.picherImageDark,
                                ),
                                const SizedBox(width: 10),
                                CommonContainer.addMore(
                                  onTap:
                                      () => setState(
                                        () => _sections.add(
                                          SectionItem.paragraph(''),
                                        ),
                                      ),
                                  mainText: 'Paragraph',
                                  imagePath: AppImages.paragraph,
                                ),
                                const SizedBox(width: 10),
                                CommonContainer.addMore(
                                  onTap:
                                      () => setState(
                                        () => _sections.add(
                                          SectionItem.list(['']),
                                        ),
                                      ),
                                  mainText: 'List',
                                  imagePath: AppImages.list,
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),

                            AppButton.button(
                              onTap: _validateAndProceed,
                              width: 145,
                              height: 60,
                              text: 'Preview',
                              image: AppImages.buttonArrow,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- section builders (modular) ----------
  Widget _buildParagraphContainer(SectionItem item, int index) {
    final paragraphNumber = _getTypeIndex(SectionType.paragraph, index);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title + remove
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Description $paragraphNumber',
                style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.black),
              ),
              InkWell(
                onTap: () => setState(() => _sections.removeAt(index)),
                child: Image.asset(AppImages.close, height: 26, color: AppColor.gray),
              ),
            ],
          ),
          const SizedBox(height: 8),

          FormField<String>(
            initialValue: item.paragraph,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Description is required';
              if (v.trim().length < 3) return 'Please enter at least 3 characters';
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightWhite,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: state.hasError ? Colors.red : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextFormField(
                      initialValue: state.value,
                      maxLines: 5,
                      decoration: const InputDecoration(border: InputBorder.none),
                      onChanged: (val) {
                        state.didChange(val);
                        setState(() => item.paragraph = val);
                      },
                    ),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }



  Widget _buildListContainer(SectionItem item, int index) {
    final listNumber = _getTypeIndex(SectionType.list, index);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title + remove
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'List $listNumber',
                style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.black),
              ),
              InkWell(
                onTap: () => setState(() => _sections.removeAt(index)),
                child: Image.asset(AppImages.close, height: 26, color: AppColor.gray),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // dynamic points with validation
          ListView.builder(
            itemCount: item.listPoints.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, listIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: FormField<String>(
                  key: ValueKey('list-$index-$listIndex'),
                  initialValue: item.listPoints[listIndex],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'List point is required';
                    if (v.trim().length < 3) return 'Enter at least 3 characters';
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColor.lightWhite,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: state.hasError ? Colors.red : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'List ${listIndex + 1}',
                                style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.gray),
                              ),
                              const SizedBox(width: 10),
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
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  // validator handled by outer FormField
                                  initialValue: state.value,
                                  decoration: InputDecoration(
                                    hintText: 'Enter point',
                                    hintStyle: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      color: AppColor.gray,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (val) {
                                    state.didChange(val);
                                    item.listPoints[listIndex] = val;
                                  },
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => setState(() => item.listPoints.removeAt(listIndex)),
                                child: Image.asset(AppImages.close, height: 26, color: AppColor.gray),
                              ),
                            ],
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              );
            },
          ),

          // add new point
          GestureDetector(
            onTap: () => setState(() => item.listPoints.add('')),
            child: DottedBorder(
              color: AppColor.blue,
              strokeWidth: 1.5,
              dashPattern: const [8, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Text(
                  'Add List ${item.listPoints.length + 1} Point',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColor.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildImageContainer(SectionItem item, int index) {
    final imageNumber = _getTypeIndex(SectionType.image, index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title + remove
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Image-$imageNumber',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 14,
                  color: AppColor.black,
                ),
              ),
              InkWell(
                onTap: () => setState(() => _sections.removeAt(index)),
                child: Image.asset(
                  AppImages.close,
                  height: 26,
                  color: AppColor.gray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // upload
          GestureDetector(
            onTap: () async {
              final picked = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                setState(() => item.image = picked);
              }
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              color: AppColor.lightgray,
              strokeWidth: 1.5,
              dashPattern: const [8, 4],
              padding: const EdgeInsets.all(1),
              child: Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColor.lightWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (item.image == null)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImages.uploadImage, height: 30),
                            const SizedBox(width: 10),
                            Text(
                              'Upload',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.lightgray,
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(item.image!.path),
                          width: 200,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () => setState(() => item.image = null),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.close,
                                      height: 26,
                                      color: AppColor.gray,
                                    ),
                                    Text(
                                      'Clear',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.lightgray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // currently unused, but handy
  String _getSuffix(int number) {
    if (number == 1) return "st";
    if (number == 2) return "nd";
    if (number == 3) return "rd";
    return "th";
  }
}
