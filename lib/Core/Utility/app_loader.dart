import 'package:flutter/material.dart';


import 'app_color.dart';

class AppLoader {


  static circularLoader(Color? color ) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 2,
      ),
    );
  }
}
