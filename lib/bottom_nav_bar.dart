import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/features/home/presentation/pages/home_page.dart';
import 'package:numi/features/home/presentation/pages/meal_page.dart';
import 'package:numi/features/home/presentation/pages/my_foods_page.dart';
import 'package:numi/features/home/presentation/pages/stats_page.dart';

class NumiBottomNav extends StatefulWidget {
  const NumiBottomNav({super.key});

  @override
  State<NumiBottomNav> createState() => _NumiBottomNavState();
}

class _NumiBottomNavState extends State<NumiBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MealPage(),
    MyFoodsPage(),
    StatsPage(),
  ];

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _BottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
        isDark: isDark,
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
    _NavItem(icon: Icons.home_outlined,           activeIcon: Icons.home_rounded),
    _NavItem(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu_rounded),
    _NavItem(icon: Icons.bookmark_border_rounded,  activeIcon: Icons.bookmark_rounded),
    _NavItem(icon: Icons.bar_chart_outlined,       activeIcon: Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final bg     = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final shadow = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.08);
    final s = S.of(context);
    final labels = [s.navHome, s.navHistory, s.navMine, s.navStats];

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
            children: List.generate(4, (index) => _buildTab(context, index, labels[index])),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String label) {
    final selected = currentIndex == index;
    final item     = _icons[index];
    final primary  = Theme.of(context).colorScheme.primary;
    final unselected = isDark
        ? Colors.white.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.35);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? primary : unselected,
              ),
              child: Text(label),
            ),
          ],
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
