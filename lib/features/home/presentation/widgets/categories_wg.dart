import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/path_generater.dart';
import '../pages/category_meals_page.dart';

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
    loadData();
  }

  Future<void> loadData() async {
    final data = await loadCategoryAssets();
    setState(() => categories = data);
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return SizedBox(
        height: 120.h,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.entries.map((entry) {
          final categoryName = entry.key;
          final imageList = entry.value;
          final String? imagePath = imageList.isNotEmpty
              ? imageList.first
              : null;

          return _buildCategoryCard(categoryName, imagePath);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String? imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryMealsPage(
              categoryName: title,
              images: categories[title]!,
            ),
          ),
        );
      },
      child: Container(
        width: 80.w,
        height: 85.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath == null)
              Icon(
                Icons.category,
                size: 30.h,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            else
              Image.asset(imagePath, width: 30.w, height: 30.h),

            SizedBox(height: 8.h),
            Text(
              title.replaceAll('_', ' '),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
