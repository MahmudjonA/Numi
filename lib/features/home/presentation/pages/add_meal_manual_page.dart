import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/constants/food_calories.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/core/widgets/path_generater.dart';
import 'package:numi/features/home/domain/entities/custom_food.dart';
import 'package:numi/features/home/domain/entities/meal.dart';
import 'package:numi/features/home/presentation/bloc/custom_food/custom_food_bloc.dart';
import 'package:numi/features/home/presentation/bloc/custom_food/custom_food_event.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_bloc.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_event.dart';

const _kCategories = [
  'Fruits', 'Vegetables', 'Bread', 'Meat', 'Seafood',
  'Eggs', 'Drinks', 'Fast_Food', 'Sweets', 'Dairy_Products', 'Grains',
];

const _kEmojis = {
  'Fruits': '🍎', 'Vegetables': '🥕', 'Bread': '🍞', 'Meat': '🍗',
  'Seafood': '🐟', 'Eggs': '🥚', 'Drinks': '🥤', 'Fast_Food': '🍔',
  'Sweets': '🍰', 'Dairy_Products': '🥛', 'Grains': '🌾',
};

class AddMealManualPage extends StatefulWidget {
  final bool initSaveToLibrary;
  const AddMealManualPage({super.key, this.initSaveToLibrary = false});

  @override
  State<AddMealManualPage> createState() => _AddMealManualPageState();
}

class _AddMealManualPageState extends State<AddMealManualPage> {
  final _nameCtrl    = TextEditingController();
  final _calCtrl     = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _carbsCtrl   = TextEditingController();
  final _fatCtrl     = TextEditingController();
  final _portionCtrl = TextEditingController();

  MealType _mealType         = MealType.Snack;
  bool     _saveToLibrary    = false;
  String?  _selectedCategory;
  Map<String, List<String>> _categoryAssets = {};

  @override
  void initState() {
    super.initState();
    _saveToLibrary = widget.initSaveToLibrary;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await loadCategoryAssets();
    if (mounted) setState(() => _categoryAssets = data);
  }

  String? _getFirstImage(String category) {
    final imgs = _categoryAssets[category];
    return (imgs != null && imgs.isNotEmpty) ? imgs.first : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _calCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    _portionCtrl.dispose();
    super.dispose();
  }

  void _autofill() {
    final info = getFoodInfo(_nameCtrl.text);
    if (info != null) {
      _calCtrl.text     = info.calories.toString();
      _proteinCtrl.text = info.proteinG.toString();
      _carbsCtrl.text   = info.carbsG.toString();
      _fatCtrl.text     = info.fatG.toString();
    }
  }

  void _save() {
    final s        = S.of(context);
    final name     = _nameCtrl.text.trim();
    final calories = int.tryParse(_calCtrl.text);

    if (name.isEmpty || calories == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.nameCalRequired)),
      );
      return;
    }

    if (_saveToLibrary && _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.selectCategoryLbl)),
      );
      return;
    }

    final protein = double.tryParse(_proteinCtrl.text) ?? 0.0;
    final carbs   = double.tryParse(_carbsCtrl.text) ?? 0.0;
    final fat     = double.tryParse(_fatCtrl.text) ?? 0.0;
    final portion = double.tryParse(_portionCtrl.text);
    final imgPath = _selectedCategory != null
        ? _getFirstImage(_selectedCategory!)
        : null;

    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      calories: calories,
      category: _selectedCategory ?? 'Custom',
      dateTime: DateTime.now(),
      mealType: _mealType,
      imagePath: imgPath,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      portionGrams: portion,
      isCustom: true,
    );

    context.read<MealBloc>().add(AddMealEvent(meal: meal));

    if (_saveToLibrary) {
      final customFood = CustomFood(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        calories: calories,
        proteinG: protein,
        carbsG: carbs,
        fatG: fat,
        category: _selectedCategory ?? 'Custom',
      );
      context.read<CustomFoodBloc>().add(AddCustomFoodEvent(food: customFood));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.foodAddedSnack(name, calories))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.addMealPageTitle,
            style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Kategoriya (kutubxonaga saqlayotganda — birinchi ko'rinadi) ──
            if (_saveToLibrary) ...[
              _label('${s.selectCategoryLbl} *'),
              SizedBox(
                height: 80.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _kCategories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (_, i) {
                    final cat      = _kCategories[i];
                    final emoji    = _kEmojis[cat] ?? '🍽️';
                    final selected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 68.w,
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : (_selectedCategory == null
                                    ? Colors.red.withValues(alpha: 0.3)
                                    : Colors.transparent),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(emoji, style: TextStyle(fontSize: 22.sp)),
                            SizedBox(height: 4.h),
                            Text(
                              s.categoryName(cat),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // ── Nomi ─────────────────────────────────────
            _label(s.foodNameLabel),
            _field(
              controller: _nameCtrl,
              hint: s.foodNameHint,
              onChanged: (_) => _autofill(),
            ),
            SizedBox(height: 16.h),

            // ── Kaloriya ─────────────────────────────────
            _label(s.caloriesLabel),
            _field(controller: _calCtrl, hint: "200", isNumber: true),
            SizedBox(height: 16.h),

            // ── Makrolar ─────────────────────────────────
            _label(s.macrosLabel),
            Row(
              children: [
                Expanded(
                  child: _field(controller: _proteinCtrl, hint: "Protein g", isNumber: true),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _field(controller: _carbsCtrl, hint: "Carbs g", isNumber: true),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _field(controller: _fatCtrl, hint: "Fat g", isNumber: true),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Porsiya ──────────────────────────────────
            _label(s.portionLabel),
            _field(controller: _portionCtrl, hint: "100", isNumber: true),
            SizedBox(height: 20.h),

            // ── Ovqat turi ───────────────────────────────
            _label(s.mealTypeLabel),
            _card(
              child: Row(
                children: MealType.values.map((t) {
                  final selected = _mealType == t;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _mealType = t),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          _mealTypeLabel(s, t),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: selected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : null,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Kutubxonaga saqlash ───────────────────────
            _card(
              child: CheckboxListTile(
                value: _saveToLibrary,
                onChanged: (v) => setState(() {
                  _saveToLibrary = v ?? false;
                  if (!_saveToLibrary) _selectedCategory = null;
                }),
                title: Text(
                  s.saveToMyFoodsLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),

            SizedBox(height: 24.h),

            // ── Saqlash ───────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  s.addBtnLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _mealTypeLabel(S s, MealType t) {
    switch (t) {
      case MealType.Breakfast: return s.breakfast;
      case MealType.Lunch:     return s.lunch;
      case MealType.Dinner:    return s.dinner;
      case MealType.Snack:     return s.snack;
    }
  }

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool isNumber = false,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.labelMedium,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: child,
      );
}
