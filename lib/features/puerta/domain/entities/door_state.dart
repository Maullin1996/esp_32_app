import 'package:freezed_annotation/freezed_annotation.dart';

part 'door_state.freezed.dart';

@freezed
class DoorState with _$DoorState {
  const factory DoorState({
    @Default('') String espIp,

    // Lectura de luz (0–100 %)
    @Default(0.0) double lux,

    // Umbral de cambio día/noche
    @Default(40) int threshold,

    // "idle", "opening", "closing"
    @Default('idle') String state,

    // 0/1 desde el ESP pero aquí como bool
    @Default(false) bool autoEnabled,

    @Default(false) bool fullyOpen,
    @Default(false) bool fullyClosed,

    @Default(false) bool isLoading,
    String? error,
  }) = _DoorState;

  factory DoorState.initial() => const DoorState();
}
