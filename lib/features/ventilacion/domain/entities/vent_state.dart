import 'package:freezed_annotation/freezed_annotation.dart';

part 'vent_state.freezed.dart';
part 'vent_state.g.dart';

@freezed
abstract class VentState with _$VentState {
  const factory VentState({
    @Default('') String espIp,
    @Default(0.0) double temperature,
    @Default(24.0) double rangeMin,
    @Default(28.0) double rangeMax,
    @Default(false) bool fanOn,
    @Default(false) bool autoEnabled,
    @Default(false) bool isLoading,
    String? error,
  }) = _VentState;

  factory VentState.initial() => const VentState();

  factory VentState.fromJson(Map<String, dynamic> json) =>
      _$VentStateFromJson(json);
}
