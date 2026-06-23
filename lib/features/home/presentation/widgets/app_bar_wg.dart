import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/settings/app_settings.dart';

class AppBarWg extends StatelessWidget {
  final List<Widget>? actions;

  const AppBarWg({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Text("Numi", style: Theme.of(context).textTheme.titleLarge),
      actions: [
        if (actions != null) ...actions!,
        _ThemeToggleBtn(),
        SizedBox(width: 4.w),
        _LangCycleBtn(),
        SizedBox(width: 6.w),
        Icon(
          Icons.notifications_rounded,
          size: 24.h,
          color: Theme.of(context).iconTheme.color,
        ),
        SizedBox(width: 14.w),
      ],
    );
  }
}

// -- Theme toggle
class _ThemeToggleBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);
    final isDark = settings.isDark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        settings.toggleTheme();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              key: ValueKey(isDark),
              size: 18.sp,
              color: isDark ? Colors.amber : const Color(0xFF5C6BC0),
            ),
          ),
        ),
      ),
    );
  }
}

// -- Language cycle button
class _LangCycleBtn extends StatelessWidget {
  static const _flags = {'uz': '🇺🇿', 'ru': '🇷🇺', 'en': '🇬🇧'};
  static const _labels = {'uz': 'UZ', 'ru': 'RU', 'en': 'EN'};

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);
    final lang = settings.lang;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        settings.cycleLang();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                _flags[lang]!,
                key: ValueKey(lang),
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            SizedBox(width: 3.w),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _labels[lang]!,
                key: ValueKey('label_$lang'),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
