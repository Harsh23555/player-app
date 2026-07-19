import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/app_logger.dart';

final equalizerServiceProvider = Provider<EqualizerService>((ref) {
  return EqualizerService();
});

final equalizerProvider =
    StateNotifierProvider<EqualizerNotifier, EqualizerState>((ref) {
  return EqualizerNotifier(ref.watch(equalizerServiceProvider));
});

/// Issue 030 — Video/Audio Equalizer (Fix)
/// Uses Android Equalizer API through a MethodChannel for real-time EQ.
/// Applies Bass Boost, Virtualizer, Loudness Enhancer, and 5/10-band EQ.
class EqualizerService {
  static const _channel = MethodChannel('com.novaplayer.app/equalizer');

  static const _kPreset = 'eq_preset';
  static const _kEnabled = 'eq_enabled';
  static const _kBands = 'eq_bands';
  static const _kBassBoost = 'eq_bass_boost';
  static const _kVirtualizer = 'eq_virtualizer';
  static const _kLoudness = 'eq_loudness';

  bool _initialized = false;
  int _sessionId = 0;

  /// Initialize equalizer with an audio session ID
  Future<bool> initialize(int audioSessionId) async {
    _sessionId = audioSessionId;
    try {
      final result = await _channel.invokeMethod<bool>('initialize', {
        'sessionId': audioSessionId,
      });
      _initialized = result ?? false;
      AppLogger.info('Equalizer initialized: $_initialized, session=$audioSessionId');
      return _initialized;
    } catch (e) {
      AppLogger.error('Equalizer init failed', error: e);
      return false;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    try {
      await _channel.invokeMethod('setEnabled', {'enabled': enabled});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kEnabled, enabled);
    } catch (e) {
      AppLogger.error('Equalizer.setEnabled failed', error: e);
    }
  }

  /// Apply a named preset
  Future<void> applyPreset(String presetName) async {
    try {
      await _channel.invokeMethod('applyPreset', {'preset': presetName});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPreset, presetName);
    } catch (e) {
      AppLogger.error('Equalizer.applyPreset failed', error: e);
    }
  }

  /// Set individual band gain (millibels)
  Future<void> setBandLevel(int band, int milliBels) async {
    try {
      await _channel.invokeMethod('setBandLevel', {
        'band': band,
        'milliBels': milliBels,
      });
    } catch (e) {
      AppLogger.error('Equalizer.setBandLevel failed', error: e);
    }
  }

  /// Set bass boost strength (0–1000)
  Future<void> setBassBoost(int strength) async {
    try {
      await _channel.invokeMethod('setBassBoost', {'strength': strength});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kBassBoost, strength);
    } catch (e) {
      AppLogger.error('Equalizer.setBassBoost failed', error: e);
    }
  }

  /// Set virtualizer strength (0–1000)
  Future<void> setVirtualizer(int strength) async {
    try {
      await _channel.invokeMethod('setVirtualizer', {'strength': strength});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kVirtualizer, strength);
    } catch (e) {
      AppLogger.error('Equalizer.setVirtualizer failed', error: e);
    }
  }

  /// Set loudness enhancer target gain in millibels
  Future<void> setLoudnessEnhancer(int targetGainMb) async {
    try {
      await _channel.invokeMethod('setLoudnessEnhancer', {'targetGainMb': targetGainMb});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kLoudness, targetGainMb);
    } catch (e) {
      AppLogger.error('Equalizer.setLoudnessEnhancer failed', error: e);
    }
  }

  /// Get number of bands supported by device
  Future<int> getBandCount() async {
    try {
      final count = await _channel.invokeMethod<int>('getBandCount');
      return count ?? 5;
    } catch (_) {
      return 5;
    }
  }

  /// Get frequency range for each band
  Future<List<int>> getBandFrequencies() async {
    try {
      final freqs = await _channel.invokeMethod<List>('getBandFrequencies');
      return freqs?.map((f) => f as int).toList() ?? [60, 230, 910, 3600, 14000];
    } catch (_) {
      return [60, 230, 910, 3600, 14000]; // Default 5-band frequencies
    }
  }

  Future<void> release() async {
    try {
      await _channel.invokeMethod('release');
    } catch (_) {}
    _initialized = false;
  }

  /// Load saved EQ settings
  Future<EqualizerState> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kEnabled) ?? false;
    final preset = prefs.getString(_kPreset) ?? 'Normal';
    final bassBoost = prefs.getInt(_kBassBoost) ?? 0;
    final virtualizer = prefs.getInt(_kVirtualizer) ?? 0;
    final loudness = prefs.getInt(_kLoudness) ?? 0;

    final bandPreset = EqualizerPresets.getPreset(preset);
    return EqualizerState(
      enabled: enabled,
      currentPreset: preset,
      bands: bandPreset.bands,
      bassBoost: bassBoost,
      virtualizer: virtualizer,
      loudnessGain: loudness,
    );
  }

  Future<void> saveState(EqualizerState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabled, state.enabled);
    await prefs.setString(_kPreset, state.currentPreset);
    await prefs.setInt(_kBassBoost, state.bassBoost);
    await prefs.setInt(_kVirtualizer, state.virtualizer);
    await prefs.setInt(_kLoudness, state.loudnessGain);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Equalizer Notifier
// ─────────────────────────────────────────────────────────────────────────────
class EqualizerNotifier extends StateNotifier<EqualizerState> {
  final EqualizerService _service;

  EqualizerNotifier(this._service) : super(EqualizerState.initial()) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await _service.loadSaved();
    state = saved;
  }

  Future<void> initialize(int sessionId) async {
    await _service.initialize(sessionId);
    if (state.enabled) await _applyCurrentState();
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await _service.setEnabled(enabled);
    if (enabled) await _applyCurrentState();
    await _service.saveState(state);
  }

  Future<void> applyPreset(String presetName) async {
    final preset = EqualizerPresets.getPreset(presetName);
    state = state.copyWith(currentPreset: presetName, bands: preset.bands);
    await _service.applyPreset(presetName);
    // Apply band levels for this preset
    for (int i = 0; i < preset.bands.length; i++) {
      await _service.setBandLevel(i, preset.bands[i]);
    }
    await _service.saveState(state);
  }

  Future<void> setBandLevel(int band, int milliBels) async {
    final newBands = List<int>.from(state.bands);
    if (band < newBands.length) {
      newBands[band] = milliBels;
    }
    state = state.copyWith(bands: newBands, currentPreset: 'Custom');
    await _service.setBandLevel(band, milliBels);
    await _service.saveState(state);
  }

  Future<void> setBassBoost(int strength) async {
    state = state.copyWith(bassBoost: strength);
    await _service.setBassBoost(strength);
    await _service.saveState(state);
  }

  Future<void> setVirtualizer(int strength) async {
    state = state.copyWith(virtualizer: strength);
    await _service.setVirtualizer(strength);
    await _service.saveState(state);
  }

  Future<void> setLoudness(int gain) async {
    state = state.copyWith(loudnessGain: gain);
    await _service.setLoudnessEnhancer(gain);
    await _service.saveState(state);
  }

  Future<void> _applyCurrentState() async {
    await _service.applyPreset(state.currentPreset);
    await _service.setBassBoost(state.bassBoost);
    await _service.setVirtualizer(state.virtualizer);
    await _service.setLoudnessEnhancer(state.loudnessGain);
    for (int i = 0; i < state.bands.length; i++) {
      await _service.setBandLevel(i, state.bands[i]);
    }
  }

  void reset() {
    applyPreset('Normal');
    setBassBoost(0);
    setVirtualizer(0);
    setLoudness(0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Equalizer State
// ─────────────────────────────────────────────────────────────────────────────
class EqualizerState {
  final bool enabled;
  final String currentPreset;
  final List<int> bands; // millibels for each band
  final int bassBoost; // 0–1000
  final int virtualizer; // 0–1000
  final int loudnessGain; // millibels

  const EqualizerState({
    required this.enabled,
    required this.currentPreset,
    required this.bands,
    required this.bassBoost,
    required this.virtualizer,
    required this.loudnessGain,
  });

  factory EqualizerState.initial() => EqualizerState(
        enabled: false,
        currentPreset: 'Normal',
        bands: EqualizerPresets.getPreset('Normal').bands,
        bassBoost: 0,
        virtualizer: 0,
        loudnessGain: 0,
      );

  EqualizerState copyWith({
    bool? enabled,
    String? currentPreset,
    List<int>? bands,
    int? bassBoost,
    int? virtualizer,
    int? loudnessGain,
  }) =>
      EqualizerState(
        enabled: enabled ?? this.enabled,
        currentPreset: currentPreset ?? this.currentPreset,
        bands: bands ?? this.bands,
        bassBoost: bassBoost ?? this.bassBoost,
        virtualizer: virtualizer ?? this.virtualizer,
        loudnessGain: loudnessGain ?? this.loudnessGain,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Preset Definitions (5-band: 60Hz, 230Hz, 910Hz, 3.6kHz, 14kHz)
// Values in millibels relative to 0 (range: -1500 to +1500)
// ─────────────────────────────────────────────────────────────────────────────
class EqPreset {
  final String name;
  final List<int> bands; // millibels for 5 bands
  const EqPreset({required this.name, required this.bands});
}

class EqualizerPresets {
  static const List<EqPreset> presets = [
    EqPreset(name: 'Normal', bands: [0, 0, 0, 0, 0]),
    EqPreset(name: 'Classical', bands: [500, 300, -200, 400, 500]),
    EqPreset(name: 'Dance', bands: [600, 0, -200, 0, 600]),
    EqPreset(name: 'Flat', bands: [0, 0, 0, 0, 0]),
    EqPreset(name: 'Folk', bands: [300, 0, 0, 200, -100]),
    EqPreset(name: 'Heavy Metal', bands: [400, 100, -700, 200, 100]),
    EqPreset(name: 'Hip Hop', bands: [500, 300, -100, 200, -100]),
    EqPreset(name: 'Jazz', bands: [400, 200, -200, 200, 500]),
    EqPreset(name: 'Pop', bands: [-100, 200, 500, 200, -100]),
    EqPreset(name: 'Rock', bands: [500, 300, -400, 300, 500]),
    EqPreset(name: 'Bass Boost', bands: [1000, 600, 0, -100, -200]),
    EqPreset(name: 'Vocal', bands: [-300, 0, 700, 500, 300]),
    EqPreset(name: 'Treble', bands: [-200, -100, 0, 600, 1000]),
    EqPreset(name: 'Electronic', bands: [700, 300, 0, 300, 700]),
    EqPreset(name: 'Acoustic', bands: [400, 300, 100, 300, 400]),
  ];

  static EqPreset getPreset(String name) {
    return presets.firstWhere(
      (p) => p.name == name,
      orElse: () => const EqPreset(name: 'Normal', bands: [0, 0, 0, 0, 0]),
    );
  }

  static List<String> get names => presets.map((p) => p.name).toList();
}
