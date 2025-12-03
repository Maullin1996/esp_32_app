import 'package:freezed_annotation/freezed_annotation.dart';

part 'humedad_state.freezed.dart';

@freezed
abstract class HumedadState with _$HumedadState {
  const factory HumedadState({
    @Default('') String espIp,

    // Valor de humedad leído (%)
    @Default(0.0) double humidity,

    // Sensado automático ON/OFF
    @Default(false) bool autoEnabled,

    // Rango de activación/desactivación
    @Default(30.0) double rangeMin,
    @Default(60.0) double rangeMax,

    // Estado actual de la bomba
    @Default(false) bool pumpOn,

    // Loading opcional para botones
    @Default(false) bool isLoading,

    // Mensajes de error
    String? error,
  }) = _HumedadState;

  factory HumedadState.initial() => const HumedadState();
}
