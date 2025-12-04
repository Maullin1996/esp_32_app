// lib/features/mq2/presentation/controllers/mq2_controller.dart

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:esp32_app/features/mq2/domain/entities/mq2_state.dart';
import 'package:esp32_app/features/mq2/domain/usecases/get_mq2_status_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_auto_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_thresholds_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_alarm_manual_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_sensing_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Mq2Controller extends StateNotifier<Mq2State> {
  Mq2Controller(
    this._getStatus,
    this._setAuto,
    this._setThresholds,
    this._setAlarmManual,
    this._setSensing,
  ) : super(Mq2State.initial());

  final GetMq2StatusUsecase _getStatus;
  final SetMq2AutoUsecase _setAuto;
  final SetMq2ThresholdsUsecase _setThresholds;
  final SetMq2AlarmManualUsecase _setAlarmManual;
  final SetMq2SensingUsecase _setSensing;

  Timer? _timer;

  void setIp(String ip) {
    state = state.copyWith(espIp: ip);
    _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final ip = state.espIp.trim();
      if (ip.isEmpty) return;

      final r = await _getStatus(ip);

      r.when(
        success: (data) {
          // Solo actualiza si cambió algo
          final newState = state.copyWith(
            ppm: data.ppm,
            autoOn: data.autoOn,
            alarmOn: data.alarmOn,
            lowTh: data.lowTh,
            highTh: data.highTh,
            sensingOn: data.sensingOn,
            error: null,
          );

          if (newState != state) {
            state = newState;
          }
        },
        failure: (msg) {
          if (state.error != msg) {
            debugPrint("MQ2 getStatus error: $msg");
            state = state.copyWith(error: msg);
          }
        },
      );
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> toggleAuto() async {
    final ip = state.espIp.trim();
    if (ip.isEmpty) return;

    final newAuto = !state.autoOn;
    state = state.copyWith(isSaving: true, error: null);

    final r = await _setAuto(ip, newAuto);

    r.when(
      success: (_) {
        state = state.copyWith(isSaving: false, autoOn: newAuto);
      },
      failure: (msg) {
        state = state.copyWith(isSaving: false, error: msg);
      },
    );
  }

  Future<void> toggleSensing() async {
    final ip = state.espIp.trim();
    if (ip.isEmpty) return;

    final newSensing = !state.sensingOn;
    state = state.copyWith(isSaving: true, error: null);

    final r = await _setSensing(ip, newSensing);

    r.when(
      success: (_) {
        // si apagamos el sensado, la alarma siempre quedará off del lado ESP
        state = state.copyWith(
          isSaving: false,
          sensingOn: newSensing,
          alarmOn: newSensing ? state.alarmOn : false,
        );
      },
      failure: (msg) {
        state = state.copyWith(isSaving: false, error: msg);
      },
    );
  }

  Future<void> setManualAlarm(bool on) async {
    final ip = state.espIp.trim();
    if (ip.isEmpty) return;

    // Sólo tiene sentido cuando NO está en auto y el sensado está activo
    if (state.autoOn || !state.sensingOn) return;

    state = state.copyWith(isSaving: true, error: null);

    final r = await _setAlarmManual(ip, on);

    r.when(
      success: (_) {
        state = state.copyWith(isSaving: false, alarmOn: on);
      },
      failure: (msg) {
        state = state.copyWith(isSaving: false, error: msg);
      },
    );
  }

  Future<void> saveThresholds(int low, int high) async {
    final ip = state.espIp.trim();
    if (ip.isEmpty) return;

    state = state.copyWith(isSaving: true, error: null);
    final r = await _setThresholds(ip, low, high);

    r.when(
      success: (_) {
        state = state.copyWith(isSaving: false, lowTh: low, highTh: high);
      },
      failure: (msg) {
        state = state.copyWith(isSaving: false, error: msg);
      },
    );
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
