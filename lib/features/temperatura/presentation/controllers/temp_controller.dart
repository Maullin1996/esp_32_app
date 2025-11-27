import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/temp_state.dart';
import '../../domain/usecases/get_status_usecase.dart';
import '../../domain/usecases/set_manual_usecase.dart';
import '../../domain/usecases/set_range_usecase.dart';
import '../../domain/usecases/stop_usecase.dart';

class TempController extends StateNotifier<TempState> {
  TempController(this._getStatus, this._setManual, this._setRange, this._stop)
    : super(TempState.initial());

  final GetStatusUsecase _getStatus;
  final SetManualUsecase _setManual;
  final SetRangeUsecase _setRange;
  final StopUsecase _stop;

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
            temperature: data.temperature,
            mode: data.mode,
            manualTarget: data.manualTarget,
            rangeMin: data.rangeMin,
            rangeMax: data.rangeMax,
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

  Future<void> applyManual(double target) async {
    final ip = state.espIp;
    state = state.copyWith(isLoading: true, error: null);

    final r = await _setManual(ip: ip, target: target);

    state = state.copyWith(isLoading: false);

    r.when(
      success: (_) {},
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> applyRange(double min, double max) async {
    final ip = state.espIp;
    state = state.copyWith(isLoading: true, error: null);

    final r = await _setRange(ip: ip, min: min, max: max);

    state = state.copyWith(isLoading: false);

    r.when(
      success: (_) {},
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> stop() async {
    final ip = state.espIp;
    state = state.copyWith(isLoading: true, error: null);

    final r = await _stop(ip);

    state = state.copyWith(isLoading: false);

    r.when(
      success: (_) => state = state.copyWith(mode: "off", heaterOn: false),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
