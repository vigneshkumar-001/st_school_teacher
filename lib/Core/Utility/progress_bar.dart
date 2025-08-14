import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 and 1.0

  const GradientProgressBar({Key? key, required this.progress})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumbSize = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbPosition = (width - thumbSize) * progress;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Background bar (light gray)
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // Gradient filled bar
            Container(
              width: thumbPosition + thumbSize / 2,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.orange, Colors.green],
                ),
              ),
            ),
            // White circular thumb
            Positioned(
              left:
                  thumbPosition -
                  thumbSize / 1, // shift left by half thumb size
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
