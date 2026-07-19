import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/network_manager_service.dart';
import '../../../../shared/widgets/common_widgets.dart';

final _networkSettingsProvider =
    FutureProvider<NetworkSettings>((ref) async {
  final service = ref.watch(networkManagerProvider);
  await service.load();
  return service.settings;
});

/// Issue 013 — Network Manager Screen
class NetworkManagerScreen extends ConsumerStatefulWidget {
  const NetworkManagerScreen({super.key});

  @override
  ConsumerState<NetworkManagerScreen> createState() =>
      _NetworkManagerScreenState();
}

class _NetworkManagerScreenState
    extends ConsumerState<NetworkManagerScreen> {
  NetworkSettings? _settings;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final service = ref.read(networkManagerProvider);
      await service.load();
      if (mounted) {
        setState(() => _settings = service.settings);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_settings == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final s = _settings!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Manager'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Network Access ────────────────────────────────────────
                _sectionLabel('Network Access'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Wi-Fi Only'),
                        subtitle: const Text(
                            'Only download on Wi-Fi connections'),
                        value: s.wifiOnly,
                        onChanged: (v) => _update(s.copyWith(wifiOnly: v)),
                        secondary: const Icon(Icons.wifi_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      const Divider(height: 1, indent: 56),
                      SwitchListTile(
                        title: const Text('Allow Mobile Data'),
                        subtitle: const Text('Download on cellular network'),
                        value: s.allowMobileData,
                        onChanged: (v) =>
                            _update(s.copyWith(allowMobileData: v)),
                        secondary: const Icon(Icons.signal_cellular_alt_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      const Divider(height: 1, indent: 56),
                      SwitchListTile(
                        title: const Text('Roaming Protection'),
                        subtitle: const Text('Pause downloads when roaming'),
                        value: s.roamingProtection,
                        onChanged: (v) =>
                            _update(s.copyWith(roamingProtection: v)),
                        secondary: const Icon(Icons.travel_explore_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 20),

                // ── Connection Settings ───────────────────────────────────
                _sectionLabel('Connection'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.timer_outlined),
                        title: const Text('Connection Timeout'),
                        subtitle:
                            Text('${s.connectTimeoutSeconds} seconds'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [10, 20, 30, 60].map((v) {
                            final sel = v == s.connectTimeoutSeconds;
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: GestureDetector(
                                onTap: () => _update(
                                    s.copyWith(connectTimeoutSeconds: v)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? AppTheme.primaryViolet
                                        : AppTheme.darkCardAlt,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('${v}s',
                                      style: TextStyle(
                                          color: sel
                                              ? Colors.white
                                              : AppTheme.darkTextSecondary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.replay_rounded),
                        title: const Text('Retry Count'),
                        subtitle: Text(
                            '${s.retryCount} retries on failure'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [0, 1, 3, 5].map((v) {
                            final sel = v == s.retryCount;
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: GestureDetector(
                                onTap: () =>
                                    _update(s.copyWith(retryCount: v)),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? AppTheme.primaryViolet
                                        : AppTheme.darkCardAlt,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('$v',
                                      style: TextStyle(
                                          color: sel
                                              ? Colors.white
                                              : AppTheme.darkTextSecondary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                const SizedBox(height: 20),

                // ── Proxy ─────────────────────────────────────────────────
                _sectionLabel('Proxy'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Enable Proxy'),
                        value: s.proxyEnabled,
                        onChanged: (v) =>
                            _update(s.copyWith(proxyEnabled: v)),
                        secondary: const Icon(Icons.public_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      if (s.proxyEnabled) ...[
                        const Divider(height: 1, indent: 56),
                        // Proxy type
                        ListTile(
                          leading:
                              const Icon(Icons.vpn_lock_rounded),
                          title: const Text('Proxy Type'),
                          trailing: DropdownButton<ProxyType>(
                            value: s.proxyType,
                            underline: const SizedBox(),
                            items: ProxyType.values
                                .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t.label),
                                    ))
                                .toList(),
                            onChanged: (t) =>
                                _update(s.copyWith(proxyType: t)),
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Host',
                                    hintText: '192.168.1.1',
                                  ),
                                  controller: TextEditingController(
                                      text: s.proxyHost),
                                  onChanged: (v) =>
                                      _update(s.copyWith(proxyHost: v)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Port',
                                    hintText: '8080',
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                      text: '${s.proxyPort}'),
                                  onChanged: (v) => _update(
                                      s.copyWith(proxyPort: int.tryParse(v) ?? 8080)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _update(NetworkSettings settings) {
    setState(() => _settings = settings);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final service = ref.read(networkManagerProvider);
    await service.save(_settings!);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Network settings saved'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.primaryViolet,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
