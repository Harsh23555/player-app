import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final speedLimiterServiceProvider = Provider<SpeedLimiterService>((ref) {
  return SpeedLimiterService();
});

/// Issue 005 — Download Speed Optimization
/// Provides bandwidth control, speed limiting, and ETA prediction.
class SpeedLimiterService {
  double _limitBytesPerSecond = 0; // 0 = unlimited
  bool _unlimited = true;

  // Speed history for graph (last 60 samples)
  final List<double> _speedHistory = [];
  static const int _maxHistory = 60;

  double get limitBytesPerSecond => _limitBytesPerSecond;
  bool get isUnlimited => _unlimited;
  double get peakSpeed => _speedHistory.isEmpty
      ? 0
      : _speedHistory.reduce((a, b) => a > b ? a : b);
  double get averageSpeed => _speedHistory.isEmpty
      ? 0
      : _speedHistory.reduce((a, b) => a + b) / _speedHistory.length;
  List<double> get speedHistory => List.unmodifiable(_speedHistory);

  /// Set bandwidth limit. Pass 0 or negative for unlimited.
  void setLimit(double bytesPerSecond) {
    if (bytesPerSecond <= 0) {
      _unlimited = true;
      _limitBytesPerSecond = 0;
    } else {
      _unlimited = false;
      _limitBytesPerSecond = bytesPerSecond;
    }
  }

  /// Set limit from named preset
  void setPreset(SpeedLimitPreset preset) {
    switch (preset) {
      case SpeedLimitPreset.unlimited:
        setLimit(0);
        break;
      case SpeedLimitPreset.kb256:
        setLimit(256 * 1024);
        break;
      case SpeedLimitPreset.kb512:
        setLimit(512 * 1024);
        break;
      case SpeedLimitPreset.mb1:
        setLimit(1 * 1024 * 1024);
        break;
      case SpeedLimitPreset.mb2:
        setLimit(2 * 1024 * 1024);
        break;
      case SpeedLimitPreset.mb5:
        setLimit(5 * 1024 * 1024);
        break;
      case SpeedLimitPreset.mb10:
        setLimit(10 * 1024 * 1024);
        break;
    }
  }

  /// Record a speed sample for history/graph.
  void recordSpeed(double bytesPerSecond) {
    _speedHistory.add(bytesPerSecond);
    if (_speedHistory.length > _maxHistory) {
      _speedHistory.removeAt(0);
    }
  }

  /// Throttle: if speed exceeds limit, delay returning.
  /// Returns the duration to sleep to enforce the bandwidth limit.
  Duration throttle(int bytesJustRead, DateTime chunkStart) {
    if (_unlimited || _limitBytesPerSecond <= 0) return Duration.zero;
    final elapsed = DateTime.now().difference(chunkStart).inMicroseconds;
    final expectedMicros = (bytesJustRead / _limitBytesPerSecond * 1e6).round();
    if (expectedMicros > elapsed) {
      return Duration(microseconds: expectedMicros - elapsed);
    }
    return Duration.zero;
  }

  /// Calculate ETA given remaining bytes and current speed.
  int calculateEta(int remainingBytes, double currentBytesPerSec) {
    if (currentBytesPerSec <= 0) return 0;
    return (remainingBytes / currentBytesPerSec).round();
  }

  void clear() {
    _speedHistory.clear();
  }
}

enum SpeedLimitPreset {
  unlimited,
  kb256,
  kb512,
  mb1,
  mb2,
  mb5,
  mb10,
}

extension SpeedLimitPresetLabel on SpeedLimitPreset {
  String get label {
    switch (this) {
      case SpeedLimitPreset.unlimited:
        return 'Unlimited';
      case SpeedLimitPreset.kb256:
        return '256 KB/s';
      case SpeedLimitPreset.kb512:
        return '512 KB/s';
      case SpeedLimitPreset.mb1:
        return '1 MB/s';
      case SpeedLimitPreset.mb2:
        return '2 MB/s';
      case SpeedLimitPreset.mb5:
        return '5 MB/s';
      case SpeedLimitPreset.mb10:
        return '10 MB/s';
    }
  }

  double get bytesPerSecond {
    switch (this) {
      case SpeedLimitPreset.unlimited:
        return 0;
      case SpeedLimitPreset.kb256:
        return 256 * 1024;
      case SpeedLimitPreset.kb512:
        return 512 * 1024;
      case SpeedLimitPreset.mb1:
        return 1 * 1024 * 1024;
      case SpeedLimitPreset.mb2:
        return 2 * 1024 * 1024;
      case SpeedLimitPreset.mb5:
        return 5 * 1024 * 1024;
      case SpeedLimitPreset.mb10:
        return 10 * 1024 * 1024;
    }
  }
}
