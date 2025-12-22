import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  scaffoldBackgroundColor: AppColors.lightBackground,

  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightText,
    error: AppColors.error,
  ),

  textTheme: GoogleFonts.dmSansTextTheme().apply(
    bodyColor: AppColors.lightText,
    displayColor: AppColors.lightText,
  ),

  cardColor: AppColors.lightSurface,
  dividerColor: AppColors.border,

  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.lightText,
    titleTextStyle: GoogleFonts.dmSans(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
  ),

  iconTheme: IconThemeData(color: AppColors.lightText),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
);
