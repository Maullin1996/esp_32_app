import 'dart:async';

import 'package:esp32_app/features/temperatura/domain/entities/temp_state.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/force_off_usecase.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/get_status_usecase.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/set_range_usecase.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/toggle_auto_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TempController extends StateNotifier<TempState> {
  TempController(
    this._getStatus,
    this._setRange,
    this._toggleAuto,
    this._forceOff,
  ) : super(TempState.initial());

  final GetStatusUsecase _getStatus;
  final SetRangeUsecase _setRange;
  final ToggleAutoUsecase _toggleAuto;
  final ForceOffUsecase _forceOff;

  Timer? _timer;

  void setIp(String ip) {
    state = state.copyWith(espIp: ip);
    startPolling();
  }

  void startPolling() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final ip = state.espIp.trim();
      if (ip.isEmpty) return;

      final r = await _getStatus(ip);

      r.when(
        success: (data) {
          state = state.copyWith(
            temperature: data.temperature,
            rangeMin: data.rangeMin,
            rangeMax: data.rangeMax,
            autoEnabled: data.autoEnabled,
            forcedOff: data.forcedOff,
            heaterOn: data.heaterOn,
            error: null,
          );
        },
        failure: (msg) {
          state = state.copyWith(error: msg);
        },
      );
    });
  }

  Future<void> applyRange(double min, double max) async {
    final ip = state.espIp;
    if (ip.isEmpty) return;
    state = state.copyWith(isLoading: true, error: null);

    final r = await _setRange(ip: ip, min: min, max: max);

    state = state.copyWith(isLoading: false);

    r.when(
      success: (_) {
        state = state.copyWith(rangeMin: min, rangeMax: max);
      },
      failure: (msg) {
        state = state.copyWith(error: msg);
      },
    );
  }

  Future<void> toggleAuto() async {
    final ip = state.espIp;
    if (ip.isEmpty) return;

    final newEnabled = !state.autoEnabled;

    final r = await _toggleAuto(ip: ip, enabled: newEnabled);

    r.when(
      success: (_) {
        state = state.copyWith(autoEnabled: newEnabled, forcedOff: false);
      },
      failure: (msg) {
        state = state.copyWith(error: msg);
      },
    );
  }

  Future<void> forceOff() async {
    final ip = state.espIp;
    if (ip.isEmpty) return;

    final r = await _forceOff(ip);

    r.when(
      success: (_) {
        state = state.copyWith(
          heaterOn: false,
          forcedOff: true,
          autoEnabled: false,
        );
      },
      failure: (msg) {
        state = state.copyWith(error: msg);
      },
    );
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
