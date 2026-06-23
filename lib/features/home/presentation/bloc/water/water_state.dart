abstract class WaterState {
  const WaterState();
}

class WaterInitial extends WaterState {}

class WaterLoaded extends WaterState {
  final int totalMl;
  final int goalMl;

  const WaterLoaded({required this.totalMl, required this.goalMl});

  double get progress => (totalMl / goalMl).clamp(0.0, 1.0);
  int get remaining => (goalMl - totalMl).clamp(0, goalMl);
}
