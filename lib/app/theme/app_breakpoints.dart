import 'package:flutter/widgets.dart';

class AppBreakpoints {
  AppBreakpoints._();

  static const double compact = 600;
  static const double medium = 1000;

  static bool isCompact(double width) => width < compact;

  static bool isMedium(double width) => width >= compact && width < medium;

  static bool isExpanded(double width) => width >= medium;

  static double widthOf(BuildContext context) => MediaQuery.sizeOf(context).width;
}
