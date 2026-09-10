# Numi 🍎

**Smart Nutrition, Calorie & Health Tracker**

Numi is a Flutter mobile app that helps you track your food, calories, macronutrients, water intake and weight — all stored locally on your device. It combines AI-powered food recognition with a manual food log and a personal food library, and visualizes your progress with charts. The app is built on **Clean Architecture** with the **BLoC** pattern and works fully offline (except for AI photo recognition).

---

## ✨ Features

- 📷 **AI food recognition** — snap a photo of a meal and let the [Clarifai](https://www.clarifai.com/) `food-item-recognition` model identify it, then auto-fill calories and macros from the local food database.
- ✍️ **Manual meal logging** — add meals by hand with calories, protein / carbs / fat, portion size and meal type (Breakfast, Lunch, Dinner, Snack).
- 📚 **Personal food library** — save your own foods (`CustomFood`) and quickly add them to any meal.
- 🎯 **Daily calorie goal** — calculated from your body metrics using the **Mifflin–St Jeor BMR** formula and activity level.
- 📊 **Daily progress** — track consumed vs. goal calories plus protein / carbs / fat macro bars.
- 🕓 **Meal history** — browse the last 30 days grouped by day, filterable by meal type.
- 📈 **Statistics** — weekly calorie bar chart and macro breakdown (via `fl_chart`).
- ⚖️ **Weight tracking** — log your weight over time and view it on a line chart with trend summaries.
- 💧 **Water intake tracking** — quick +250 ml / +500 ml buttons toward a daily 2000 ml goal.
- 🌗 **Light / Dark theme** — toggle at runtime.
- 🌍 **Multi-language** — Uzbek 🇺🇿, Russian 🇷🇺 and English 🇬🇧, switchable at runtime.
- 💾 **Offline-first** — all data persisted locally with **Hive** (no account required).

---

## 🛠 Tech Stack

| Area | Technology |
|------|------------|
| Framework | Flutter / Dart (SDK `^3.9.2`) |
| State management | `flutter_bloc` |
| Dependency injection | `get_it` |
| Local storage | `hive`, `hive_flutter` |
| Networking | `dio` (Clarifai API) |
| Charts | `fl_chart` |
| Responsive UI | `flutter_screenutil` |
| Fonts / Icons | `google_fonts`, `cupertino_icons` |
| Image capture | `image_picker` |
| Logging | `logger` |
| Codegen (dev) | `build_runner`, `hive_generator` |

---

## 🏗 Architecture

Numi follows **Clean Architecture**, separating each feature into `data`, `domain` and `presentation` layers. State is driven by BLoCs and dependencies are wired through a central service locator (`get_it`).

```
lib/
 ├── main.dart                  # App entry point (theme, screenutil, DI setup)
 ├── bloc_provider.dart         # MultiBlocProvider for all BLoCs
 ├── bottom_nav_bar.dart        # 4-tab bottom navigation + central camera FAB
 │
 ├── core/
 │    ├── di/                   # service_locator.dart (get_it registrations)
 │    ├── dio/                  # DioClient (Clarifai HTTP client)
 │    ├── l10n/                 # app_strings.dart — uz / ru / en localization
 │    ├── settings/             # AppSettings (theme + language, Hive-backed)
 │    ├── theme/                # light / dark themes, colors
 │    ├── constants/            # food_calories.dart (local food DB), extensions
 │    └── widgets/              # shared widgets
 │
 └── features/home/
      ├── data/
      │    ├── data_sources/
      │    │    ├── local/      # Hive data sources (meals, body, water, weight, custom foods)
      │    │    └── remote/     # Clarifai food-prediction data source
      │    ├── models/          # Hive models + generated .g.dart adapters
      │    └── repositories/    # repository implementations
      │
      ├── domain/
      │    ├── entities/        # meal, user_body_info, custom_food, weight_entry, water_intake
      │    ├── repositories/    # repository contracts
      │    └── use_cases/       # add/get/delete meals, BMR calc, grouping, predictions...
      │
      └── presentation/
           ├── bloc/            # 6 BLoCs (see below)
           ├── pages/           # screens
           └── widgets/         # UI widgets
```

### BLoCs

| BLoC | Responsibility |
|------|----------------|
| `MealBloc` | Meal CRUD and daily/day-grouped queries |
| `FoodPredictionBloc` | Clarifai AI photo recognition flow |
| `UserBodyInfoBloc` | Body metrics + daily calorie calculation |
| `CustomFoodBloc` | Personal food library |
| `WeightBloc` | Weight history |
| `WaterBloc` | Daily water intake |

### Local storage (Hive)

Each model has a stable `typeId` — **keep the order when adding new features**:

| typeId | Model | Box |
|--------|-------|-----|
| 0 | `MealModel` | `meals` |
| 1 | `UserBodyInfoModel` | `user_body` |
| 2 | `CustomFoodModel` | `custom_foods` |
| 3 | `WeightEntryModel` | `weight_entries` |
| 4 | `WaterIntakeModel` | `water_intake` |

App settings (theme mode, language) are stored in a separate `settings` box.

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Home** | Daily calories card, weight mini widget, water widget, category shortcuts, today's meals |
| **Meal History** | Last 30 days grouped by day, meal-type filter chips |
| **My Foods** | Personal food library — search, add to meal, delete |
| **Statistics** | Calorie tab (weekly bar chart + macros) and Weight tab (line chart) |
| **Daily Calories** | BMR form: weight, height, age, gender, activity level |
| **Add Meal (Manual)** | Manual entry with autofill from the food database, optional save to library |
| **Category Meals** | Foods listed per category from assets |

Navigation is a 4-tab bottom bar (**Home / History / Mine / Statistics**) with a central camera **FAB** that triggers AI food recognition.

---

## 🧮 Daily Calorie Logic (Mifflin–St Jeor)

Daily calorie needs are computed in `CalculateDailyCaloriesUseCase`:

```
BMR = 10 × weight(kg) + 6.25 × height(cm) − 5 × age
    + 5    (male)
    − 161  (female)

Daily calories = BMR × activity multiplier
```

| Activity level | Multiplier |
|----------------|-----------|
| Sedentary | 1.20 |
| Light | 1.375 |
| Moderate | 1.55 |
| Active | 1.725 |
| Very Active | 1.90 |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Dart `^3.9.2`)
- A Clarifai API key (optional — a default key is bundled for quick testing)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/numi.git
   cd numi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (only needed if you change the models)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Providing your Clarifai API key

The AI recognition feature reads the key from a compile-time environment variable, falling back to a bundled default. To use your own key:

```bash
flutter run --dart-define=CLARIFAI_API_KEY=your_api_key_here
```

The Clarifai model used is `food-item-recognition` (version `1d5fd481e0cf4826aa72ec3ff049e044`).

---

## 🎨 Design

Figma: [Numi Design](https://www.figma.com/design/jmycZ1DY3OkZTsSTd8WHmX/Numi?node-id=0-1&p=f&t=VFiJwUO66NpkkThf-0)

---

## 🔮 Roadmap

- Configurable macro goals per user (currently defaults: 50 g protein / 250 g carbs / 65 g fat)
- Cloud sync & backup
- Notifications and reminders
- Expanded local food database
- iOS release

---

## 👨‍💻 Author

**Makhmudjon**
Built with Flutter • Clean Architecture • BLoC
