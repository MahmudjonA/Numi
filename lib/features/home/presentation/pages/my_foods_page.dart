import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/features/home/domain/entities/meal.dart';
import 'package:numi/features/home/presentation/bloc/custom_food/custom_food_bloc.dart';
import 'package:numi/features/home/presentation/bloc/custom_food/custom_food_event.dart';
import 'package:numi/features/home/presentation/bloc/custom_food/custom_food_state.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_bloc.dart';
import 'package:numi/features/home/presentation/bloc/meal/meal_event.dart';
import 'add_meal_manual_page.dart';

class MyFoodsPage extends StatefulWidget {
  const MyFoodsPage({super.key});

  @override
  State<MyFoodsPage> createState() => _MyFoodsPageState();
}

class _MyFoodsPageState extends State<MyFoodsPage> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<CustomFoodBloc>().add(LoadCustomFoodsEvent());
  }

  void _addToMeals(BuildContext context, customFood) {
    MealType selected = MealType.Snack;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          "Ovqat turi",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: StatefulBuilder(
          builder: (ctx, setSt) => Column(
            mainAxisSize: MainAxisSize.min,
            children: MealType.values.map((t) {
              final label = _typeLabel(t);
              return RadioListTile<MealType>(
                value: t,
                groupValue: selected,
                title: Text(label,
                    style: Theme.of(context).textTheme.bodyMedium),
                onChanged: (v) => setSt(() => selected = v!),
                activeColor: Theme.of(context).colorScheme.primary,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              final meal = Meal(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: customFood.name,
                calories: customFood.calories,
                category: customFood.category ?? 'Custom',
                dateTime: DateTime.now(),
                mealType: selected,
                proteinG: customFood.proteinG,
                carbsG: customFood.carbsG,
                fatG: customFood.fatG,
                isCustom: true,
              );
              context.read<MealBloc>().add(AddMealEvent(meal: meal));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text("${customFood.name} qo'shildi")),
              );
            },
            child: const Text("Qo'shish",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mening ovqatlarim",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddMealManualPage()),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // ── Search ───────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.r),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Ovqat qidirish...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── List ─────────────────────────────────────
          Expanded(
            child: BlocBuilder<CustomFoodBloc, CustomFoodState>(
              builder: (context, state) {
                if (state is CustomFoodLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }

                if (state is CustomFoodLoaded) {
                  final filtered = state.foods
                      .where((f) =>
                          f.name.toLowerCase().contains(_query))
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.no_food,
                              size: 48,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.4)),
                          SizedBox(height: 12.h),
                          Text(
                            "Ovqat topilmadi",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 8.h),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddMealManualPage()),
                            ),
                            child: const Text("+ Yangi qo'shish"),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final food = filtered[i];
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 4.h),
                          title: Text(
                            food.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "${food.calories} kcal  •  P:${food.proteinG.toStringAsFixed(0)}g  C:${food.carbsG.toStringAsFixed(0)}g  F:${food.fatG.toStringAsFixed(0)}g",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () =>
                                    _addToMeals(context, food),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  context.read<CustomFoodBloc>().add(
                                      DeleteCustomFoodEvent(id: food.id));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(MealType t) {
    switch (t) {
      case MealType.Breakfast: return "Nonushta";
      case MealType.Lunch:     return "Tushlik";
      case MealType.Dinner:    return "Kechki ovqat";
      case MealType.Snack:     return "Snack";
    }
  }
}
