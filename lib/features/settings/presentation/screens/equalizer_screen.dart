import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/equalizer_service.dart';
import '../../../../shared/widgets/common_widgets.dart';

/// Issue 030 — Equalizer Screen
/// Real-time 5-band EQ with presets, Bass Boost, Virtualizer, Loudness Enhancer.
class EqualizerScreen extends ConsumerWidget {
  const EqualizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(equalizerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Equalizer'),
        actions: [
          Switch(
            value: state.enabled,
            onChanged: (v) =>
                ref.read(equalizerProvider.notifier).setEnabled(v),
            activeColor: AppTheme.primaryViolet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // EQ Enabled indicator
                if (!state.enabled)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.accentGold.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: AppTheme.accentGold, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Enable the Equalizer with the toggle in the top-right.',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── Preset Selector ──────────────────────────────────────
                _sectionLabel('Presets'),
                const SizedBox(height: 10),
                _PresetSelector(
                  currentPreset: state.currentPreset,
                  enabled: state.enabled,
                  onSelect: (name) =>
                      ref.read(equalizerProvider.notifier).applyPreset(name),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 20),

                // ── 5-Band Equalizer ─────────────────────────────────────
                _sectionLabel('5-Band Equalizer'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _FiveBandEq(
                      bands: state.bands,
                      enabled: state.enabled,
                      onBandChanged: (band, val) => ref
                          .read(equalizerProvider.notifier)
                          .setBandLevel(band, val),
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                const SizedBox(height: 20),

                // ── Effects ───────────────────────────────────────────────
                _sectionLabel('Effects'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _EffectSlider(
                          label: 'Bass Boost',
                          icon: Icons.graphic_eq_rounded,
                          value: state.bassBoost.toDouble(),
                          min: 0,
                          max: 1000,
                          enabled: state.enabled,
                          valueLabel: '${state.bassBoost}',
                          onChanged: (v) => ref
                              .read(equalizerProvider.notifier)
                              .setBassBoost(v.round()),
                        ),
                        const Divider(height: 24),
                        _EffectSlider(
                          label: 'Virtualizer',
                          icon: Icons.surround_sound_rounded,
                          value: state.virtualizer.toDouble(),
                          min: 0,
                          max: 1000,
                          enabled: state.enabled,
                          valueLabel: '${state.virtualizer}',
                          onChanged: (v) => ref
                              .read(equalizerProvider.notifier)
                              .setVirtualizer(v.round()),
                        ),
                        const Divider(height: 24),
                        _EffectSlider(
                          label: 'Loudness Enhancer',
                          icon: Icons.volume_up_rounded,
                          value: state.loudnessGain.toDouble(),
                          min: 0,
                          max: 1000,
                          enabled: state.enabled,
                          valueLabel: '${state.loudnessGain} mB',
                          onChanged: (v) => ref
                              .read(equalizerProvider.notifier)
                              .setLoudness(v.round()),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                const SizedBox(height: 16),

                // Reset button
                OutlinedButton.icon(
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reset to Default'),
                  onPressed: state.enabled
                      ? () => ref.read(equalizerProvider.notifier).reset()
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.darkTextSecondary,
                    side: const BorderSide(color: AppTheme.darkBorder),
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.primaryViolet,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Preset Selector
// ─────────────────────────────────────────────────────────────────────────────
class _PresetSelector extends StatelessWidget {
  final String currentPreset;
  final bool enabled;
  final void Function(String) onSelect;

  const _PresetSelector({
    required this.currentPreset,
    required this.enabled,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: EqualizerPresets.names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final name = EqualizerPresets.names[i];
          final isSelected = name == currentPreset;
          return GestureDetector(
            onTap: enabled ? () => onSelect(name) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryViolet
                    : AppTheme.darkCardAlt,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryViolet
                      : AppTheme.darkBorder,
                ),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : enabled
                          ? AppTheme.darkTextSecondary
                          : AppTheme.darkTextMuted,
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5-Band EQ
// ─────────────────────────────────────────────────────────────────────────────
class _FiveBandEq extends StatelessWidget {
  final List<int> bands;
  final bool enabled;
  final void Function(int band, int milliBels) onBandChanged;

  static const _frequencies = ['60Hz', '230Hz', '910Hz', '3.6K', '14K'];
  static const _min = -1500.0;
  static const _max = 1500.0;

  const _FiveBandEq({
    required this.bands,
    required this.enabled,
    required this.onBandChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // dB scale header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('+15 dB',
                style: TextStyle(
                    color: AppTheme.darkTextMuted, fontSize: 10)),
            Text('0 dB',
                style: TextStyle(
                    color: AppTheme.darkTextMuted, fontSize: 10)),
            Text('-15 dB',
                style: TextStyle(
                    color: AppTheme.darkTextMuted, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(bands.length > 5 ? 5 : bands.length, (i) {
            return _BandSlider(
              frequency: _frequencies[i],
              value: bands.length > i ? bands[i].toDouble() : 0.0,
              min: _min,
              max: _max,
              enabled: enabled,
              color: _bandColor(i),
              onChanged: (v) => onBandChanged(i, v.round()),
            );
          }),
        ),
      ],
    );
  }

  Color _bandColor(int band) {
    const colors = [
      AppTheme.accentCyan,
      Colors.green,
      AppTheme.accentGold,
      Colors.orange,
      AppTheme.accentPink,
    ];
    return colors[band % colors.length];
  }
}

class _BandSlider extends StatelessWidget {
  final String frequency;
  final double value;
  final double min;
  final double max;
  final bool enabled;
  final Color color;
  final ValueChanged<double> onChanged;

  const _BandSlider({
    required this.frequency,
    required this.value,
    required this.min,
    required this.max,
    required this.enabled,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final db = (value / 100).toStringAsFixed(1);
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          Text(
            '${db}dB',
            style: TextStyle(
              color: enabled ? color : AppTheme.darkTextMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  activeTrackColor: enabled ? color : AppTheme.darkBorder,
                  inactiveTrackColor: AppTheme.darkBorder,
                  thumbColor: enabled ? color : AppTheme.darkBorder,
                  overlayColor: color.withOpacity(0.15),
                ),
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  onChanged: enabled ? onChanged : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            frequency,
            style: TextStyle(
              color: AppTheme.darkTextMuted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Effect Slider
// ─────────────────────────────────────────────────────────────────────────────
class _EffectSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final bool enabled;
  final String valueLabel;
  final ValueChanged<double> onChanged;

  const _EffectSlider({
    required this.label,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.enabled,
    required this.valueLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryViolet),
            const SizedBox(width: 8),
            Text(label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(
              valueLabel,
              style: TextStyle(
                color: enabled
                    ? AppTheme.primaryViolet
                    : AppTheme.darkTextMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: enabled ? onChanged : null,
          activeColor: AppTheme.primaryViolet,
          inactiveColor: AppTheme.darkBorder,
        ),
      ],
    );
  }
}
