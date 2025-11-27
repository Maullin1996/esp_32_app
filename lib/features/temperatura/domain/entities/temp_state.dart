import 'package:freezed_annotation/freezed_annotation.dart';

part 'temp_state.freezed.dart';

@freezed
abstract class TempState with _$TempState {
  const factory TempState({
    @Default('') String espIp,
    @Default(0.0) double temperature,
    @Default("off") String mode,
    @Default(40.0) double manualTarget,
    @Default(30.0) double rangeMin,
    @Default(35.0) double rangeMax,
    @Default(false) bool heaterOn,
    @Default(false) bool isLoading,
    String? error,
  }) = _TempState;

  factory TempState.initial() => const TempState();
}
