import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/multi_thread_download_service.dart';
import '../../../../shared/widgets/common_widgets.dart';

/// Issue 001, 003 — Add Download Bottom Sheet with URL validation and thread config
class AddDownloadSheet extends ConsumerStatefulWidget {
  final String? initialUrl;
  final void Function(String url, String fileName, int threads) onDownload;

  const AddDownloadSheet({
    super.key,
    this.initialUrl,
    required this.onDownload,
  });

  @override
  ConsumerState<AddDownloadSheet> createState() => _AddDownloadSheetState();
}

class _AddDownloadSheetState extends ConsumerState<AddDownloadSheet> {
  late final TextEditingController _urlCtrl;
  late final TextEditingController _fileNameCtrl;
  bool _isValidating = false;
  UrlValidationResult? _validation;
  int _threadCount = 4;
  int _priority = 0;
  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(text: widget.initialUrl ?? '');
    _fileNameCtrl = TextEditingController();
    if (widget.initialUrl != null && widget.initialUrl!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _validate());
    }
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _fileNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    if (_urlCtrl.text.trim().isEmpty) return;
    setState(() => _isValidating = true);
    final service = ref.read(multiThreadDownloadServiceProvider);
    final result = await service.validateUrl(_urlCtrl.text.trim());
    if (mounted) {
      setState(() {
        _isValidating = false;
        _validation = result;
        if (result.valid && result.fileName != null) {
          _fileNameCtrl.text = result.fileName!;
          _threadCount = result.suggestedThreads ?? 4;
        }
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      _urlCtrl.text = data!.text!;
      _validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
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
                          color: AppTheme.primaryViolet.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.download_rounded,
                            color: AppTheme.primaryViolet, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('New Download',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 24),

                  // URL Input
                  Text('URL', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlCtrl,
                          onChanged: (_) => setState(() => _validation = null),
                          onSubmitted: (_) => _validate(),
                          decoration: InputDecoration(
                            hintText: 'https://example.com/file.mp4',
                            prefixIcon: const Icon(Icons.link_rounded),
                            suffixIcon: _isValidating
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2)))
                                : _validation != null
                                    ? Icon(
                                        _validation!.valid
                                            ? Icons.check_circle_rounded
                                            : Icons.error_rounded,
                                        color: _validation!.valid
                                            ? Colors.green
                                            : Colors.red)
                                    : null,
                            errorText:
                                _validation?.valid == false ? _validation?.error : null,
                          ),
                          keyboardType: TextInputType.url,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _pasteFromClipboard,
                        icon: const Icon(Icons.content_paste_rounded),
                        tooltip: 'Paste',
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.darkCardAlt,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),

                  // File info preview
                  if (_validation?.valid == true) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: Colors.green, size: 16),
                              const SizedBox(width: 6),
                              const Text('URL Valid',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                              const Spacer(),
                              if (_validation?.supportsResume == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentCyan.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('Resume Support',
                                      style: TextStyle(
                                          color: AppTheme.accentCyan,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700)),
                                ),
                            ],
                          ),
                          if (_validation?.fileSize != null) ...[
                            const SizedBox(height: 4),
                            _InfoRow('Size',
                                _formatBytes(_validation!.fileSize!)),
                          ],
                          if (_validation?.mimeType != null) ...[
                            const SizedBox(height: 2),
                            _InfoRow('Type', _validation!.mimeType!),
                          ],
                          _InfoRow('Threads',
                              '${_validation?.suggestedThreads ?? 1} recommended'),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                  ],

                  const SizedBox(height: 16),

                  // File Name
                  Text('File Name',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _fileNameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Enter file name',
                      prefixIcon: Icon(Icons.drive_file_rename_outline_rounded),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Thread count selector (Issue 003)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Download Threads',
                          style: Theme.of(context).textTheme.labelLarge),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _showAdvanced = !_showAdvanced),
                        child: Text(
                          _showAdvanced ? 'Hide' : 'Show Advanced',
                          style: TextStyle(
                              color: AppTheme.accentCyan, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [1, 2, 4, 8, 16].map((t) {
                      final isSelected = t == _threadCount;
                      return Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () => setState(() => _threadCount = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryViolet
                                    : AppTheme.darkCardAlt,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: AppTheme.darkBorder, width: 0.5),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$t',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.darkTextSecondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    t == 1 ? 'thread' : 'threads',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white70
                                          : AppTheme.darkTextMuted,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  if (_showAdvanced) ...[
                    const SizedBox(height: 16),
                    Text('Priority', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final (p, label) in [(0, 'Normal'), (1, 'High'), (2, 'Critical')])
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: GestureDetector(
                                onTap: () => setState(() => _priority = p),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _priority == p
                                        ? AppTheme.accentGold
                                        : AppTheme.darkCardAlt,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _priority == p
                                          ? Colors.black
                                          : AppTheme.darkTextSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isValidating ? null : _validate,
                          icon: const Icon(Icons.verified_rounded, size: 16),
                          label: const Text('Validate'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: (_validation?.valid != true ||
                                  _fileNameCtrl.text.isEmpty)
                              ? null
                              : () => widget.onDownload(
                                    _urlCtrl.text.trim(),
                                    _fileNameCtrl.text.trim(),
                                    _threadCount,
                                  ),
                          icon: const Icon(Icons.download_rounded),
                          label: const Text('Start Download'),
                          style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryViolet),
                        ),
                      ),
                    ],
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

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontSize: 12, color: AppTheme.darkTextMuted)),
          Flexible(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkTextSecondary,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
