import 'dart:async';
import 'package:esp32_app/features/ventilacion/domain/usecases/set_vent_fan_manual_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/vent_state.dart';
import '../../domain/usecases/get_vent_status_usecase.dart';
import '../../domain/usecases/set_vent_range_usecase.dart';
import '../../domain/usecases/set_vent_auto_use_case.dart';

class VentController extends StateNotifier<VentState> {
  VentController(
    this._getStatus,
    this._setRange,
    this._setAuto,
    this._setFanManual,
  ) : super(VentState.initial());

  final GetVentStatusUsecase _getStatus;
  final SetVentRangeUsecase _setRange;
  final SetVentAutoUsecase _setAuto;
  final SetVentFanManualUsecase _setFanManual;

  Timer? _timer;
  bool _alive = true; // <--- evita uso post-dispose

  void setIp(String ip) {
    state = state.copyWith(espIp: ip);
    startPolling();
  }

  void startPolling() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!_alive) return; // <--- 1) evita correr si está muerto

      final ip = state.espIp.trim();
      if (ip.isEmpty) return;

      // <--- 2) cancelar polling durante el await
      final myTimer = _timer;
      if (myTimer == null) return;

      final r = await _getStatus(ip);

      // <--- 3) verificar que no se haya destruido durante el await
      if (!_alive) return;
      if (_timer != myTimer) return;

      r.when(
        success: (data) {
          if (!_alive) return; // <--- 4) protección final

          state = state.copyWith(
            temperature: data.temperature,
            rangeMin: data.rangeMin,
            rangeMax: data.rangeMax,
            fanOn: data.fanOn,
            autoEnabled: data.autoEnabled,
            error: null,
          );
        },
        failure: (msg) {
          if (!_alive) return;
          state = state.copyWith(error: msg);
        },
      );
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> applyRange(double min, double max) async {
    final ip = state.espIp;

    final r = await _setRange(ip, min, max);
    if (!_alive) return;

    r.when(
      success: (_) =>
          state = state.copyWith(rangeMin: min, rangeMax: max, error: null),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> toggleAuto() async {
    final ip = state.espIp;
    final newValue = !state.autoEnabled;

    final r = await _setAuto(ip, newValue);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(
        autoEnabled: newValue,
        fanOn: newValue ? state.fanOn : false,
        error: null,
      ),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> toggleFanManual() async {
    if (state.autoEnabled) return;

    final ip = state.espIp;
    final newFan = !state.fanOn;

    final r = await _setFanManual(ip, newFan);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(fanOn: newFan, error: null),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  @override
  void dispose() {
    _alive = false; // <--- indica que ya no debe usarse
    stopPolling(); // <--- cancela timer
    super.dispose();
  }
}
