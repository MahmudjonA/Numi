import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/features/home/presentation/bloc/water/water_bloc.dart';
import 'package:numi/features/home/presentation/bloc/water/water_event.dart';
import 'package:numi/features/home/presentation/bloc/water/water_state.dart';

class WaterWidget extends StatelessWidget {
  const WaterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<WaterBloc, WaterState>(
      builder: (context, state) {
        int total      = 0;
        int goal       = 2000;
        double progress = 0.0;

        if (state is WaterLoaded) {
          total    = state.totalMl;
          goal     = state.goalMl;
          progress = state.progress;
        }

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.water_drop,
                      color: Colors.blue.shade400, size: 20),
                  SizedBox(width: 6.w),
                  Text(s.waterLabel,
                      style: Theme.of(context).textTheme.labelMedium),
                  const Spacer(),
                  Text(
                    "${total}ml / ${goal}ml",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.blue.shade400),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 7.h,
                  backgroundColor: Colors.blue.shade100,
                  valueColor: AlwaysStoppedAnimation(Colors.blue.shade400),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  _btn(context, "+250ml",
                      () => context.read<WaterBloc>().add(const AddWaterEvent(ml: 250))),
                  SizedBox(width: 8.w),
                  _btn(context, "+500ml",
                      () => context.read<WaterBloc>().add(const AddWaterEvent(ml: 500))),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh,
                        color: Colors.blue.shade300, size: 20),
                    tooltip: "Reset",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () =>
                        context.read<WaterBloc>().add(ResetWaterEvent()),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _btn(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
