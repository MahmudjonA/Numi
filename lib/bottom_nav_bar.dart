import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numi/features/home/presentation/bloc/food_prediction/food_prediction_event.dart';
import 'package:numi/features/home/presentation/pages/home_page.dart';
import 'package:numi/features/home/presentation/pages/meal_page.dart';

import 'features/home/presentation/bloc/food_prediction/food_prediction_bloc.dart';

class NumiBottomNav extends StatefulWidget {
  const NumiBottomNav({super.key});

  @override
  State<NumiBottomNav> createState() => _NumiBottomNavState();
}

class _NumiBottomNavState extends State<NumiBottomNav> {
  int currentIndex = 0;
  final List<Widget> pages = [HomePage(), MealPage()];

  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) return;

      final File image = File(pickedFile.path);

      // 🔥 Отправляем в BLoC, а не пишем логику здесь
      context.read<FoodPredictionBloc>().add(
        PredictFoodImageEvent(image: image),
      );
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: IndexedStack(index: currentIndex, children: pages),

      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: _openCamera,
          backgroundColor: Colors.blue,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: "Home",
                  selected: currentIndex == 0,
                  onTap: () => setState(() => currentIndex = 0),
                ),

                const SizedBox(width: 40),

                _navItem(
                  icon: Icons.timer_outlined,
                  activeIcon: Icons.timer_rounded,
                  label: "Meals",
                  selected: currentIndex == 1,
                  onTap: () => setState(() => currentIndex = 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected ? activeIcon : icon,
            size: 28,
            color: selected ? Colors.blue : Colors.black54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.black54,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
