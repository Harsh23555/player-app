import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/services/audio_player_service.dart';

// ── Equalizer State ──────────────────────────────────────────────────────────
class EqualizerState {
  final bool enabled;
  final String? activePreset;
  final List<double> bandGains;
  final List<int> bandFrequencies;
  final double minDecibels;
  final double maxDecibels;
  final bool isLoaded;

  const EqualizerState({
    this.enabled = false,
    this.activePreset,
    this.bandGains = const [],
    this.bandFrequencies = const [],
    this.minDecibels = -15.0,
    this.maxDecibels = 15.0,
    this.isLoaded = false,
  });

  EqualizerState copyWith({
    bool? enabled,
    String? activePreset,
    List<double>? bandGains,
    List<int>? bandFrequencies,
    double? minDecibels,
    double? maxDecibels,
    bool? isLoaded,
    bool clearPreset = false,
  }) =>
      EqualizerState(
        enabled: enabled ?? this.enabled,
        activePreset: clearPreset ? null : (activePreset ?? this.activePreset),
        bandGains: bandGains ?? this.bandGains,
        bandFrequencies: bandFrequencies ?? this.bandFrequencies,
        minDecibels: minDecibels ?? this.minDecibels,
        maxDecibels: maxDecibels ?? this.maxDecibels,
        isLoaded: isLoaded ?? this.isLoaded,
      );
}

// ── Equalizer Notifier ───────────────────────────────────────────────────────
class EqualizerNotifier extends StateNotifier<EqualizerState> {
  final AudioPlayerService _service;

  EqualizerNotifier(this._service) : super(const EqualizerState()) {
    _loadParameters();
  }

  Future<void> _loadParameters() async {
    try {
      final params = await _service.getEqualizerParameters();
      final bands = params.bands;
      state = state.copyWith(
        bandGains: bands.map((b) => b.gain).toList(),
        bandFrequencies: bands.map((b) => b.centerFrequency.toInt()).toList(),
        minDecibels: params.minDecibels.toDouble(),
        maxDecibels: params.maxDecibels.toDouble(),
        isLoaded: true,
      );
    } catch (_) {
      // Equalizer not available (e.g., iOS)
      state = state.copyWith(isLoaded: false);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    await _service.setEqualizerEnabled(enabled);
    state = state.copyWith(enabled: enabled);
  }

  Future<void> toggleEnabled() async {
    await setEnabled(!state.enabled);
  }

  Future<void> setBandGain(int bandIndex, double gain) async {
    final clampedGain = gain.clamp(state.minDecibels, state.maxDecibels);
    await _service.setEqualizerBandGain(bandIndex, clampedGain);

    final newGains = List<double>.from(state.bandGains);
    if (bandIndex < newGains.length) {
      newGains[bandIndex] = clampedGain;
    }
    state = state.copyWith(bandGains: newGains, clearPreset: true);
  }

  Future<void> applyPreset(String presetName) async {
    await _service.applyPreset(presetName);

    // Read back the actual gain values
    final params = await _service.getEqualizerParameters();
    state = state.copyWith(
      bandGains: params.bands.map((b) => b.gain).toList(),
      activePreset: presetName,
    );

    // Auto-enable when applying a preset
    if (!state.enabled) {
      await setEnabled(true);
    }
  }

  Future<void> resetToFlat() async {
    await applyPreset('Flat');
  }

  List<String> get presetNames =>
      AudioPlayerService.equalizerPresets.keys.toList();

  /// Format band frequency for display
  static String formatFrequency(int hz) {
    if (hz >= 1000) {
      final khz = hz / 1000;
      return khz == khz.roundToDouble()
          ? '${khz.round()}kHz'
          : '${khz.toStringAsFixed(1)}kHz';
    }
    return '${hz}Hz';
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────
final equalizerProvider =
    StateNotifierProvider<EqualizerNotifier, EqualizerState>((ref) {
  return EqualizerNotifier(ref.watch(audioPlayerServiceProvider));
});
