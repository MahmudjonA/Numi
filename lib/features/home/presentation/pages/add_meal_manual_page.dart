import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/constants/food_calories.dart';
import 'package:numi/features/home/domain/entities/custom_food.dart';
import 'package:numi/features/home/domain/entities/meal.dart';
import 'package:numi/features/home/presentation/bloc/custom_food/custom_food_bloc.dart';
import 'package:numi/features/home/presentation/bloc/custom_food/custom_food_event.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_bloc.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_event.dart';

class AddMealManualPage extends StatefulWidget {
  const AddMealManualPage({super.key});

  @override
  State<AddMealManualPage> createState() => _AddMealManualPageState();
}

class _AddMealManualPageState extends State<AddMealManualPage> {
  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _portionCtrl = TextEditingController();

  MealType _mealType = MealType.Snack;
  bool _saveToLibrary = false;

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
      _calCtrl.text = info.calories.toString();
      _proteinCtrl.text = info.proteinG.toString();
      _carbsCtrl.text = info.carbsG.toString();
      _fatCtrl.text = info.fatG.toString();
    }
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    final calories = int.tryParse(_calCtrl.text);

    if (name.isEmpty || calories == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ism va kaloriya majburiy!")),
      );
      return;
    }

    final protein = double.tryParse(_proteinCtrl.text) ?? 0.0;
    final carbs = double.tryParse(_carbsCtrl.text) ?? 0.0;
    final fat = double.tryParse(_fatCtrl.text) ?? 0.0;
    final portion = double.tryParse(_portionCtrl.text);

    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      calories: calories,
      category: 'Custom',
      dateTime: DateTime.now(),
      mealType: _mealType,
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
        category: 'Custom',
      );
      context.read<CustomFoodBloc>().add(AddCustomFoodEvent(food: customFood));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$name qo'shildi ($calories kcal)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ovqat qo'shish",
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
            // ── Nomi ─────────────────────────────────────
            _label("Ovqat nomi *"),
            _field(
              controller: _nameCtrl,
              hint: "Masalan: Tuxum",
              onChanged: (_) => _autofill(),
            ),
            SizedBox(height: 16.h),

            // ── Kaloriya ─────────────────────────────────
            _label("Kaloriya (kcal) *"),
            _field(
              controller: _calCtrl,
              hint: "200",
              isNumber: true,
            ),
            SizedBox(height: 16.h),

            // ── Makrolar ─────────────────────────────────
            _label("Makrolar (ixtiyoriy)"),
            Row(
              children: [
                Expanded(
                  child: _field(
                    controller: _proteinCtrl,
                    hint: "Protein g",
                    isNumber: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _field(
                    controller: _carbsCtrl,
                    hint: "Carbs g",
                    isNumber: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _field(
                    controller: _fatCtrl,
                    hint: "Fat g",
                    isNumber: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Porsiya ──────────────────────────────────
            _label("Porsiya (gramm, ixtiyoriy)"),
            _field(
              controller: _portionCtrl,
              hint: "100",
              isNumber: true,
            ),
            SizedBox(height: 20.h),

            // ── Ovqat turi ───────────────────────────────
            _label("Ovqat turi"),
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
                          _mealTypeLabel(t),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
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
                onChanged: (v) => setState(() => _saveToLibrary = v ?? false),
                title: Text(
                  "Mening ovqatlarimga saqlash",
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
                  "Qo'shish",
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

  String _mealTypeLabel(MealType t) {
    switch (t) {
      case MealType.Breakfast: return "Nonushta";
      case MealType.Lunch:     return "Tushlik";
      case MealType.Dinner:    return "Kechki";
      case MealType.Snack:     return "Snack";
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
