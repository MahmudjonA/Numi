import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/features/home/presentation/bloc/food_prediction/food_prediction_event.dart';
import 'package:numi/features/home/presentation/pages/home_page.dart';
import 'package:numi/features/home/presentation/pages/meal_page.dart';
import 'package:numi/features/home/presentation/pages/my_foods_page.dart';
import 'package:numi/features/home/presentation/pages/stats_page.dart';
import 'features/home/presentation/bloc/food_prediction/food_prediction_bloc.dart';

class NumiBottomNav extends StatefulWidget {
  const NumiBottomNav({super.key});

  @override
  State<NumiBottomNav> createState() => _NumiBottomNavState();
}

class _NumiBottomNavState extends State<NumiBottomNav>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MealPage(),
    MyFoodsPage(),
    StatsPage(),
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    HapticFeedback.mediumImpact();
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return;
      final File image = File(pickedFile.path);
      if (!mounted) return;
      context
          .read<FoodPredictionBloc>()
          .add(PredictFoodImageEvent(image: image));
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),

      // ── Markaziy Kamera FAB ───────────────────────────────────────
      floatingActionButton: _CameraFab(onTap: _openCamera),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ── Chiroyli Bottom Nav ───────────────────────────────────────
      bottomNavigationBar: _BottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
        isDark: isDark,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Kamera FAB
// ──────────────────────────────────────────────────────────────────────────────
class _CameraFab extends StatefulWidget {
  final VoidCallback onTap;
  const _CameraFab({required this.onTap});

  @override
  State<_CameraFab> createState() => _CameraFabState();
}

class _CameraFabState extends State<_CameraFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
    )..value = 1.0;
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 62.w,
          height: 62.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF24AC8B), Color(0xFF1A7E66)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF24AC8B).withValues(alpha: 0.45),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.camera_alt_rounded,
            color: Colors.white,
            size: 26.sp,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Bottom Bar
// ──────────────────────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _BottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  static const _icons = [
    _NavItem(icon: Icons.home_outlined,          activeIcon: Icons.home_rounded),
    _NavItem(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu_rounded),
    _NavItem(icon: Icons.bookmark_border_rounded,  activeIcon: Icons.bookmark_rounded),
    _NavItem(icon: Icons.bar_chart_outlined,       activeIcon: Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final shadow = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.08);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 20, offset: const Offset(0, -4)),
        ],
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: [
              // Chap 2 ta tab
              Expanded(
                child: Row(
                  children: [
                    _buildTab(context, 0),
                    _buildTab(context, 1),
                  ],
                ),
              ),
              // Markaziy bo'sh joy (FAB uchun)
              SizedBox(width: 72.w),
              // O'ng 2 ta tab
              Expanded(
                child: Row(
                  children: [
                    _buildTab(context, 2),
                    _buildTab(context, 3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index) {
    final selected = currentIndex == index;
    final item = _icons[index];
    final s = S.of(context);
    final labels = [s.navHome, s.navHistory, s.navMine, s.navStats];
    final primary = Theme.of(context).colorScheme.primary;
    final unselected = isDark
        ? Colors.white.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.35);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon + pill indikator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: selected ? 14.w : 0,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  selected ? item.activeIcon : item.icon,
                  size: 22.sp,
                  color: selected ? primary : unselected,
                ),
              ),
              SizedBox(height: 2.h),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? primary : unselected,
                ),
                child: Text(labels[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  const _NavItem({required this.icon, required this.activeIcon});
}
