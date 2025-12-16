import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_colors.dart';

class AppBarWg extends StatelessWidget {
  const AppBarWg({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.backgroundLight,
      title: Text(
        "Numi",
        style: GoogleFonts.dmSans(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOrange,
        ),
      ),
      actions: [
        Container(
          width: 35.w,
          height: 35.h,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.notifications_rounded,
              size: 25.h,
              color: AppColors.lightRed,
            ),
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }
}
