import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  final SharedPreferences _prefs;
  final AudioPlayer _audioPlayer;
  static const String _mutedKey = 'sound_effects_muted';

  SoundService(this._prefs) : _audioPlayer = AudioPlayer();

  bool get isMuted => _prefs.getBool(_mutedKey) ?? false;

  Future<void> init() async {
    await _audioPlayer.setSource(AssetSource('audio/correct-sfx.wav'));
    await _audioPlayer.setSource(AssetSource('audio/wrong-sfx.wav'));
  }

  Future<void> play(String assetPath) async {
    if (isMuted) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // Handle error or log it
    }
  }

  Future<void> setMuted(bool muted) async {
    await _prefs.setBool(_mutedKey, muted);
  }
}
