import 'dart:async';

import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/entities/persiana_state.dart';
import 'package:esp32_app/features/persiana/domain/usecases/get_persiana_status_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/send_manual_action_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_auto_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_pwm_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_range_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_timing_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersianaController extends StateNotifier<PersianaState> {
  PersianaController(
    this._getStatus,
    this._setRange,
    this._setPwm,
    this._setTiming,
    this._setAuto,
    this._sendManualAction,
  ) : super(PersianaState.initial());

  final GetPersianaStatusUsecase _getStatus;
  final SetPersianaRangeUsecase _setRange;
  final SetPersianaPwmUsecase _setPwm;
  final SetPersianaTimingUsecase _setTiming;
  final SetPersianaAutoUsecase _setAuto;
  final SendManualActionUsecase _sendManualAction;

  Timer? _timer;
  bool _alive = true;

  void setIp(String ip) {
    state = state.copyWith(espIp: ip);
    startPolling();
  }

  void startPolling() {
    _timer?.cancel();
    _timer = null;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!_alive) return;

      final ip = state.espIp.trim();
      if (ip.isEmpty) return;

      final myTimer = _timer;
      if (myTimer == null) return;

      final r = await _getStatus(ip);

      if (!_alive) return;
      if (_timer != myTimer) return;

      r.when(
        success: (data) {
          if (!_alive) return;
          state = state.copyWith(
            temperature: data.temperature,
            rangeMin: data.rangeMin,
            rangeMax: data.rangeMax,
            pwm: data.pwm,
            timeOpenMs: data.timeOpenMs,
            timeCloseMs: data.timeCloseMs,
            motorState: data.motorState,
            lastAction: data.lastAction,
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
    final Result<void> r = await _setRange(ip, min, max);
    if (!_alive) return;

    r.when(
      success: (_) =>
          state = state.copyWith(rangeMin: min, rangeMax: max, error: null),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> applyPwm(int pwm) async {
    final ip = state.espIp;
    final r = await _setPwm(ip, pwm);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(pwm: pwm, error: null),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> applyTiming(int openMs, int closeMs) async {
    final ip = state.espIp;
    final r = await _setTiming(ip, openMs, closeMs);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(
        timeOpenMs: openMs,
        timeCloseMs: closeMs,
        error: null,
      ),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> toggleAuto() async {
    final ip = state.espIp;
    final newValue = !state.autoEnabled;

    final r = await _setAuto(ip, newValue);
    if (!_alive) return;

    r.when(
      success: (_) {
        // si activamos auto, cualquier movimiento manual lo gestiona el ESP
        state = state.copyWith(autoEnabled: newValue, error: null);
      },
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  // ---- MANUAL: press & hold ----

  Future<void> startManualOpen() async {
    if (state.autoEnabled) return; // por seguridad
    final ip = state.espIp;

    final r = await _sendManualAction(ip, PersianaManualAction.open);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(
        motorState: "opening",
        autoEnabled: false, // el ESP también apaga auto internamente
        error: null,
      ),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> startManualClose() async {
    if (state.autoEnabled) return;
    final ip = state.espIp;

    final r = await _sendManualAction(ip, PersianaManualAction.close);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(
        motorState: "closing",
        autoEnabled: false,
        error: null,
      ),
      failure: (msg) => state = state.copyWith(error: msg),
    );
  }

  Future<void> stopManual() async {
    final ip = state.espIp;

    final r = await _sendManualAction(ip, PersianaManualAction.stop);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(motorState: "idle", error: null),
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
