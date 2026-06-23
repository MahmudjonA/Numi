import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import '../../../../core/widgets/path_generater.dart';
import '../pages/category_meals_page.dart';

const Map<String, List<Color>> _categoryGradients = {
  'Fruits':         [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
  'Vegetables':     [Color(0xFF56AB2F), Color(0xFFA8E063)],
  'Bread':          [Color(0xFFF7971E), Color(0xFFFFD200)],
  'Meat':           [Color(0xFFEB3349), Color(0xFFF45C43)],
  'Seafood':        [Color(0xFF2193B0), Color(0xFF6DD5ED)],
  'Eggs':           [Color(0xFFFFB347), Color(0xFFFFCC02)],
  'Drinks':         [Color(0xFF4776E6), Color(0xFF8E54E9)],
  'Fast_Food':      [Color(0xFFFF416C), Color(0xFFFF4B2B)],
  'Sweets':         [Color(0xFFDA22FF), Color(0xFF9733EE)],
  'Dairy_Products': [Color(0xFF1D976C), Color(0xFF93F9B9)],
  'Grains':         [Color(0xFFC79B27), Color(0xFFE8D07A)],
};

const Map<String, String> _categoryEmojis = {
  'Fruits':         '🍎',
  'Vegetables':     '🥕',
  'Bread':          '🍞',
  'Meat':           '🍗',
  'Seafood':        '🐟',
  'Eggs':           '🥚',
  'Drinks':         '🥤',
  'Fast_Food':      '🍔',
  'Sweets':         '🍰',
  'Dairy_Products': '🥛',
  'Grains':         '🌾',
};

class CategoriesWg extends StatefulWidget {
  const CategoriesWg({super.key});

  @override
  State<CategoriesWg> createState() => _CategoriesWgState();
}

class _CategoriesWgState extends State<CategoriesWg> {
  Map<String, List<String>> categories = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await loadCategoryAssets();
      if (mounted) setState(() => categories = data);
    } catch (_) {
      // Assets yuklanmasa — bo'sh holat ko'rsatiladi
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      // Yuklanmoqda yoki asset yo'q — joy belgilash uchun bo'sh joy
      return const SizedBox.shrink();
    }

    final entries = categories.entries.toList();
    // Screen kengligi asosida har qatorda nechta karta
    final double screenW = MediaQuery.of(context).size.width;
    final double cardW = (screenW - 32 - 10 * 3) / 4; // 4 ta qatorda

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: entries.map((entry) {
        final s = S.of(context);
        return _CategoryCard(
          name: entry.key,
          displayName: s.categoryName(entry.key),
          images: entry.value,
          width: cardW,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryMealsPage(
                categoryName: entry.key,
                images: entry.value,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final String displayName;
  final List<String> images;
  final double width;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.displayName,
    required this.images,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradients = _categoryGradients[name] ??
        [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
        ];
    final emoji = _categoryEmojis[name] ?? '🍽️';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: width * 1.1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradients,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: gradients.first.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (images.isNotEmpty)
              Image.asset(
                images.first,
                width: width * 0.45,
                height: width * 0.45,
                errorBuilder: (_, __, ___) =>
                    Text(emoji, style: TextStyle(fontSize: 22.sp)),
              )
            else
              Text(emoji, style: TextStyle(fontSize: 22.sp)),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                displayName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: const [
                    Shadow(color: Colors.black26, blurRadius: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
