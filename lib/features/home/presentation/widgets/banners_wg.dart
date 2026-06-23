import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannersWg extends StatelessWidget {
  const BannersWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: const DecorationImage(
          image: AssetImage("assets/image.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.55),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sog'lom turmush\ntarzi boshlanadi",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFF24AC8B),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "Bugun kuzat →",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
