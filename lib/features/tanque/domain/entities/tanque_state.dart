import 'package:freezed_annotation/freezed_annotation.dart';

part 'tanque_state.freezed.dart';

@freezed
abstract class TanqueState with _$TanqueState {
  const factory TanqueState({
    @Default('') String espIp,
    @Default(0.0) double level, // % de nivel del tanque
    @Default(0.0) double distanceCm, // distancia en cm
    @Default("off") String mode, // off | manual | range
    @Default(90.0) double manualTarget,
    @Default(20.0) double rangeMin,
    @Default(90.0) double rangeMax,
    @Default(false) bool pumpOn,
    @Default(false) bool isLoading,
    String? error,
  }) = _TanqueState;

  factory TanqueState.initial() => const TanqueState();
}
