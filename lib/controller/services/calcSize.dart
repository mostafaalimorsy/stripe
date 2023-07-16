// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ResponsiveSize {
  //provide a percentage size and height and width
  static double size({double? sizeNumber, context, bool isHeight = false}) {
    double screenSize = isHeight ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width;
    double precentatgeNumber = (1 / sizeNumber!) * screenSize;
    double size = screenSize / precentatgeNumber;
    return size;
  }
}
