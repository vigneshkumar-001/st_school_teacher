import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_teacher_app/Core/Utility/custom_app_button.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/teacher_class_controller.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'homework_create_preview.dart';
import 'homework_history.dart';
import 'model/teacher_class_response.dart';

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

class HomeworkCreate extends StatefulWidget {
  final String? className;
  final String? section;
  const HomeworkCreate({super.key, this.className, this.section});

  @override
  State<HomeworkCreate> createState() => _HomeworkCreateState();
}

class _HomeworkCreateState extends State<HomeworkCreate> {
  // ===== State =====
  final TeacherClassController teacherClassController = Get.put(
    TeacherClassController(),
  );

  // form
  final _formKey = GlobalKey<FormState>();

  // class/subject pickers

  int selectedIndex = 0;
  int subjectIndex = 0;
  String? selectedSubject;
  int? selectedSubjectId;
  int? selectedClassId;

  // permanent hero image
  XFile? _permanentImage;

  // dynamic sections
  final List<SectionItem> _sections = [];

  // old “multi description” (kept & fixed)
  final List<TextEditingController> descriptionControllers = [];

  // “List” section (legacy add-on area)
  final List<String> _listTextFields = [];
  final List<TextEditingController> _listControllers = [];
  bool _listSectionOpened = false;

  // heading
  final TextEditingController headingController = TextEditingController();
  bool showClearIcon = false;

  // picker
  final ImagePicker _picker = ImagePicker();

  // --- Class scroller centering ---
  final ScrollController _classScroll = ScrollController();
  static const double _classItemWidth = 90; // must match your item width
  static const double _classGap =
      0; // horizontal gap between items (update if you add spacing)

  void _centerSelectedClass({bool animate = true}) {
    if (!_classScroll.hasClients) return;

    final viewport = _classScroll.position.viewportDimension;
    final itemExtent = _classItemWidth + _classGap;
    final targetCenter = selectedIndex * itemExtent + (_classItemWidth / 2.0);
    final targetOffset = targetCenter - (viewport / 2.0);

    final maxExtent = _classScroll.position.maxScrollExtent;
    final offset = targetOffset.clamp(0.0, maxExtent);

    if (animate) {
      _classScroll.animateTo(
        offset,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _classScroll.jumpTo(offset);
    }
  }
  /*  @override
  void initState() {
    super.initState();

    // Always show at least 1 description field
    descriptionControllers.add(TextEditingController());

    // Heading controller listener for clear icon
    headingController.addListener(() {
      setState(() => showClearIcon = headingController.text.isNotEmpty);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Default class setup
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


        teacherClassController.filterSubjectsByClass(defaultClass.id);

        // Default subject setup only if nothing selected yet
        if (teacherClassController.filteredSubjects.isNotEmpty &&
            teacherClassController.selectedSubject.value == null) {
          subjectIndex = 0;
          selectedSubject = teacherClassController.filteredSubjects[0].name;
          selectedSubjectId = teacherClassController.filteredSubjects[0].id;
          teacherClassController.selectedSubject.value =
          teacherClassController.filteredSubjects[0];
          teacherClassController.selectedSubjectIndex.value = 0;
        }
      }

      // Center selected class in horizontal scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerSelectedClass(animate: false);
      });

      setState(() {});
    });
  }*/

  @override
  void initState() {
    super.initState();

    // show at least 1 description
    descriptionControllers.add(TextEditingController());

    headingController.addListener(() {
      setState(() => showClearIcon = headingController.text.isNotEmpty);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final classes = teacherClassController.classList;
      if (classes.isNotEmpty) {
        // If nothing selected yet, set default ONCE
        if (teacherClassController.selectedClass.value == null) {
          final def = classes.firstWhere(
            (c) =>
                c.name == (widget.className ?? c.name) &&
                c.section == (widget.section ?? c.section),
            orElse: () => classes.first,
          );
          teacherClassController.selectedClass.value = def;
          teacherClassController.selectedClassIndex.value = classes.indexOf(
            def,
          );
          teacherClassController.filterSubjectsByClass(def.id);
        } else {
          // already had a selection (back from preview) → just ensure subjects are synced
          final cur = teacherClassController.selectedClass.value!;
          teacherClassController.filterSubjectsByClass(cur.id);
        }
      }

      // center current selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerSelectedClass(animate: false);
      });

      setState(() {});
    });
  }

  /*  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ... your existing defaultClass / subject setup ...

      setState(() {}); // you already had this
      // Center the default/initial selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerSelectedClass(animate: false);
      });
    });

    // Always show at least 1 description field
    descriptionControllers.add(TextEditingController());

    headingController.addListener(() {
      setState(() => showClearIcon = headingController.text.isNotEmpty);
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

      if (teacherClassController.subjectList.isNotEmpty) {
        subjectIndex = 0;
        selectedSubject = teacherClassController.subjectList[0].name;
        selectedSubjectId = teacherClassController.subjectList[0].id;
      }

      setState(() {});
    });
  }*/

  @override
  void dispose() {
    headingController.dispose();
    for (final c in descriptionControllers) {
      c.dispose();
    }
    for (final c in _listControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ===== Helpers =====
  Future<void> _pickPermanentImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _permanentImage = picked);
    }
  }

  void _openListSection() {
    if (_listSectionOpened) return;
    setState(() {
      _listSectionOpened = true;
      _listTextFields.add('');
      _listControllers.add(TextEditingController());
    });
  }

  void _addMoreListPoint() {
    setState(() {
      _listTextFields.add('');
      _listControllers.add(TextEditingController());
    });
  }

  void _removeListItem(int index) {
    setState(() {
      _listControllers[index].dispose();
      _listControllers.removeAt(index);
      _listTextFields.removeAt(index);
      if (_listTextFields.isEmpty) _listSectionOpened = false;
    });
  }

  void addDescriptionField() {
    setState(() => descriptionControllers.add(TextEditingController()));
  }

  void removeDescriptionField(int index) {
    setState(() {
      descriptionControllers[index].dispose();
      descriptionControllers.removeAt(index);
      if (descriptionControllers.isEmpty) {
        descriptionControllers.add(TextEditingController());
      }
    });
  }

  int _getTypeIndex(SectionType type, int globalIndex) {
    int count = 0;
    for (int i = 0; i <= globalIndex; i++) {
      if (_sections[i].type == type) count++;
    }
    return count;
  }

  bool _validateAtLeastOneDescriptionFilled() {
    final legacy = descriptionControllers.any((c) => c.text.trim().isNotEmpty);
    final modular = _sections.any(
      (s) => s.type == SectionType.paragraph && s.paragraph.trim().isNotEmpty,
    );
    return legacy || modular;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _validateAndProceed() {
    FocusScope.of(context).unfocus();

    // 🔹 Trigger TextFormFields’ validators
    if (!_formKey.currentState!.validate()) return;

    // 🔹 Extra guards for Class
    final selectedClass =
        teacherClassController.selectedClass.value ??
        (teacherClassController.classList.isNotEmpty
            ? teacherClassController.classList[teacherClassController
                .selectedClassIndex
                .value]
            : null);

    if (selectedClass == null) {
      _showSnack('Please select a class.');
      return;
    }

    // 🔹 Extra guards for Subject
    final selectedSubject =
        teacherClassController.selectedSubject.value ??
        (teacherClassController.filteredSubjects.isNotEmpty
            ? teacherClassController.filteredSubjects[teacherClassController
                .selectedSubjectIndex
                .value]
            : null);

    if (selectedSubject == null) {
      _showSnack('Please select a subject.');
      return;
    }

    // 🔹 At least 1 description paragraph
    if (!_validateAtLeastOneDescriptionFilled()) {
      _showSnack('Please enter at least one description.');
      return;
    }

    // 🔹 Collect final data
    final selectedSubjectId = selectedSubject.id;

    final paragraphs = <String>[
      ...descriptionControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty),
      ..._sections
          .where(
            (s) =>
                s.type == SectionType.paragraph &&
                s.paragraph.trim().isNotEmpty,
          )
          .map((s) => s.paragraph.trim()),
    ];

    final images =
        _sections
            .where((s) => s.type == SectionType.image && s.image != null)
            .map((s) => File(s.image!.path))
            .toList();

    final listPoints = [
      ..._listTextFields.map((t) => t.trim()).where((t) => t.isNotEmpty),
      ..._sections
          .where((s) => s.type == SectionType.list)
          .expand((s) => s.listPoints.map((t) => t.trim()))
          .where((t) => t.isNotEmpty),
    ];

    // 🔹 Navigate to preview
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => HomeworkCreatePreview(
              listPoints: listPoints,
              subjectId: selectedSubjectId,
              subjects: selectedSubject.name,
              selectedClassId:
                  selectedClass.id, // ✅ always use current selected class
              description: paragraphs,
              images: images,
              permanentImage:
                  _permanentImage != null ? File(_permanentImage!.path) : null,
              heading: headingController.text.trim(),
            ),
      ),
    );
  }

  /*void _validateAndProceed() {
    FocusScope.of(context).unfocus();

    // Trigger TextFormFields’ validators
    if (!_formKey.currentState!.validate()) return;

    // Extra guards for Class/Subject
    if (selectedClassId == null &&
        (teacherClassController.selectedClass.value == null &&
            teacherClassController.classList.isEmpty)) {
      _showSnack('Please select a class.');
      return;
    }
    if (teacherClassController.selectedSubject.value == null &&
        teacherClassController.subjectList.isEmpty) {
      _showSnack('Please select a subject.');
      return;
    }

    // At least 1 description paragraph overall (keep this if you st ill want the global rule)
    if (!_validateAtLeastOneDescriptionFilled()) {
      _showSnack('Please enter at least one description.');
      return;
    }

    // ok → collect & go
    final selectedClass =
        teacherClassController.selectedClass.value ??
            (teacherClassController.classList.isNotEmpty
                ? teacherClassController.classList.first
                : null);

    final selectedSubject = teacherClassController.selectedSubject.value;
    final selectedSubjectId = selectedSubject?.id;

    final paragraphs = <String>[
      // legacy descriptions
      ...descriptionControllers
          .map((c) => c.text)
          .where((t) => t.trim().isNotEmpty),
      // modular paragraph sections
      ..._sections
          .where(
            (s) =>
        s.type == SectionType.paragraph &&
            s.paragraph.trim().isNotEmpty,
      )
          .map((s) => s.paragraph),
    ];

    final images = _sections
        .where((s) => s.type == SectionType.image && s.image != null)
        .map((s) => File(s.image!.path))
        .toList();

    final listPoints = [
      // legacy list block
      ..._listTextFields.where((t) => t.trim().isNotEmpty),
      // modular list sections
      ..._sections
          .where((s) => s.type == SectionType.list)
          .expand((s) => s.listPoints)
          .where((t) => t.trim().isNotEmpty),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeworkCreatePreview(
          listPoints: listPoints,
          subjectId: selectedSubjectId,
          subjects: selectedSubject?.name ?? '',
          selectedClassId: selectedClass?.id ?? selectedClassId,
          description: paragraphs,
          images: images,
          permanentImage:
          _permanentImage != null ? File(_permanentImage!.path) : null,
          heading: headingController.text,
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          final classes = teacherClassController.classList;
          final subjects = teacherClassController.subjectList;
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
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
                                builder: (_) => const HomeworkHistory(),
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
                    Center(
                      child: Text(
                        'Create Homework',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Class picker
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Text(
                              'Class',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.black,
                              ),
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
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final count = classes.length;
                                      // total width of all cards + gaps
                                      final totalW =
                                          count * _classItemWidth +
                                          (count - 1) * _classGap;
                                      // if content is narrower than viewport, add symmetric side padding to center the row
                                      final sidePad =
                                          totalW < constraints.maxWidth
                                              ? (constraints.maxWidth -
                                                      totalW) /
                                                  2.0
                                              : 0.0;

                                      return ListView.builder(
                                        controller: _classScroll,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: classes.length,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: sidePad,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Obx(() {
                                            final item = classes[index];
                                            final isSelected =
                                                teacherClassController
                                                    .selectedClassIndex
                                                    .value ==
                                                index;

                                            return GestureDetector(
                                              onTap: () {
                                                final selectedClass =
                                                    teacherClassController
                                                        .classList[index];
                                                teacherClassController
                                                    .selectedClass
                                                    .value = selectedClass;
                                                teacherClassController
                                                    .selectedClassIndex
                                                    .value = index;

                                                teacherClassController
                                                    .filterSubjectsByClass(
                                                      selectedClass.id,
                                                    );

                                                if (teacherClassController
                                                    .filteredSubjects
                                                    .isNotEmpty) {
                                                  teacherClassController
                                                      .selectedSubjectIndex
                                                      .value = 0;
                                                  teacherClassController
                                                          .selectedSubject
                                                          .value =
                                                      teacherClassController
                                                          .filteredSubjects[0];
                                                } else {
                                                  teacherClassController
                                                      .selectedSubjectIndex
                                                      .value = -1;
                                                  teacherClassController
                                                      .selectedSubject
                                                      .value = null;
                                                }

                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                      _centerSelectedClass();
                                                    });
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 120,
                                                ),
                                                curve: Curves.easeInOut,
                                                width: _classItemWidth,
                                                height: isSelected ? 120 : 80,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: _classGap / 2,
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
                                                            color:
                                                                AppColor.blueG1,
                                                            width: 1.5,
                                                          )
                                                          : null,
                                                  boxShadow:
                                                      isSelected
                                                          ? [
                                                            BoxShadow(
                                                              color: AppColor
                                                                  .white
                                                                  .withOpacity(
                                                                    0.5,
                                                                  ),
                                                              blurRadius: 10,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    4,
                                                                  ),
                                                            ),
                                                          ]
                                                          : [],
                                                ),
                                                child:
                                                    isSelected
                                                        ? // ✅ SELECTED UI
                                                        Column(
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
                                                                            Alignment.topLeft,
                                                                        end:
                                                                            Alignment.bottomRight,
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
                                                                      fontSize:
                                                                          28,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                      ),
                                                                  child: ShaderMask(
                                                                    shaderCallback:
                                                                        (
                                                                          bounds,
                                                                        ) => const LinearGradient(
                                                                          colors: [
                                                                            AppColor.blueG1,
                                                                            AppColor.blue,
                                                                          ],
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end:
                                                                              Alignment.bottomRight,
                                                                        ).createShader(
                                                                          Rect.fromLTWH(
                                                                            0,
                                                                            0,
                                                                            bounds.width,
                                                                            bounds.height,
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
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 55,
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              decoration: const BoxDecoration(
                                                                gradient: LinearGradient(
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
                                                                          .topRight,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.vertical(
                                                                      bottom:
                                                                          Radius.circular(
                                                                            22,
                                                                          ),
                                                                    ),
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                item.section,
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      AppColor
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                        : // 🚫 UNSELECTED UI
                                                        Center(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          3,
                                                                    ),
                                                                decoration: BoxDecoration(
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
                                                                    fontSize:
                                                                        14,
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
                                          });
                                        },
                                      );
                                    },
                                  ),

                                  /*ListView.builder(
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
                                            teacherClassController.selectedClass.value = item;
                                          });
                                          // Center after the frame updates sizes/positions
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            _centerSelectedClass();
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
                                  ),*/
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Subject picker
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Text(
                              'Subject',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.black,
                              ),
                            ),
                          ),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Wrap(
                              spacing: 10,
                              children: List.generate(
                                teacherClassController.filteredSubjects.length,
                                (index) {
                                  final sub =
                                      teacherClassController
                                          .filteredSubjects[index];
                                  final selectedIndexs =
                                      teacherClassController
                                          .selectedSubjectIndex
                                          .value;
                                  final isSelected = selectedIndexs == index;

                                  return GestureDetector(
                                    onTap: () {
                                      teacherClassController
                                          .selectedSubjectIndex
                                          .value = index;
                                      teacherClassController
                                          .selectedSubject
                                          .value = sub;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSelected ? 25 : 35,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? AppColor.blue
                                                  : AppColor.borderGary,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelected) ...[
                                            Image.asset(
                                              AppImages.tick,
                                              height: 15,
                                              color: AppColor.blue,
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                          Text(
                                            sub.name,
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 12,
                                              color:
                                                  isSelected
                                                      ? AppColor.blue
                                                      : AppColor.gray,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Permanent (hero) image
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: _pickPermanentImage,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    color: AppColor.lightgray,
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
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              AppColor
                                                                  .lightgray,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else ...[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.file(
                                                File(_permanentImage!.path),
                                                width: 200,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 35.0,
                                                  ),
                                              child: InkWell(
                                                onTap:
                                                    () => setState(
                                                      () =>
                                                          _permanentImage =
                                                              null,
                                                    ),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      AppImages.close,
                                                      height: 26,
                                                      color: AppColor.gray,
                                                    ),
                                                    Text(
                                                      'Clear',
                                                      style:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                AppColor
                                                                    .lightgray,
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

                                const SizedBox(height: 25),

                                // Heading (validated)
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
                                    setState(() => showClearIcon = false);
                                  },
                                  imagePath:
                                      showClearIcon ? AppImages.close : null,
                                  imageColor: AppColor.gray,
                                  text: '',
                                  controller: headingController,
                                  verticalDivider: false,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Heading is required';
                                    if (v.trim().length < 3)
                                      return 'Heading must be at least 3 characters';
                                    return null;
                                  },
                                  onChanged:
                                      (v) => setState(
                                        () => showClearIcon = v.isNotEmpty,
                                      ),
                                ),

                                const SizedBox(height: 25),

                                // Descriptions (each validated like Heading)
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
                                              if (descriptionControllers
                                                      .length >
                                                  1)
                                                GestureDetector(
                                                  onTap:
                                                      () =>
                                                          removeDescriptionField(
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
                                              if (v == null || v.trim().isEmpty)
                                                return 'Description is required';
                                              if (v.trim().length < 3)
                                                return 'Please enter at least 3 characters';
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                if (_listSectionOpened) ...[
                                  const SizedBox(height: 20),
                                  Text(
                                    'List',
                                    style: GoogleFont.ibmPlexSans(fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  ListView.builder(
                                    itemCount: _listTextFields.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 14,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.lightWhite,
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                'List ${index + 1}',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 14,
                                                  color: AppColor.gray,
                                                ),
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
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      _listControllers[index],
                                                  decoration: InputDecoration(
                                                    hintStyle:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 14,
                                                          color: AppColor.gray,
                                                        ),
                                                    border: InputBorder.none,
                                                  ),
                                                  onChanged:
                                                      (value) =>
                                                          _listTextFields[index] =
                                                              value,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap:
                                                    () =>
                                                        _removeListItem(index),
                                                child: Image.asset(
                                                  AppImages.close,
                                                  height: 26,
                                                  color: AppColor.gray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: _addMoreListPoint,
                                    child: DottedBorder(
                                      color: AppColor.blue,
                                      strokeWidth: 1.5,
                                      dashPattern: const [8, 4],
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Add List ${_listTextFields.length + 1} Point',
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
                                ListView.builder(
                                  itemCount: _sections.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final item = _sections[index];
                                    switch (item.type) {
                                      case SectionType.image:
                                        return _buildImageContainer(
                                          item,
                                          index,
                                        );
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

                                // Add buttons
                                Row(
                                  children: [
                                    Text(
                                      'Add',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 14,
                                        color: AppColor.black,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    // Spacer(),
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

                                // Preview (validates)
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
                        ],
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

  // ===== Section builders =====
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
          const SizedBox(height: 6),
          CommonContainer.fillingContainer(
            maxLine: 5,
            text: item.paragraph,
            controller: null,
            verticalDivider: false,
            onChanged: (val) => setState(() => item.paragraph = val),
            // ✅ Same validator rules as Heading
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Description is required';
              if (v.trim().length < 3)
                return 'Please enter at least 3 characters';
              return null;
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
          const SizedBox(height: 12),

          // dynamic points
          ListView.builder(
            itemCount: item.listPoints.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, listIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'List ${listIndex + 1}',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          color: AppColor.gray,
                        ),
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
                        child: TextField(
                          controller: TextEditingController(
                            text: item.listPoints[listIndex],
                          ),
                          decoration: InputDecoration(
                            hintStyle: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.gray,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged:
                              (value) => item.listPoints[listIndex] = value,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap:
                            () => setState(
                              () => item.listPoints.removeAt(listIndex),
                            ),
                        child: Image.asset(
                          AppImages.close,
                          height: 26,
                          color: AppColor.gray,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

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
}
