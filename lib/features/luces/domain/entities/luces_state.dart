import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';

part 'luces_state.freezed.dart';

@freezed
abstract class LucesState with _$LucesState {
  const factory LucesState({
    required String espIp,
    required List<bool> relays,
    required bool isSending,
    String? error,
  }) = _LucesState;

  factory LucesState.initial() => LucesState(
    espIp: '',
    relays: List<bool>.filled(AppConstants.relaysCount, false),
    isSending: false,
    error: null,
  );
}
