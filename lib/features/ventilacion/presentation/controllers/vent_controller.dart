import 'dart:async';
import 'package:esp32_app/features/ventilacion/domain/usecases/set_humedad_range_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/vent_state.dart';
import '../../domain/usecases/get_vent_status_usecase.dart';
import '../../domain/usecases/set_vent_range_usecase.dart';
import '../../domain/usecases/stop_vent_usecase.dart';

class VentController extends StateNotifier<VentState> {
  VentController(this._getStatus, this._setManual, this._setRange, this._stop)
    : super(VentState.initial());

  final GetVentStatusUsecase _getStatus;
  final SetVentManualUsecase _setManual;
  final SetVentRangeUsecase _setRange;
  final StopVentUsecase _stop;

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
        success: (data) => state = state.copyWith(
          temperature: data.temperature,
          mode: data.mode,
          manualTarget: data.manualTarget,
          rangeMin: data.rangeMin,
          rangeMax: data.rangeMax,
          fanOn: data.fanOn,
          error: null,
        ),
        failure: (msg) => state = state.copyWith(error: msg),
      );
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> applyManual(double target) async {
    final ip = state.espIp;
    final r = await _setManual(ip, target);
    r.when(
      success: (_) {},
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> applyRange(double min, double max) async {
    final ip = state.espIp;
    final r = await _setRange(ip, min, max);
    r.when(
      success: (_) {},
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> stop() async {
    final ip = state.espIp;
    final r = await _stop(ip);
    r.when(
      success: (_) => state = state.copyWith(mode: "off", fanOn: false),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
