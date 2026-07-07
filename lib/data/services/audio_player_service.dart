import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:logger/logger.dart';

import '../models/audio_model.dart';

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});

class AudioPlayerService {
  late final AndroidEqualizer _equalizer;
  late final AudioPlayer _player;
  final _logger = Logger();

  List<AudioModel> _queue = [];
  int _currentIndex = 0;

  AudioPlayerService() {
    _equalizer = AndroidEqualizer();
    _player = AudioPlayer(
      audioPipeline: AudioPipeline(
        androidAudioEffects: [_equalizer],
      ),
    );
  }

  // Equalizer access
  AndroidEqualizer get equalizer => _equalizer;

  // Streams
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<double> get speedStream => _player.speedStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<bool> get shuffleModeStream => _player.shuffleModeEnabledStream;
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;

  PlayerState get playerState => _player.playerState;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  double get speed => _player.speed;
  bool get isPlaying => _player.playing;
  int get currentIndex => _player.currentIndex ?? 0;
  List<AudioModel> get queue => _queue;

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle audio interruptions
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(0.4);
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            _player.pause();
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(1.0);
            break;
          case AudioInterruptionType.pause:
            _player.play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });

    session.becomingNoisyEventStream.listen((_) => _player.pause());
  }

  Future<void> playQueue(List<AudioModel> audios, {int startIndex = 0}) async {
    _queue = audios;
    _currentIndex = startIndex;

    final sources = audios.map((a) => AudioSource.uri(
      Uri.file(a.path),
      tag: MediaItem(
        id: a.path,
        title: a.title,
        artist: a.artist,
        album: a.album,
        duration: Duration(milliseconds: a.duration),
        artUri: a.artworkPath != null ? Uri.file(a.artworkPath!) : null,
      ),
    )).toList();

    try {
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources),
        initialIndex: startIndex,
        initialPosition: Duration.zero,
      );
      await _player.play();
    } catch (e, st) {
      _logger.e('playQueue error', error: e, stackTrace: st);
    }
  }

  Future<void> playSingle(AudioModel audio) async {
    _queue = [audio];
    _currentIndex = 0;
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.file(audio.path),
          tag: MediaItem(
            id: audio.path,
            title: audio.title,
            artist: audio.artist,
            album: audio.album,
            duration: Duration(milliseconds: audio.duration),
            artUri: audio.artworkPath != null ? Uri.file(audio.artworkPath!) : null,
          ),
        ),
      );
      await _player.play();
    } catch (e, st) {
      _logger.e('playSingle error', error: e, stackTrace: st);
    }
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> seekToNext() => _player.seekToNext();
  Future<void> seekToPrevious() => _player.seekToPrevious();
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  Future<void> setVolume(double vol) => _player.setVolume(vol);

  Future<void> setLoopMode(LoopMode mode) => _player.setLoopMode(mode);
  Future<void> setShuffleModeEnabled(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  Future<void> skipToIndex(int index) async {
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  // ── Equalizer Methods ──────────────────────────────────────────────────────

  Future<void> setEqualizerEnabled(bool enabled) async {
    await _equalizer.setEnabled(enabled);
  }

  Future<AndroidEqualizerParameters> getEqualizerParameters() async {
    return await _equalizer.parameters;
  }

  Future<void> setEqualizerBandGain(int bandIndex, double gain) async {
    final params = await _equalizer.parameters;
    if (bandIndex >= 0 && bandIndex < params.bands.length) {
      params.bands[bandIndex].setGain(gain);
    }
  }

  /// Predefined equalizer presets: name → list of gain values (in dB)
  static const Map<String, List<double>> equalizerPresets = {
    'Flat':       [0.0, 0.0, 0.0, 0.0, 0.0],
    'Bass Boost': [5.0, 3.5, 0.0, 0.0, 0.0],
    'Treble':     [0.0, 0.0, 0.0, 3.5, 5.0],
    'Rock':       [4.0, 2.0, -1.0, 3.0, 4.5],
    'Pop':        [-1.0, 2.0, 4.0, 2.0, -1.0],
    'Jazz':       [3.0, 1.0, -1.0, 1.5, 3.5],
    'Classical':  [3.5, 2.0, 0.0, 2.0, 3.5],
    'Electronic': [4.5, 2.5, 0.0, 1.0, 4.0],
    'Vocal':      [-2.0, 0.0, 4.0, 3.0, 0.0],
  };

  Future<void> applyPreset(String presetName) async {
    final gains = equalizerPresets[presetName];
    if (gains == null) return;
    final params = await _equalizer.parameters;
    for (int i = 0; i < gains.length && i < params.bands.length; i++) {
      final clampedGain = gains[i].clamp(
        params.minDecibels.toDouble(),
        params.maxDecibels.toDouble(),
      );
      params.bands[i].setGain(clampedGain);
    }
  }

  void dispose() {
    _player.dispose();
  }
}
