import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:st_teacher_app/Core/Widgets/common_container.dart';

import '../../../../../../Core/Utility/app_color.dart';
import 'package:get/get.dart';

import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../Profile/controller/teacher_data_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isValidUrl(String? s) {
    if (s == null) return false;
    final u = Uri.tryParse(s.trim());
    return u != null && (u.scheme == 'http' || u.scheme == 'https');
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder:
          (_) => Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take from Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        if (sdkInt >= 33) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }
      }
    } else if (Platform.isIOS) {
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        status = await Permission.photos.request();
      }
    } else {
      return;
    }

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettingsDialog();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permission denied.')));
    }
  }

  void openAppSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Permission Required'),
            content: Text(
              'Permission is permanently denied. Please enable it from app settings to continue.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  final TeacherDataController controller = Get.put(TeacherDataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          final data = controller.teacherDataResponse.value?.data;
          final String? studentImageUrl = data?.profile.profileImg;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(
                          color: AppColor.lowLightBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          CupertinoIcons.left_chevron,
                          color: AppColor.gray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Apply Profile Picture",
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColor.lightBlack,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Stack(
                      children: [
                        Container(
                          width: 350,
                          height: 550,

                          decoration: BoxDecoration(
                            color: AppColor.black,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          clipBehavior:
                              Clip.antiAlias, // make radius clip the image
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // soft bg
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFE9F4FF),
                                      Color(0xFFCBE9FF),
                                    ],
                                  ),
                                ),
                              ),

                              // 1) if user picked a file -> show file
                              if (_imageFile != null)
                                Image.file(
                                  File(_imageFile!.path),
                                  fit: BoxFit.cover,
                                )
                              // 2) else show current profile from API
                              else if (studentImageUrl != null &&
                                  studentImageUrl.isNotEmpty &&
                                  _isValidUrl(studentImageUrl))
                                Image.network(
                                  studentImageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AppImages.profilePicture,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              // 3) else fallback asset
                              else
                                Image.asset(
                                  AppImages.profilePicture,
                                  fit: BoxFit.cover,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /*      GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Stack(
                      children: [
                        Container(
                          width: 350,
                          height: 582,
                          decoration: BoxDecoration(
                            color: AppColor.black,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          clipBehavior:
                              Clip.antiAlias, // clip the child to the rounded border
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Optional subtle bg while loading
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFE9F4FF),
                                      Color(0xFFCBE9FF),
                                    ],
                                  ),
                                ),
                              ),
                              if (_imageFile != null &&
                                  _imageFile!.trim().isNotEmpty)
                                Image.network(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (c, w, p) =>
                                          p == null
                                              ? w
                                              : const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                  errorBuilder:
                                      (_, __, ___) => Image.asset(
                                        AppImages.profilePicture,
                                        fit: BoxFit.cover,
                                      ),
                                )
                              else
                                Image.asset(
                                  AppImages.profilePicture,
                                  fit: BoxFit.cover,
                                ),
                            ],
                          ),
                        ),

                        // Container(
                        //   width: 350,
                        //   height: 582,
                        //   decoration: BoxDecoration(
                        //     color: AppColor.black,
                        //     borderRadius: BorderRadius.circular(15),
                        //     border: Border.all(
                        //       color: Colors.grey.shade400,
                        //       width: 2,
                        //     ),
                        //     image: DecorationImage(
                        //       image:
                        //       _imageFile != null
                        //           ? FileImage(_imageFile!)
                        //           : AssetImage(AppImages.profilePicture)
                        //       as ImageProvider,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   bottom: 12,
                        //   right: 12,
                        //   child: CircleAvatar(
                        //     radius: 20,
                        //     backgroundColor: Colors.blue,
                        //     child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        //   ),
                        // ),
                      ],
                    ),
                  ),*/
                  SizedBox(height: 20),
                  CommonContainer.checkMark(
                    onTap: () {
                      controller.imageUpload(
                        frontImageFile: File(_imageFile?.path.toString() ?? ''),
                      );
                    },
                    imagePath: AppImages.tick,
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
