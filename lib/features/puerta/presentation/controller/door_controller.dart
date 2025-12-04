import 'dart:async';

import 'package:esp32_app/features/puerta/domain/entities/door_state.dart';
import 'package:esp32_app/features/puerta/domain/usecases/door_manual_action_usecase.dart';
import 'package:esp32_app/features/puerta/domain/usecases/get_door_status_usecase.dart';
import 'package:esp32_app/features/puerta/domain/usecases/set_door_auto_usecase.dart';
import 'package:esp32_app/features/puerta/domain/usecases/set_door_threshold_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoorController extends StateNotifier<DoorState> {
  DoorController(
    this._getStatus,
    this._setThreshold,
    this._setAuto,
    this._manualAction,
  ) : super(DoorState.initial());

  final GetDoorStatusUsecase _getStatus;
  final SetDoorThresholdUsecase _setThreshold;
  final SetDoorAutoUsecase _setAuto;
  final DoorManualActionUsecase _manualAction;

  Timer? _timer;
  bool _alive = true;

  void setIp(String ip) {
    state = state.copyWith(espIp: ip);
    startPolling();
  }

  void startPolling() {
    _timer?.cancel();
    _timer = null;

    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!_alive) return;

      final myTimer = _timer;
      if (myTimer == null) return;

      final ip = state.espIp.trim();
      if (ip.isEmpty) return;

      final r = await _getStatus(ip);
      if (!_alive || _timer != myTimer) return;

      r.when(
        success: (data) {
          if (!_alive || _timer != myTimer) return;
          state = state.copyWith(
            lux: data.lux,
            threshold: data.threshold,
            state: data.state,
            autoEnabled: data.autoEnabled,
            fullyOpen: data.fullyOpen,
            fullyClosed: data.fullyClosed,
            error: null,
          );
        },
        failure: (msg) {
          if (!_alive || _timer != myTimer) return;
          state = state.copyWith(error: msg);
        },
      );
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> applyThreshold(int threshold) async {
    final ip = state.espIp;
    final r = await _setThreshold(ip, threshold);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(threshold: threshold, error: null),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> toggleAuto() async {
    final ip = state.espIp;
    final newValue = !state.autoEnabled;

    final r = await _setAuto(ip, newValue);
    if (!_alive) return;

    r.when(
      success: (_) =>
          state = state.copyWith(autoEnabled: newValue, error: null),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  // ---- CONTROLES MANUALES (press & hold) ----

  Future<void> startOpen() async {
    if (state.autoEnabled) return; // seguridad
    final ip = state.espIp;

    final r = await _manualAction(ip, DoorManualAction.open);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(
        state: "opening",
        autoEnabled: false,
        error: null,
      ),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> startClose() async {
    if (state.autoEnabled) return;
    final ip = state.espIp;

    final r = await _manualAction(ip, DoorManualAction.close);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(
        state: "closing",
        autoEnabled: false,
        error: null,
      ),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> stopManual() async {
    final ip = state.espIp;

    final r = await _manualAction(ip, DoorManualAction.stop);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(state: "idle", error: null),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  @override
  void dispose() {
    _alive = false;
    stopPolling();
    super.dispose();
  }
}
