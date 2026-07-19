import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';

/// Issue 012 — Schedule Download Bottom Sheet
class ScheduleDownloadSheet extends StatefulWidget {
  final void Function(
    String url,
    String fileName,
    DateTime scheduledAt,
    bool wifiOnly,
    bool chargingOnly,
  ) onSchedule;

  const ScheduleDownloadSheet({super.key, required this.onSchedule});

  @override
  State<ScheduleDownloadSheet> createState() => _ScheduleDownloadSheetState();
}

class _ScheduleDownloadSheetState extends State<ScheduleDownloadSheet> {
  final _urlCtrl = TextEditingController();
  final _fileNameCtrl = TextEditingController();
  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 1));
  bool _wifiOnly = true;
  bool _chargingOnly = false;
  bool _nightMode = false;

  @override
  void dispose() {
    _urlCtrl.dispose();
    _fileNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null) return;

    setState(() {
      _scheduledAt = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _setNightMode() {
    final now = DateTime.now();
    var nightTime = DateTime(now.year, now.month, now.day, 2, 0, 0);
    if (nightTime.isBefore(now)) {
      nightTime = nightTime.add(const Duration(days: 1));
    }
    setState(() {
      _nightMode = true;
      _scheduledAt = nightTime;
      _wifiOnly = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.darkBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.schedule_rounded,
                            color: AppTheme.accentGold, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('Schedule Download',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 24),

                  // URL
                  const Text('URL'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _urlCtrl,
                    decoration: const InputDecoration(
                        hintText: 'https://…', prefixIcon: Icon(Icons.link_rounded)),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),

                  // File name
                  const Text('File Name'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _fileNameCtrl,
                    decoration: const InputDecoration(
                        hintText: 'filename.mp4',
                        prefixIcon: Icon(Icons.drive_file_rename_outline_rounded)),
                  ),
                  const SizedBox(height: 24),

                  // Quick schedule options
                  Text('Quick Schedule',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _QuickChip(
                        label: '1 hour',
                        icon: Icons.schedule_rounded,
                        onTap: () => setState(() {
                          _nightMode = false;
                          _scheduledAt =
                              DateTime.now().add(const Duration(hours: 1));
                        }),
                      ),
                      _QuickChip(
                        label: '6 hours',
                        icon: Icons.schedule_rounded,
                        onTap: () => setState(() {
                          _nightMode = false;
                          _scheduledAt =
                              DateTime.now().add(const Duration(hours: 6));
                        }),
                      ),
                      _QuickChip(
                        label: 'Tonight 2 AM',
                        icon: Icons.nights_stay_rounded,
                        onTap: _setNightMode,
                        accentColor: AppTheme.primaryViolet,
                      ),
                      _QuickChip(
                        label: 'Custom',
                        icon: Icons.calendar_today_rounded,
                        onTap: _pickDateTime,
                        accentColor: AppTheme.accentCyan,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Selected time display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.accentGold.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            color: AppTheme.accentGold, size: 20),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Scheduled for',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.darkTextMuted)),
                            Text(
                              _formatDateTime(_scheduledAt),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.accentGold),
                            ),
                            Text(
                              'In ${_formatDuration(_scheduledAt.difference(DateTime.now()))}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.darkTextMuted),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _pickDateTime,
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Conditions
                  Text('Conditions',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Wi-Fi Only'),
                    subtitle: const Text('Start only when connected to Wi-Fi'),
                    secondary: const Icon(Icons.wifi_rounded),
                    value: _wifiOnly,
                    onChanged: (v) => setState(() => _wifiOnly = v),
                    activeColor: AppTheme.primaryViolet,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: const Text('Charging Only'),
                    subtitle:
                        const Text('Start only when device is charging'),
                    secondary: const Icon(Icons.battery_charging_full_rounded),
                    value: _chargingOnly,
                    onChanged: (v) => setState(() => _chargingOnly = v),
                    activeColor: AppTheme.primaryViolet,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  // Schedule button
                  FilledButton.icon(
                    onPressed: _urlCtrl.text.isEmpty || _fileNameCtrl.text.isEmpty
                        ? null
                        : () => widget.onSchedule(
                              _urlCtrl.text.trim(),
                              _fileNameCtrl.text.trim(),
                              _scheduledAt,
                              _wifiOnly,
                              _chargingOnly,
                            ),
                    icon: const Icon(Icons.schedule_send_rounded),
                    label: const Text('Schedule Download'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:$min';
  }

  String _formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours % 24}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    return '${d.inMinutes}m';
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;

  const _QuickChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.accentColor = AppTheme.accentGold,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: accentColor),
      label: Text(label,
          style: TextStyle(color: accentColor, fontSize: 12)),
      onPressed: onTap,
      backgroundColor: accentColor.withOpacity(0.08),
      side: BorderSide(color: accentColor.withOpacity(0.3)),
    );
  }
}
