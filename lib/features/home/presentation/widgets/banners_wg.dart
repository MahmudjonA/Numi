import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannersWg extends StatelessWidget {
  const BannersWg({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin:  EdgeInsets.only(left: 12.w),
      width: 340.w,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image:  DecorationImage(
          image: AssetImage("assets/image.jpg"),
          fit: BoxFit.cover,
        ),
        color: Colors.blue,
      ),
    );
  }
}