import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/humedad_state.dart';
import '../../domain/usecases/get_humedad_status_usecase.dart';
import '../../domain/usecases/set_humedad_manual_usecase.dart';
import '../../domain/usecases/set_humedad_range_usecase.dart';
import '../../domain/usecases/stop_humedad_usecase.dart';

class HumedadController extends StateNotifier<HumedadState> {
  HumedadController(
    this._getStatus,
    this._setManual,
    this._setRange,
    this._stop,
  ) : super(HumedadState.initial());

  final GetHumedadStatusUsecase _getStatus;
  final SetHumedadManualUsecase _setManual;
  final SetHumedadRangeUsecase _setRange;
  final StopHumedadUsecase _stop;

  Timer? _timer;

  void setIp(String ip) {
    state = state.copyWith(espIp: ip);
    startPolling();
  }

  void startPolling() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      final ip = state.espIp.trim();
      if (ip.isEmpty) return;

      final r = await _getStatus(ip);

      r.when(
        success: (data) {
          state = state.copyWith(
            humidity: data.humidity,
            mode: data.mode,
            manualTarget: data.manualTarget,
            rangeMin: data.rangeMin,
            rangeMax: data.rangeMax,
            pumpOn: data.pumpOn,
            error: null,
          );
        },
        failure: (msg) {
          state = state.copyWith(error: msg);
        },
      );
    });
  }

  Future<void> applyManual(double target) async {
    final ip = state.espIp.trim();
    state = state.copyWith(isLoading: true, error: null);

    final r = await _setManual(ip: ip, target: target);

    state = state.copyWith(isLoading: false);

    r.when(
      success: (_) {},
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> applyRange(double min, double max) async {
    final ip = state.espIp.trim();
    state = state.copyWith(isLoading: true, error: null);

    final r = await _setRange(ip: ip, min: min, max: max);

    state = state.copyWith(isLoading: false);

    r.when(
      success: (_) {},
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> stop() async {
    final ip = state.espIp.trim();
    state = state.copyWith(isLoading: true, error: null);

    final r = await _stop(ip);

    state = state.copyWith(isLoading: false);

    r.when(
      success: (_) => state = state.copyWith(mode: "off", pumpOn: false),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
