import 'package:freezed_annotation/freezed_annotation.dart';

part 'persiana_state.freezed.dart';

@freezed
class PersianaState with _$PersianaState {
  const factory PersianaState({
    @Default('') String espIp,
    @Default(0.0) double temperature,

    // Rango automático de temperatura
    @Default(24.0) double rangeMin,
    @Default(28.0) double rangeMax,

    // PWM (0–255)
    @Default(180) int pwm,

    // Tiempos para modo AUTO (ms)
    @Default(1500) int timeOpenMs,
    @Default(1500) int timeCloseMs,

    // Estado del motor segun ESP: "idle", "opening", "closing"
    @Default('idle') String motorState,

    // "none", "opened", "closed"
    @Default('none') String lastAction,

    // Modo automático ON/OFF
    @Default(false) bool autoEnabled,

    // Loading opcional
    @Default(false) bool isLoading,

    // Error opcional
    String? error,
  }) = _PersianaState;

  factory PersianaState.initial() => const PersianaState();
}
