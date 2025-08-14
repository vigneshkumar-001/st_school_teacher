import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_images.dart';

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double carveRadius = 13; // Bigger radius for deeper curve

    final path =
        Path()
          ..lineTo(size.width, 0) // top edge
          ..lineTo(size.width, size.height - carveRadius)
          ..arcToPoint(
            Offset(size.width - carveRadius, size.height),
            radius: Radius.circular(carveRadius),
            clockwise: false,
          )
          ..lineTo(0, size.height)
          ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CurvedAttendanceCard extends StatelessWidget {
  final bool isAbsent;
  final String imagePath; // <-- Added so we can pass morning/afternoon images

  const CurvedAttendanceCard({
    super.key,
    required this.isAbsent,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: BottomCurveClipper(),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),

        // Attendance icon positioned inside curve
        Positioned(
          bottom: -8,
          right: -8,
          child: Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              isAbsent ? AppImages.attendanceTick : AppImages.attendanceAbsent,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
