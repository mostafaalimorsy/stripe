import 'package:flutter/material.dart';
import 'package:stripe/controller/services/calcSize.dart';

class CommonWidget {
  static Widget divider({context, h, w}) {
    return Container(
      height: ResponsiveSize.size(context: context, sizeNumber: h ?? 1, isHeight: true),
      width: ResponsiveSize.size(context: context, sizeNumber: w ?? 330, isHeight: false),
      color: Colors.grey.withOpacity(.4),
    );
  }

  static Widget billRow({context, rowTitle, rowValue}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.size(context: context, sizeNumber: 8, isHeight: true),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rowTitle ?? "-",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: ResponsiveSize.size(context: context, sizeNumber: 15, isHeight: true),
            ),
          ),
          Text(
            rowValue == null ? "-" : "\$$rowValue",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: ResponsiveSize.size(context: context, sizeNumber: 15, isHeight: true),
            ),
          ),
        ],
      ),
    );
  }
}
