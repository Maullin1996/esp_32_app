import 'package:freezed_annotation/freezed_annotation.dart';

part 'vent_state.freezed.dart';

@freezed
abstract class VentState with _$VentState {
  const factory VentState({
    @Default('') String espIp,
    @Default(<double>[]) List<double> temps,
    @Default(<bool>[]) List<bool> fans,
    @Default(<String>[]) List<String> names, // ← NOMBRES
    @Default(24.0) double rangeMin,
    @Default(28.0) double rangeMax,
    @Default(false) bool autoEnabled,
    @Default(false) bool isLoading,
    String? error,
  }) = _VentState;

  factory VentState.initial() => const VentState();
}
