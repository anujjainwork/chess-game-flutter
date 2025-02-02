import 'package:bloc/bloc.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

part 'sfx_state.dart';

class SfxHapticsCubit extends Cubit<SfxHapticsState> {
  SfxHapticsCubit() : super(SoundInitial()) {
    FlameAudio.audioCache.prefix = 'lib/assets/sfx/';
    _loadAudioPools();
  }

  late AudioPool? _movePool;
  late AudioPool? _capturePool;
  late AudioPool? _checkPool;

  bool _isAudioLoaded = false;

  Future<void> _loadAudioPools() async {
    try {
      _movePool = await FlameAudio.createPool('move.mp3', maxPlayers: 3);
      _capturePool = await FlameAudio.createPool('capture.mp3', maxPlayers: 3);
      _checkPool = await FlameAudio.createPool('check.mp3', maxPlayers: 3);
      _isAudioLoaded = true;
      print("✅ Audio pools successfully loaded");
    } catch (e) {
      print("❌ Error loading audio pools: $e");
      _isAudioLoaded = false;
    }
  }

  void playMoveSound() {
    _playSound(_movePool, HapticFeedback.lightImpact);
  }

  void playCaptureSound() {
    _playSound(_capturePool, HapticFeedback.mediumImpact);
  }

  void playCheckSound() {
    _playSound(_checkPool, HapticFeedback.heavyImpact);
  }

  void _playSound(AudioPool? pool, Function haptic) {
    if (_isAudioLoaded && pool != null) {
      try {
        pool.start();
        Future.delayed(const Duration(milliseconds: 200), () => haptic());
        emit(SoundPlaying());
      } catch (e) {
        print("❌ Error playing sound: $e");
      }
    } else {
      print("⚠️ Audio is still loading or pool is null, skipping sound.");
    }
  }
}
