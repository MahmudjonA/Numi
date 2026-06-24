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
  String get addToCategory => _t("Kategoriyaga qo'shish", 'Add to category', 'Добавить в категорию');

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
  String get noMealsHint      => _t("+ tugmasini bosing", 'Use + button', 'Используйте кнопку +');
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

  // ── Daily Calories Page ───────────────────────────────────────────────────
  String get dailyCalTitle      => _t('Kunlik kaloriya', 'Daily Calories', 'Ежедневные калории');
  String get yourBody           => _t('Tanangiz', 'Your body', 'Ваше тело');
  String get weightKgHint       => _t('Vazn (kg)', 'Weight (kg)', 'Вес (кг)');
  String get heightCmHint       => _t("Bo'y (sm)", 'Height (cm)', 'Рост (см)');
  String get ageHint            => _t('Yosh', 'Age', 'Возраст');
  String get genderLabel        => _t('Jinsi', 'Gender', 'Пол');
  String get activityLevelLabel => _t('Faollik darajasi', 'Activity level', 'Уровень активности');
  String get saveAndCalc        => _t('Saqlash va hisoblash', 'Save & Calculate', 'Сохранить и рассчитать');

  // ── Add Meal Page ─────────────────────────────────────────────────────────
  String get addMealPageTitle   => _t("Ovqat qo'shish", 'Add Meal', 'Добавить блюдо');
  String get foodNameLabel      => _t('Ovqat nomi *', 'Food name *', 'Название блюда *');
  String get foodNameHint       => _t('Masalan: Tuxum', 'E.g.: Egg', 'Например: Яйцо');
  String get caloriesLabel      => _t('Kaloriya (kcal) *', 'Calories (kcal) *', 'Калории (ккал) *');
  String get macrosLabel        => _t('Makrolar (ixtiyoriy)', 'Macros (optional)', 'Макросы (необязательно)');
  String get portionLabel       => _t('Porsiya (gramm, ixtiyoriy)', 'Portion (grams, optional)', 'Порция (г, необязательно)');
  String get mealTypeLabel      => _t('Ovqat turi', 'Meal type', 'Тип приёма пищи');
  String get saveToMyFoodsLabel => _t("Mening ovqatlarimga saqlash", 'Save to my foods', 'Сохранить в мои продукты');
  String get selectCategoryLbl  => _t('Kategoriya tanlang', 'Select category', 'Выберите категорию');
  String get addBtnLabel        => _t("Qo'shish", 'Add', 'Добавить');
  String get nameCalRequired    => _t('Ism va kaloriya majburiy!', 'Name and calories required!', 'Имя и калории обязательны!');
  String foodAddedSnack(String name, int kcal) =>
      _t("$name qo'shildi ($kcal kcal)", "$name added ($kcal kcal)", "$name добавлено ($kcal ккал)");

  // ── Weight History Page ───────────────────────────────────────────────────
  String get weightHistoryTitle   => _t('Vazn tarixi', 'Weight History', 'История веса');
  String get weightRecords        => _t('Yozuvlar', 'Records', 'Записи');
  String get noWeightYet          => _t("Hali vazn kiritilmagan\n+ tugmasini bosing", 'No records yet\nPress + to add', 'Записей нет\nНажмите + для добавления');
  String get addWeightDialogTitle => _t('Vazn kiriting', 'Add weight', 'Добавить вес');
  String get weightHint           => _t('Vazn (kg)', 'Weight (kg)', 'Вес (кг)');
  String get noteHint             => _t('Masalan: Ertalab', 'E.g.: Morning', 'Например: Утром');
  String get noteOptional         => _t('Izoh (ixtiyoriy)', 'Note (optional)', 'Примечание (необязательно)');
  String get weightRangeError     => _t("Vazn 20–300 kg oralig'ida bo'lishi kerak", 'Weight must be 20–300 kg', 'Вес должен быть 20–300 кг');
  String get currentWeightLabel   => _t('Hozirgi', 'Current', 'Текущий');
  String get weekChangeLabel      => _t("O'zgarish (7 kun)", '7-day change', 'Изм. за 7 дней');
  String get averageWeightLabel   => _t("O'rtacha", 'Average', 'Среднее');
  String get saveBtn              => _t('Saqlash', 'Save', 'Сохранить');
  String get cancelBtn            => _t('Bekor', 'Cancel', 'Отмена');
  String get todayWeightTitle     => _t('Bugungi vazn', "Today's weight", 'Вес сегодня');

  // ── Daily Calories Card ───────────────────────────────────────────────────
  String get dailyCaloriesCard => _t('Kunlik kaloriya', 'Daily calories', 'Ежедневные калории');
  String get noGoalLabel       => _t("Maqsad yo'q", 'No goal set', 'Цель не задана');
  String kcalLeft(int n)       => _t('$n kcal qoldi', '$n kcal left', '$n ккал осталось');

  // ── Water Widget ──────────────────────────────────────────────────────────
  String get waterLabel => _t('Suv', 'Water', 'Вода');

  // ── Weight Mini Widget ────────────────────────────────────────────────────
  String get weightMiniLabel => _t('Vazn', 'Weight', 'Вес');
  String get addWeightBtn    => _t('+ Kiriting', '+ Add', '+ Добавить');

  // ── Banner ────────────────────────────────────────────────────────────────
  String get bannerTitle => _t("Sog'lom turmush\ntarzi boshlanadi", 'Healthy lifestyle\nstarts here', 'Здоровый образ\nжизни начинается');
  String get bannerCta   => _t('Bugun kuzat →', 'Track today →', 'Отслеживай →');

  // ── My Foods Page ─────────────────────────────────────────────────────────
  String get myFoodsPageTitle    => _t("Mening ovqatlarim", 'My Foods', 'Мои продукты');
  String get searchFoodHint      => _t('Ovqat qidirish...', 'Search food...', 'Поиск...');
  String get foodNotFound        => _t('Ovqat topilmadi', 'Food not found', 'Продукт не найден');
  String get addNewFood          => _t("+ Yangi qo'shish", '+ Add new', '+ Добавить новый');
  String get mealTypeDialogTitle => _t("Ovqat turi", 'Meal type', 'Тип приёма пищи');
}
