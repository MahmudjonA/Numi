import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  scaffoldBackgroundColor: AppColors.darkBackground,

  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkText,
    error: AppColors.error,
  ),

  textTheme: GoogleFonts.dmSansTextTheme(
    ThemeData.dark().textTheme,
  ).apply(bodyColor: AppColors.darkText, displayColor: AppColors.darkText),

  cardColor: AppColors.darkSurface,
  dividerColor: Colors.grey.shade800,

  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.darkText,
    titleTextStyle: GoogleFonts.dmSans(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
    ),
  ),

  iconTheme: IconThemeData(color: AppColors.darkText),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
);
