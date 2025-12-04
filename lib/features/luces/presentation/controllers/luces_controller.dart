import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/luces_state.dart';
import '../../domain/usecases/set_relay_usecase.dart';
import '../../../../core/constants/app_constants.dart';

class LucesController extends StateNotifier<LucesState> {
  LucesController(this._setRelay) : super(LucesState.initial());

  final SetRelayUsecase _setRelay;

  void setIp(String ip) {
    state = state.copyWith(espIp: ip, error: null);
  }

  Future<void> toggleRelay(int index) async {
    final ip = state.espIp.trim();
    if (ip.isEmpty) {
      state = state.copyWith(error: 'Debes ingresar la IP del ESP32');
      return;
    }

    if (index < 0 || index >= AppConstants.relaysCount) return;

    final newRelays = [...state.relays];
    newRelays[index] = !newRelays[index];

    state = state.copyWith(relays: newRelays, isSending: true);

    final result = await _setRelay(ip: ip, id: index, state: newRelays[index]);

    result.when(
      success: (_) {
        state = state.copyWith(isSending: false);
      },
      failure: (msg) {
        newRelays[index] = !newRelays[index]; // revert
        state = state.copyWith(relays: newRelays, isSending: false, error: msg);
      },
    );
  }
}
