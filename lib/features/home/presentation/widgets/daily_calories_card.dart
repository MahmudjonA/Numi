import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numi/core/app_colors.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_bloc.dart';
import 'package:numi/features/home/presentation/bloc/user_body_info/user_body_info_state.dart';

class DailyCaloriesCard extends StatelessWidget {
  final VoidCallback onPress;

  const DailyCaloriesCard({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBodyInfoBloc, UserBodyInfoState>(
      builder: (context, state) {
        String caloriesText = '--';

        if (state is UserBodyInfoLoaded) {
          caloriesText = state.dailyCalories.toString();
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onPress,
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.searchColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  /// LEFT (text) — constrained
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Calories",
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.searchTextColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              caloriesText,
                              style: GoogleFonts.dmSans(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "kcal",
                              style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT (icon)
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 32.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
