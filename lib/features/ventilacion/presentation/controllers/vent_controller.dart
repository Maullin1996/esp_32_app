import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_vent_status_usecase.dart';
import '../../domain/usecases/set_vent_auto_use_case.dart';
import '../../domain/usecases/set_vent_fan_manual_usecase.dart';
import '../../domain/usecases/set_vent_range_usecase.dart';
import '../../domain/entities/vent_state.dart';
import '../../data/storage/vent_names_storage.dart';

class VentController extends StateNotifier<VentState> {
  VentController(
    this._getStatus,
    this._setRange,
    this._setAuto,
    this._setFanManual,
    this._storage,
  ) : super(VentState.initial());

  final GetVentStatusUsecase _getStatus;
  final SetVentRangeUsecase _setRange;
  final SetVentAutoUsecase _setAuto;
  final SetVentFanManualUsecase _setFanManual;
  final VentNamesStorage _storage;

  Timer? _timer;
  bool _alive = true;

  // ---------------------------------------------
  //   INICIALIZACIÓN
  // ---------------------------------------------
  void setIp(String ip) async {
    state = state.copyWith(espIp: ip);

    // Cargar nombres guardados
    final savedNames = await _storage.loadNames(ip);
    state = state.copyWith(names: savedNames);

    startPolling();
  }

  // ---------------------------------------------
  //   POLLING
  // ---------------------------------------------
  void startPolling() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!_alive) return;
      final ip = state.espIp.trim();
      if (ip.isEmpty) return;

      final myTimer = _timer;
      if (myTimer == null) return;

      final r = await _getStatus(ip);

      if (!_alive || _timer != myTimer) return;

      r.when(
        success: (data) async {
          if (!_alive) return;
          final count = data.temps.length;

          // Ajustar nombres almacenados al tamaño real
          List<String> names = state.names;

          if (names.length != count) {
            names = List.generate(
              count,
              (i) => i < names.length ? names[i] : 'Sensor ${i + 1}',
            );

            // Guardar inmediatamente la lista ajustada
            await _storage.saveNames(state.espIp, names);
          }

          state = state.copyWith(
            temps: data.temps,
            fans: data.fans,
            rangeMin: data.rangeMin,
            rangeMax: data.rangeMax,
            autoEnabled: data.autoEnabled,
            names: names,
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

  // ---------------------------------------------
  //   RENOMBRAR SENSOR
  // ---------------------------------------------
  Future<void> renameSensor(int index, String newName) async {
    if (index < 0 || index >= state.names.length) return;

    final updated = [...state.names];
    updated[index] = newName.trim().isEmpty
        ? 'Sensor ${index + 1}'
        : newName.trim();

    state = state.copyWith(names: updated);

    await _storage.saveNames(state.espIp, updated);
  }

  // ---------------------------------------------
  //   APLICAR RANGO
  // ---------------------------------------------
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

  // ---------------------------------------------
  //   AUTO ON/OFF
  // ---------------------------------------------
  Future<void> toggleAuto() async {
    final ip = state.espIp;
    final value = !state.autoEnabled;

    final r = await _setAuto(ip, value);
    if (!_alive) return;

    r.when(
      success: (_) => state = state.copyWith(autoEnabled: value, error: null),
      failure: (msg) => state.copyWith(error: msg),
    );
  }

  // ---------------------------------------------
  //   CONTROL MANUAL POR SENSOR
  // ---------------------------------------------
  Future<void> toggleFanManual(int index) async {
    if (state.autoEnabled) return;

    final ip = state.espIp;
    if (index < 0 || index >= state.fans.length) return;

    final newFan = !state.fans[index];

    final r = await _setFanManual(ip, index, newFan);
    if (!_alive) return;

    r.when(
      success: (_) {
        final updated = [...state.fans];
        updated[index] = newFan;
        state = state.copyWith(fans: updated, error: null);
      },
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
