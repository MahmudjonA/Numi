# Numi 🍎📱

**Smart Daily Nutrition & Habit Tracker**

Numi — это мобильное приложение, которое помогает пользователям отслеживать питание, калории и ежедневные привычки. Приложение делает фокус на дисциплине, простоте и осознанном подходе к здоровому образу жизни.

---

## 🚀 Features

* 📊 **Daily calorie calculation**
* 🧍 **User body info management** (height, weight, age, activity)
* 🍽 **Meal tracking**
* ⏱ **Daily tasks & habits**
* 🔒 **Reward-based app access logic** (unlock features after completing tasks)
* 🧠 **Clean Architecture + BLoC**
* 💾 **Local data persistence**

---

## 🏗 Architecture

The project follows **Clean Architecture** principles:

```
lib/
 ├── core/
 │    ├── constants
 │    ├── errors
 │    └── utils
 │
 ├── features/
 │    └── home/
 │         ├── data/
 │         │    ├── models
 │         │    ├── repositories
 │         │    └── datasources
 │         │
 │         ├── domain/
 │         │    ├── entities
 │         │    ├── repositories
 │         │    └── use_cases
 │         │
 │         └── presentation/
 │              ├── bloc
 │              ├── pages
 │              └── widgets
```

State management is handled using **flutter_bloc**.

---

## 🛠 Tech Stack

* **Flutter (Dart)**
* **flutter_bloc**
* **Clean Architecture**
* **SOLID principles**
* **Local storage (planned / optional)**

---

## 📦 Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/numi.git
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

---

## 🧮 Example Logic

Daily calories are calculated based on:

* Gender
* Age
* Height
* Weight
* Activity level

This logic is encapsulated in a dedicated **UseCase**:

```
CalculateDailyCaloriesUseCase
```

---

## 🎯 Project Goals

* Encourage healthy daily habits
* Help users understand their calorie needs
* Build discipline through task-based rewards
* Maintain clean, scalable, and testable code

---

## 🔮 Future Plans

* Cloud sync
* Analytics & charts
* Notifications & reminders
* iOS & Android release
* AI-based food suggestions

---

👉 Figma Design:
https://www.figma.com/design/jmycZ1DY3OkZTsSTd8WHmX/Numi?node-id=0-1&p=f&t=VFiJwUO66NpkkThf-0
## 👨‍💻 Author Makhmudjon

Developed as part of the **Numi** project
Flutter • Clean Architecture • BLoC
