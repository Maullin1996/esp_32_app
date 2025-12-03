import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/humedad_state.dart';
import '../../domain/usecases/get_humedad_status_usecase.dart';
import '../../domain/usecases/manual_pump_usecase.dart';
import '../../domain/usecases/set_humedad_range_usecase.dart';
import '../../domain/usecases/stop_humedad_usecase.dart';

class HumedadController extends StateNotifier<HumedadState> {
  HumedadController(
    this._getStatus,
    this._setRange,
    this._stop,
    this._manualPump,
  ) : super(HumedadState.initial());

  final GetHumedadStatusUsecase _getStatus;
  final SetHumedadRangeUsecase _setRange;
  final StopHumedadUsecase _stop;
  final ManualPumpUsecase _manualPump;

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
            humidity: data.humidity,
            rangeMin: data.rangeMin,
            rangeMax: data.rangeMax,
            autoEnabled: data.autoEnabled,
            pumpOn: data.pumpOn,
            error: null,
          );
        },
        failure: (msg) => state = state.copyWith(error: msg),
      );
    });
  }

  Future<void> applyRange(double min, double max) async {
    final ip = state.espIp;
    if (ip.isEmpty) return;

    final r = await _setRange(ip: ip, min: min, max: max);

    r.when(
      success: (_) => state = state.copyWith(
        rangeMin: min,
        rangeMax: max,
        autoEnabled: true,
      ),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> toggleAuto() async {
    final ip = state.espIp;
    if (ip.isEmpty) return;

    if (state.autoEnabled) {
      final r = await _stop(ip);
      r.when(
        success: (_) =>
            state = state.copyWith(autoEnabled: false, pumpOn: false),
        failure: (msg) => state = state.copyWith(error: msg),
      );
    } else {
      state = state.copyWith(autoEnabled: true);
    }
  }

  Future<void> setPump(bool on) async {
    final ip = state.espIp;
    if (ip.isEmpty) return;

    final r = await _manualPump(ip: ip, state: on);

    r.when(
      success: (_) => state = state.copyWith(pumpOn: on),
      failure: (msg) => state = state.copyWith(error: msg),
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
