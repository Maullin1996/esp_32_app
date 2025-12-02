import 'package:freezed_annotation/freezed_annotation.dart';

part 'temp_state.freezed.dart';
part 'temp_state.g.dart';

@freezed
class TempState with _$TempState {
  const factory TempState({
    @Default('') String espIp,
    @Default(0.0) double temperature,
    @Default(30.0) double rangeMin,
    @Default(35.0) double rangeMax,
    @Default(false) bool autoEnabled,
    @Default(false) bool forcedOff,
    @Default(false) bool heaterOn,
    @Default(false) bool isLoading,
    String? error,
  }) = _TempState;

  factory TempState.initial() => const TempState();

  factory TempState.fromJson(Map<String, dynamic> json) =>
      _$TempStateFromJson(json);
}
