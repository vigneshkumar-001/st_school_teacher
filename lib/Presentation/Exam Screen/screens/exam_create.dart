import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_teacher_app/Core/Utility/custom_app_button.dart';
import 'package:st_teacher_app/Presentation/Exam%20Screen/controller/exam_controller.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/google_fonts.dart';
import '../../../Core/Widgets/common_container.dart';
import '../../Homework/controller/teacher_class_controller.dart';
import 'exam_history.dart';
import 'package:st_teacher_app/Core/consents.dart';

class ExamCreate extends StatefulWidget {
  final String? className;
  final String? section;
  const ExamCreate({super.key, this.className, this.section});

  @override
  State<ExamCreate> createState() => _ExamCreateState();
}

class _ExamCreateState extends State<ExamCreate> {
  final TeacherClassController teacherClassController = Get.put(
    TeacherClassController(),
  );
  final ExamController controller = Get.put(ExamController());
  int selectedIndex = 0;
  int? selectedClassId;
  bool showClearIcon = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _permanentImage;
  TextEditingController headingController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController singleDateController = TextEditingController();

  Future<void> _pickPermanentImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _permanentImage = picked;
        if (_timetableInvalid) {
          _timetableInvalid = false;
          _timetableError = null;
        }
      });
    }
  }

  /*  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final classes = teacherClassController.classList;
      if (classes.length > 3 && mounted) {
        // we need the actual viewport width of the list; grab it via context later (LayoutBuilder below)
        // For the initial pass, we'll center using the screen width as an approximation.
        final viewportWidth = MediaQuery.of(context).size.width;
        _centerOnSelected(
          index: selectedIndex,
          viewportWidth: viewportWidth,
          itemCount: classes.length,
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
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

      setState(() {});
    });
    headingController.addListener(() {
      if (_headingInvalid && headingController.text.trim().isNotEmpty) {
        setState(() => _headingInvalid = false);
      }
    });
    dateRangeController.addListener(() {
      if (_dateRangeInvalid && dateRangeController.text.trim().isNotEmpty) {
        setState(() {
          _dateRangeInvalid = false;
          _dateRangeError = null;
        });
      }
    });
    singleDateController.addListener(() {
      if (_singleDateInvalid && singleDateController.text.trim().isNotEmpty) {
        setState(() {
          _singleDateInvalid = false;
          _singleDateError = null;
        });
      }
    });
  }*/

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (teacherClassController.classList.isNotEmpty) {
        final defaultClass = teacherClassController.classList.firstWhere(
          (c) => c.name == widget.className && c.section == widget.section,
          orElse: () => teacherClassController.classList.first,
        );

        teacherClassController.selectedClass.value = defaultClass;
        teacherClassController.selectedClassIndex.value = teacherClassController
            .classList
            .indexOf(defaultClass);

        // auto-scroll if needed
        if (teacherClassController.classList.length > 3 && mounted) {
          final viewportWidth = MediaQuery.of(context).size.width;
          _centerOnSelected(
            index: teacherClassController.selectedClassIndex.value,
            viewportWidth: viewportWidth,
            itemCount: teacherClassController.classList.length,
          );
        }
      }
    });

    // input listeners
    headingController.addListener(() {
      if (_headingInvalid && headingController.text.trim().isNotEmpty) {
        setState(() => _headingInvalid = false);
      }
    });

    dateRangeController.addListener(() {
      if (_dateRangeInvalid && dateRangeController.text.trim().isNotEmpty) {
        setState(() {
          _dateRangeInvalid = false;
          _dateRangeError = null;
        });
      }
    });

    singleDateController.addListener(() {
      if (_singleDateInvalid && singleDateController.text.trim().isNotEmpty) {
        setState(() {
          _singleDateInvalid = false;
          _singleDateError = null;
        });
      }
    });
  }

  final ScrollController _classScrollController = ScrollController();

  void _centerOnSelected({
    required int index,
    required double viewportWidth,
    int itemCount = 0,
  }) {
    // tune these if you change card size/spacing
    const double itemWidth = 90; // your card width
    const double spacing = 4; // ~ from padding (2 left + 2 right)
    const double leftPadding = 2; // ListView horizontal padding

    // position of the item's center along the scroll axis
    final double itemCenter =
        leftPadding + (index * (itemWidth + spacing)) + (itemWidth / 2);

    // target offset so that item's center lines up with viewport center
    double target = itemCenter - (viewportWidth / 2);

    // clamp within scroll extents (safe if position not attached yet)
    if (_classScrollController.hasClients) {
      final maxExtent = _classScrollController.position.maxScrollExtent;
      target = target.clamp(0, maxExtent);
      _classScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  // ---- validation flags/messages ----
  bool _headingInvalid = false;
  bool _dateRangeInvalid = false;
  String? _dateRangeError;

  bool _singleDateInvalid = false;
  String? _singleDateError;

  bool _timetableInvalid = false;
  String? _timetableError;

  // ---- optional: parse the "start to end" text safely (case-insensitive 'to') ----
  List<String>? _splitRange(String s) {
    final raw = s.trim();
    if (raw.isEmpty) return null;
    final parts = raw.split(RegExp(r'\s*to\s*', caseSensitive: false));
    if (parts.length != 2) return null;
    final start = parts[0].trim();
    final end = parts[1].trim();
    if (start.isEmpty || end.isEmpty) return null;
    return [start, end];
  }

  void _onSubmit() {
    final heading = headingController.text.trim();
    final rangeText = dateRangeController.text.trim();
    final singleDateText = singleDateController.text.trim();

    // reset
    _headingInvalid = false;
    _dateRangeInvalid = false;
    _dateRangeError = null;
    _singleDateInvalid = false;
    _singleDateError = null;
    _timetableInvalid = false;
    _timetableError = null;

    // validate heading
    if (heading.isEmpty) {
      _headingInvalid = true;
    }

    // validate date range
    String startDate = "";
    String endDate = "";
    final parts = _splitRange(rangeText);
    if (parts == null) {
      _dateRangeInvalid = true;
      _dateRangeError = 'Please select Start & End date';
    } else {
      startDate = parts[0];
      endDate = parts[1];
    }

    // validate single date (announcement date)
    if (singleDateText.isEmpty) {
      _singleDateInvalid = true;
      _singleDateError = 'Please select Announcement date';
    }

    // validate timetable image
    if (_permanentImage == null) {
      _timetableInvalid = true;
      _timetableError = 'Please upload the timetable image';
    }

    setState(() {}); // show errors

    // if any invalid -> stop
    if (_headingInvalid ||
        _dateRangeInvalid ||
        _singleDateInvalid ||
        _timetableInvalid) {
      return;
    }

    // all good -> submit
    controller.createExam(
      classId: teacherClassController.selectedClass.value?.id ?? 1, // ✅ FIXED
      heading: heading,
      startDate: startDate,
      endDate: endDate,
      announcementDate: singleDateText,
      imageFiles: File(_permanentImage!.path),
      context: context,
    );
  }

  Widget _buildClassCard({
    required dynamic item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        width: 90,
        height: isSelected ? 120 : 80,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border:
              isSelected
                  ? Border.all(color: AppColor.blueG1, width: 1.5)
                  : null,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColor.white.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child:
            isSelected
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback:
                              (bounds) => const LinearGradient(
                                colors: [AppColor.blueG1, AppColor.blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(
                                Rect.fromLTWH(
                                  0,
                                  0,
                                  bounds.width,
                                  bounds.height,
                                ),
                              ),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            item.name,
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ShaderMask(
                            shaderCallback:
                                (bounds) => const LinearGradient(
                                  colors: [AppColor.blueG1, AppColor.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            blendMode: BlendMode.srcIn,
                            child: Text(
                              'th',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColor.blueG1, AppColor.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(22),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.section,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 20,
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.name,
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.gray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.section,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 20,
                          color: AppColor.lightgray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildClassStrip(List<dynamic> classes) {
    if (classes.isEmpty) return const SizedBox.shrink();

    return Obx(() {
      final selectedClass = teacherClassController.selectedClass.value;

      // ≤ 3 → centered row
      if (classes.length <= 3) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(classes.length, (index) {
            final item = classes[index];
            final isSelected = selectedClass?.id == item.id;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _buildClassCard(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  teacherClassController.selectedClass.value = item;
                  teacherClassController.selectedClassIndex.value = index;
                },
              ),
            );
          }),
        );
      }

      // > 3 → scrollable
      return LayoutBuilder(
        builder: (context, constraints) {
          final viewportWidth = constraints.maxWidth;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_classScrollController.hasClients && selectedClass != null) {
              final index = classes.indexWhere((c) => c.id == selectedClass.id);
              if (index >= 0) {
                _centerOnSelected(index: index, viewportWidth: viewportWidth);
              }
            }
          });

          return ListView.builder(
            controller: _classScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final item = classes[index];
              final isSelected = selectedClass?.id == item.id;

              return _buildClassCard(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  teacherClassController.selectedClass.value = item;
                  teacherClassController.selectedClassIndex.value = index;
                  _centerOnSelected(index: index, viewportWidth: viewportWidth);
                },
              );
            },
          );
        },
      );
    });
  }

  /// Centered layout for <= 3 classes, scrollable for > 3
  /*  Widget _buildClassStrip(List<dynamic> classes) {
    if (classes.isEmpty) return const SizedBox.shrink();

    // ≤ 3 → centered row
    if (classes.length <= 3) {
      return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(classes.length, (index) {
            final item = classes[index];
            final isSelected = index == selectedIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _buildClassCard(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    selectedClassId = item.id;
                    teacherClassController.selectedClass.value = item;
                  });
                  // no scroll needed for ≤ 3
                },
              ),
            );
          }),
        ),
      );
    }

    // > 3 → horizontal ListView with auto-centering
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;

        // ensure initial centering once attached
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_classScrollController.hasClients) {
            _centerOnSelected(
              index: selectedIndex,
              viewportWidth: viewportWidth,
            );
          }
        });

        return ListView.builder(
          controller: _classScrollController,
          scrollDirection: Axis.horizontal,
          itemCount: classes.length,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          itemBuilder: (context, index) {
            final item = classes[index];
            final isSelected = index == selectedIndex;
            return _buildClassCard(
              item: item,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  selectedClassId = item.id;
                  teacherClassController.selectedClass.value = item;
                });
                _centerOnSelected(index: index, viewportWidth: viewportWidth);
              },
            );
          },
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final classes = teacherClassController.classList;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
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
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamHistory(),
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
                            SizedBox(width: 8),
                            Image.asset(AppImages.historyImage, height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Text(
                    'Create Exam',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 20),

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
                          Text(
                            'Class',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 35),
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child:
                                        classes.length <= 3
                                            ? _buildClassStrip(
                                              classes,
                                            ) // centered row
                                            : _buildClassStrip(
                                              classes,
                                            ), // scrollable list
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 35),
                          Text(
                            'Heading',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    _headingInvalid
                                        ? Colors.red
                                        : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            child: CommonContainer.fillingContainer(
                              onDetailsTap: () {
                                headingController.clear();
                                setState(() {
                                  showClearIcon = false;
                                  _headingInvalid = true; // empty -> invalid
                                });
                              },
                              // If your component supports onChanged, this helps clear red faster:
                              onChanged: (v) {
                                setState(() {
                                  if (_headingInvalid && v.trim().isNotEmpty) {
                                    _headingInvalid = false;
                                  }
                                  showClearIcon = v.isNotEmpty;
                                });
                              },
                              imagePath: showClearIcon ? AppImages.close : null,
                              imageColor: AppColor.gray,
                              text: '',
                              controller: headingController,
                              verticalDivider: false,
                            ),
                          ),
                          if (_headingInvalid)
                            const Padding(
                              padding: EdgeInsets.only(top: 6, left: 4),
                              child: Text(
                                'Heading is required',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          const SizedBox(height: 25),

                          SizedBox(height: 25),
                          Text(
                            'Start & End Date',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 🔴 Red border when invalid
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    _dateRangeInvalid
                                        ? Colors.red
                                        : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            child: CommonContainer.studentInfoScreen(
                              text: '',
                              controller: dateRangeController,
                              context: context,
                              imagePath: AppImages.calander,
                              verticalDivider: true,
                              datePickMode: DatePickMode.range,
                              styledRangeText: true,
                            ),
                          ),

                          if (_dateRangeInvalid && _dateRangeError != null)
                            const SizedBox(height: 6),
                          if (_dateRangeInvalid && _dateRangeError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                _dateRangeError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          SizedBox(height: 25),
                          Text(
                            'Announcement Date',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    _singleDateInvalid
                                        ? Colors.red
                                        : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            child: CommonContainer.studentInfoScreen(
                              text: 'Date',
                              controller: singleDateController,
                              context: context,
                              imagePath: AppImages.calander,
                              verticalDivider: true,
                              datePickMode: DatePickMode.single,
                              styledRangeText: false,
                            ),
                          ),

                          if (_singleDateInvalid && _singleDateError != null)
                            const SizedBox(height: 6),
                          if (_singleDateInvalid && _singleDateError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                _singleDateError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          SizedBox(height: 25),
                          Text(
                            'Timetable',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 10),

                          GestureDetector(
                            onTap: _pickPermanentImage,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(20),
                              color:
                                  _timetableInvalid
                                      ? Colors.red
                                      : AppColor.lightgray, // 🔴 here
                              strokeWidth: 1.5,
                              dashPattern: const [8, 4],
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                height: 120,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.lightWhite,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    if (_permanentImage == null)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppImages.uploadImage,
                                              height: 30,
                                            ),
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
                                          File(_permanentImage!.path),
                                          width: 200,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 35.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _permanentImage = null;
                                            });
                                          },
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
                                  ],
                                ),
                              ),
                            ),
                          ),

                          if (_timetableInvalid && _timetableError != null)
                            const SizedBox(height: 6),
                          if (_timetableInvalid && _timetableError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                _timetableError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          SizedBox(height: 40),
                          AppButton.button(
                            text: 'Submit',
                            image: AppImages.buttonArrow,
                            width: 139,
                            onTap: _onSubmit,
                            /*  onTap: () {
                              final heading = headingController.text.trim();
                              final dateRange = dateRangeController.text.trim();
                              final announcementDate =
                                  singleDateController.text.trim();
                              final timetable =
                                  _permanentImage?.path ?? 'No file selected';

                              // 🔹 Split start & end date
                              String startDate = "";
                              String endDate = "";
                              if (dateRange.contains("to")) {
                                final parts = dateRange.split("to");
                                startDate = parts[0].trim();
                                endDate =
                                    parts.length > 1 ? parts[1].trim() : "";
                              }

                              // 📌 Print all values before inserting
                              print("📌 Heading: $heading");
                              print("📌 Start Date: $startDate");
                              print("📌 End Date: $endDate");
                              print("📌 Announcement Date: $announcementDate");
                              print("📌 Timetable File: $timetable");

                              controller.createExam(
                                classId: selectedClassId ?? 1,
                                heading: heading,
                                startDate: startDate,
                                endDate: endDate,
                                announcementDate: announcementDate,
                                imageFiles:
                                    _permanentImage != null
                                        ? File(_permanentImage!.path)
                                        : null,
                                context: context,
                              );
                            },*/
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/*    Positioned(
                top: -20,
                                    bottom: -20,
                                    left: 0,
                                    right: 0,
                                    child:
                                    ListView.builder(
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
                                  ),*/

/*SizedBox(
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
                                      final isSelected = index == selectedIndex;

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
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
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
                                                      const SizedBox(height: 8),
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
                                                                BlendMode.srcIn,
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
                                                                  fontSize: 14,
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
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                                colors: [
                                                                  AppColor
                                                                      .blueG1,
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
                                                                horizontal: 20,
                                                                vertical: 3,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                AppColor.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            item.name,
                                                            style:
                                                                GoogleFont.ibmPlexSans(
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
                                                                FontWeight.bold,
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
                          ),*/
