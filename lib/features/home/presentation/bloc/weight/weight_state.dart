import '../../../domain/entities/weight_entry.dart';

abstract class WeightState {
  const WeightState();
}

class WeightInitial extends WeightState {}

class WeightLoading extends WeightState {}

class WeightLoaded extends WeightState {
  final List<WeightEntry> entries;

  const WeightLoaded({required this.entries});

  WeightEntry? get latest => entries.isNotEmpty ? entries.last : null;

  WeightEntry? get oldest => entries.isNotEmpty ? entries.first : null;

  double? get change {
    if (entries.length < 2) return null;
    return entries.last.weightKg - entries.first.weightKg;
  }

  double? get average {
    if (entries.isEmpty) return null;
    final sum = entries.fold(0.0, (s, e) => s + e.weightKg);
    return sum / entries.length;
  }
}

class WeightError extends WeightState {
  final String message;
  const WeightError({required this.message});
}
