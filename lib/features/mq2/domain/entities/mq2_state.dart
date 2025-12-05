// lib/features/mq2/domain/entities/mq2_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mq2_state.freezed.dart';
part 'mq2_state.g.dart';

@freezed
abstract class Mq2State with _$Mq2State {
  const factory Mq2State({
    @Default('') String espIp,
    @Default(0) int ppm,
    @Default(false) bool autoOn,
    @Default(false) bool alarmOn,
    @Default(200) int lowTh,
    @Default(500) int highTh,
    @Default(true) bool sensingOn,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? error,
  }) = _Mq2State;

  factory Mq2State.initial() => const Mq2State();

  factory Mq2State.fromJson(Map<String, dynamic> json) =>
      _$Mq2StateFromJson(json);
}
