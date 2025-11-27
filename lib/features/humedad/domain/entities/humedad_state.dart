import 'package:freezed_annotation/freezed_annotation.dart';

part 'humedad_state.freezed.dart';

@freezed
abstract class HumedadState with _$HumedadState {
  const factory HumedadState({
    @Default('') String espIp,
    @Default(0.0) double humidity,
    @Default("off") String mode,
    @Default(60.0) double manualTarget,
    @Default(30.0) double rangeMin,
    @Default(60.0) double rangeMax,
    @Default(false) bool pumpOn,
    @Default(false) bool isLoading,
    String? error,
  }) = _HumedadState;

  factory HumedadState.initial() => const HumedadState();
}
