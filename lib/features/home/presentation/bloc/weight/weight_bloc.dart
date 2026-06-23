import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/weight_entry.dart';
import '../../../domain/use_cases/add_weight_entry_use_case.dart';
import '../../../domain/use_cases/delete_weight_entry_use_case.dart';
import '../../../domain/use_cases/get_weight_history_use_case.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final AddWeightEntryUseCase addUseCase;
  final GetWeightHistoryUseCase getUseCase;
  final DeleteWeightEntryUseCase deleteUseCase;

  WeightBloc(this.addUseCase, this.getUseCase, this.deleteUseCase)
      : super(WeightInitial()) {
    on<LoadWeightHistoryEvent>((event, emit) async {
      emit(WeightLoading());
      try {
        final entries = await getUseCase(days: 7);
        emit(WeightLoaded(entries: entries));
      } catch (e) {
        emit(WeightError(message: e.toString()));
      }
    });

    on<AddWeightEntryEvent>((event, emit) async {
      try {
        final entry = WeightEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          weightKg: event.weightKg,
          dateTime: event.dateTime,
          note: event.note,
        );
        await addUseCase(entry);
        final entries = await getUseCase(days: 7);
        emit(WeightLoaded(entries: entries));
      } catch (e) {
        emit(WeightError(message: e.toString()));
      }
    });

    on<DeleteWeightEntryEvent>((event, emit) async {
      try {
        await deleteUseCase(event.id);
        final entries = await getUseCase(days: 7);
        emit(WeightLoaded(entries: entries));
      } catch (e) {
        emit(WeightError(message: e.toString()));
      }
    });
  }
}
