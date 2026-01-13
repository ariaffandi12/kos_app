import 'package:flutter/material.dart';
import 'constants/app_colors.dart';

final appTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundDark,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),
  primaryColor: AppColors.primary,
);