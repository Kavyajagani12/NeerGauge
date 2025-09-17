import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textColorPrimary = Color(0xFF333333);
  static const Color textColorSecondary = Color(0xFF757575);

  static const Color statusOptimal = Color(0xFF4CAF50);
  static const Color statusCritical = Color(0xFFF44336);
  static const Color statusMedium = Color(0xFFFFC107);
  static const Color statusHigh = Color(0xFF2196F3);

  static const Color success = statusOptimal;
  static const Color warning = statusMedium;
  static const Color danger = statusCritical;
}
