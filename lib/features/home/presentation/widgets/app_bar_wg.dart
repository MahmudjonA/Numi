import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWg extends StatelessWidget {
  const AppBarWg({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Text("Numi", style: Theme.of(context).textTheme.titleLarge),
      actions: [
        SizedBox(
          width: 35.w,
          height: 35.h,
          child: Center(
            child: Icon(
              Icons.notifications_rounded,
              size: 25.h,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }
}
