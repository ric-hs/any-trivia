import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/services/sound_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SoundService _soundService;

  SettingsBloc(this._soundService) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleMuteSounds>(_onToggleMuteSounds);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    emit(state.copyWith(isSoundMuted: _soundService.isMuted));
  }

  Future<void> _onToggleMuteSounds(
    ToggleMuteSounds event,
    Emitter<SettingsState> emit,
  ) async {
    await _soundService.setMuted(event.isMuted);
    emit(state.copyWith(isSoundMuted: event.isMuted));
  }
}
