import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/equalizer_provider.dart';

class EqualizerSheet extends ConsumerWidget {
  const EqualizerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(equalizerProvider);
    final notifier = ref.read(equalizerProvider.notifier);

    if (!state.isLoaded) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.equalizer_rounded,
                size: 48, color: AppTheme.darkTextMuted),
            const SizedBox(height: 16),
            Text(
              'Equalizer not available on this device',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.85,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.darkBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryViolet.withOpacity(0.2),
                        AppTheme.accentCyan.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.equalizer_rounded,
                      color: AppTheme.primaryViolet, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Equalizer',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        state.activePreset ?? 'Custom',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryViolet,
                            ),
                      ),
                    ],
                  ),
                ),
                // Enable/disable switch
                Switch(
                  value: state.enabled,
                  onChanged: (v) => notifier.setEnabled(v),
                  activeColor: AppTheme.primaryViolet,
                  activeTrackColor: AppTheme.primaryViolet.withOpacity(0.3),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Preset chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: notifier.presetNames.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final name = notifier.presetNames[i];
                  final isSelected = state.activePreset == name;
                  return GestureDetector(
                    onTap: state.enabled
                        ? () => notifier.applyPreset(name)
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  AppTheme.primaryViolet,
                                  AppTheme.primaryDeep,
                                ],
                              )
                            : null,
                        color: isSelected ? null : AppTheme.darkCardAlt,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: AppTheme.darkBorder, width: 0.5),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : state.enabled
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.darkTextMuted,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Band sliders
          Expanded(
            child: AnimatedOpacity(
              opacity: state.enabled ? 1.0 : 0.35,
              duration: const Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(state.bandGains.length, (i) {
                    return Expanded(
                      child: _BandSlider(
                        frequency: state.bandFrequencies[i],
                        gain: state.bandGains[i],
                        minGain: state.minDecibels,
                        maxGain: state.maxDecibels,
                        enabled: state.enabled,
                        onChanged: (v) => notifier.setBandGain(i, v),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // Reset button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: state.enabled ? () => notifier.resetToFlat() : null,
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text('Reset to Flat'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.darkTextSecondary,
                  side: const BorderSide(color: AppTheme.darkBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BandSlider extends StatelessWidget {
  final int frequency;
  final double gain;
  final double minGain;
  final double maxGain;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _BandSlider({
    required this.frequency,
    required this.gain,
    required this.minGain,
    required this.maxGain,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final label = EqualizerNotifier.formatFrequency(frequency);
    final gainLabel = '${gain > 0 ? '+' : ''}${gain.toStringAsFixed(1)}';
    final isPositive = gain > 0;
    final isNegative = gain < 0;

    return Column(
      children: [
        // Gain value
        Text(
          gainLabel,
          style: TextStyle(
            color: isPositive
                ? AppTheme.accentCyan
                : isNegative
                    ? AppTheme.accentPink
                    : AppTheme.darkTextMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        // Vertical slider
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: AppTheme.primaryViolet,
                inactiveTrackColor: AppTheme.darkBorder,
                thumbColor: Colors.white,
                overlayColor: AppTheme.primaryViolet.withOpacity(0.15),
              ),
              child: Slider(
                value: gain.clamp(minGain, maxGain),
                min: minGain,
                max: maxGain,
                onChanged: enabled ? onChanged : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Frequency label
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.darkTextMuted,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
