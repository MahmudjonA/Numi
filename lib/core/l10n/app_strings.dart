import 'package:flutter/material.dart';
import '../settings/app_settings.dart';

class S {
  final String _l;
  const S(this._l);

  static S of(BuildContext context) => S(AppSettings.of(context).lang);

  // ignore: non_constant_identifier_names
  String _t(String uz, String en, String ru) {
    if (_l == 'en') return en;
    if (_l == 'ru') return ru;
    return uz;
  }

  // ── Navigation ────────────────────────────────────────────────────────────
  String get navHome    => _t('Bosh',       'Home',       'Главная');
  String get navHistory => _t('Tarix',      'History',    'История');
  String get navMine    => _t('Mening',     'Mine',       'Мои');
  String get navStats   => _t('Statistika', 'Statistics', 'Статистика');

  // ── AppBar ────────────────────────────────────────────────────────────────
  String get appTitle => 'Numi';

  // ── Home page ─────────────────────────────────────────────────────────────
  String get categories   => _t('Kategoriyalar',    'Categories',   'Категории');
  String get todayMeals   => _t('Bugungi ovqatlar', "Today's Meals",'Сегодняшняя еда');
  String get analyzing    => _t('Rasm tahlil qilinmoqda...', 'Analyzing image...', 'Анализ изображения...');
  String addedAI(String name, int kcal) =>
      _t("$name qo'shildi ($kcal kcal)", "$name added ($kcal kcal)", "$name добавлено ($kcal ккал)");
  String get addManualBtn => _t("Qo'lda qo'shish", 'Add manually', 'Добавить вручную');

  // ── Meal Types ────────────────────────────────────────────────────────────
  String get breakfast => _t('Nonushta',     'Breakfast', 'Завтрак');
  String get lunch     => _t('Tushlik',      'Lunch',     'Обед');
  String get dinner    => _t('Kechki ovqat', 'Dinner',    'Ужин');
  String get snack     => _t('Snack',        'Snack',     'Перекус');

  String get breakfastTime => '06:00 – 10:00';
  String get lunchTime     => '12:00 – 15:00';
  String get dinnerTime    => '18:00 – 21:00';
  String get anyTime       => _t('Istalgan vaqt', 'Any time', 'В любое время');

  // ── Category display names ────────────────────────────────────────────────
  String categoryName(String key) {
    const uz = {
      'Fruits': 'Mevalar', 'Vegetables': 'Sabzavotlar', 'Bread': 'Non',
      'Meat': "Go'sht", 'Seafood': 'Dengiz mahsulotlari', 'Eggs': 'Tuxum',
      'Drinks': 'Ichimliklar', 'Fast_Food': 'Tez taom', 'Sweets': 'Shirinliklar',
      'Dairy_Products': 'Sut mahsulotlari', 'Grains': 'Don',
    };
    const en = {
      'Fruits': 'Fruits', 'Vegetables': 'Vegetables', 'Bread': 'Bread',
      'Meat': 'Meat', 'Seafood': 'Seafood', 'Eggs': 'Eggs',
      'Drinks': 'Drinks', 'Fast_Food': 'Fast Food', 'Sweets': 'Sweets',
      'Dairy_Products': 'Dairy', 'Grains': 'Grains',
    };
    const ru = {
      'Fruits': 'Фрукты', 'Vegetables': 'Овощи', 'Bread': 'Хлеб',
      'Meat': 'Мясо', 'Seafood': 'Морепродукты', 'Eggs': 'Яйца',
      'Drinks': 'Напитки', 'Fast_Food': 'Фастфуд', 'Sweets': 'Сладости',
      'Dairy_Products': 'Молочные', 'Grains': 'Злаки',
    };
    if (_l == 'en') return en[key] ?? key.replaceAll('_', ' ');
    if (_l == 'ru') return ru[key] ?? key.replaceAll('_', ' ');
    return uz[key] ?? key.replaceAll('_', ' ');
  }

  // ── LastMealWg ────────────────────────────────────────────────────────────
  String get noMealsYet  => _t("Hali ovqat qo'shilmagan", 'No meals yet', 'Блюда не добавлены');
  String mealsCount(int n) => _t('$n ta ovqat', '$n meals', '$n блюд');

  // ── MealTypePicker ────────────────────────────────────────────────────────
  String get addToMeal => _t("Qaysi ovqatga qo'shilsin?", 'Add to which meal?', 'К какому приёму пищи?');

  // ── MealPage ──────────────────────────────────────────────────────────────
  String get mealHistoryTitle => _t('Ovqat tarixi', 'Meal History',    'История питания');
  String get myFoodsTitle     => _t('Mening ovqatlarim', 'My Foods',    'Мои продукты');
  String get all              => _t('Barchasi',  'All',               'Все');
  String get noMealsHint      => _t("Kamera yoki + tugmasini bosing", 'Use camera or + button', 'Используйте камеру или кнопку +');
  String get today            => _t('Bugun',     'Today',             'Сегодня');
  String get yesterday        => _t('Kecha',     'Yesterday',         'Вчера');
  String get noFoodCategory   => _t("Bu kategoriyada ovqat yo'q", 'No foods in this category', 'В этой категории нет продуктов');

  // ── Stats page ────────────────────────────────────────────────────────────
  String get statsTitle      => _t('Statistika',        'Statistics',   'Статистика');
  String get caloriesTab     => _t('Kaloriya',          'Calories',     'Калории');
  String get weightTab       => _t('Vazn',              'Weight',       'Вес');
  String get thisWeek        => _t('Bu hafta',          'This week',    'Эта неделя');
  String get lastWeek        => _t("O'tgan hafta",      'Last week',    'Прошлая неделя');
  String get totalWeek       => _t('Jami (hafta)',      'Total (week)', 'Итого (неделя)');
  String get avgDay          => _t("O'rtacha (kun)",    'Avg (day)',    'Среднее (день)');
  String get goalDay         => _t('Maqsad (kun)',      'Goal (day)',   'Цель (день)');
  String get weeklyMacros    => _t('Haftalik makrolar', 'Weekly macros','Нед. макросы');

  List<String> get weekDays => _l == 'en'
      ? ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
      : _l == 'ru'
          ? ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
          : ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];

  // ── Snackbar ──────────────────────────────────────────────────────────────
  String foodAdded(String name, String typeLabel, int kcal) =>
      _t("$name ($typeLabel) — $kcal kcal", "$name ($typeLabel) — $kcal kcal", "$name ($typeLabel) — $kcal ккал");
}
