abstract class WaterEvent {
  const WaterEvent();
}

class LoadWaterEvent extends WaterEvent {}

class AddWaterEvent extends WaterEvent {
  final int ml;
  const AddWaterEvent({this.ml = 250});
}

class ResetWaterEvent extends WaterEvent {}
