import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_theme.dart';

/// Issue 017 — Built-in Browser with download interception and video detection
class BrowserScreen extends StatefulWidget {
  final String? initialUrl;
  final void Function(String url)? onDownloadDetected;

  const BrowserScreen({super.key, this.initialUrl, this.onDownloadDetected});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late final WebViewController _controller;
  final _urlCtrl = TextEditingController();
  bool _isLoading = false;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String _currentUrl = '';
  String _title = '';
  double _progress = 0;
  bool _incognito = false;
  final List<String> _history = [];
  final List<String> _bookmarks = [];
  bool _showBookmarks = false;

  static const _homeUrl = 'https://www.google.com';
  static final _downloadMimeTypes = {
    'application/zip', 'application/x-rar-compressed',
    'application/pdf', 'video/mp4', 'audio/mpeg',
    'application/vnd.android.package-archive',
    'application/octet-stream',
  };

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _progress = p / 100.0),
        onPageStarted: (url) {
          setState(() {
            _isLoading = true;
            _currentUrl = url;
            _urlCtrl.text = url;
          });
          _updateNavState();
        },
        onPageFinished: (url) async {
          setState(() {
            _isLoading = false;
            _currentUrl = url;
          });
          _title = await _controller.getTitle() ?? '';
          _updateHistory(url);
          _updateNavState();
          // Inject ad blocker / popup blocker JS
          await _injectUtils();
        },
        onNavigationRequest: (request) {
          final url = request.url;
          // Intercept downloads by URL pattern or MIME-suggested extensions
          if (_isDownloadUrl(url)) {
            widget.onDownloadDetected?.call(url);
            _showDownloadPrompt(url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onHttpError: (err) {
          // Silently handle HTTP errors
        },
      ))
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Mobile Safari/537.36 NovaPlayer/1.0')
      ..loadRequest(Uri.parse(widget.initialUrl ?? _homeUrl));
  }

  Future<void> _injectUtils() async {
    // Basic popup blocker
    await _controller.runJavaScript('''
      // Block window.open popups
      window.open = function() { return null; };
      // Remove overlay ads
      document.querySelectorAll('[id*="ad"], [class*="ad-"], [class*="popup"]').forEach(el => {
        if (el.style) { el.style.display = 'none'; }
      });
    ''');
    // Video detection
    final videos = await _controller
        .runJavaScriptReturningResult('''
      (function() {
        var vids = document.querySelectorAll('video, source');
        var urls = [];
        vids.forEach(function(v) {
          if (v.src) urls.push(v.src);
          if (v.currentSrc) urls.push(v.currentSrc);
        });
        return JSON.stringify([...new Set(urls)].filter(u => u.startsWith('http')));
      })()
    ''');
    final raw = videos.toString().replaceAll('"', '');
    if (raw.isNotEmpty && raw != 'null' && raw != '[]') {
      _showVideoDetected(raw);
    }
  }

  bool _isDownloadUrl(String url) {
    final lower = url.toLowerCase();
    const downloadExts = [
      '.mp4', '.mkv', '.avi', '.mov', '.webm', '.mp3', '.aac', '.flac',
      '.pdf', '.zip', '.rar', '.7z', '.apk', '.exe', '.iso', '.dmg',
      '.ts', '.m3u8', '.mpd',
    ];
    return downloadExts.any((ext) => lower.endsWith(ext)) ||
        lower.contains('download=true') ||
        lower.contains('forcedownload');
  }

  void _showDownloadPrompt(String url) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Download Detected',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 8),
            Text(url,
                style: const TextStyle(color: AppTheme.darkTextMuted, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.onDownloadDetected?.call(url);
                      Navigator.pop(context, url);
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download'),
                    style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryViolet),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoDetected(String videosJson) {
    // Show a snackbar hinting at video detection
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Video detected on this page'),
          ],
        ),
        action: SnackBarAction(
          label: 'Download',
          onPressed: () {
            Navigator.pop(context, videosJson);
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _updateHistory(String url) {
    if (!_incognito) {
      _history.add(url);
    }
  }

  Future<void> _updateNavState() async {
    final back = await _controller.canGoBack();
    final forward = await _controller.canGoForward();
    if (mounted) {
      setState(() {
        _canGoBack = back;
        _canGoForward = forward;
      });
    }
  }

  void _navigate(String input) {
    String url = input.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      if (url.contains('.') && !url.contains(' ')) {
        url = 'https://$url';
      } else {
        url = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
      }
    }
    _controller.loadRequest(Uri.parse(url));
    setState(() => _showBookmarks = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            if (_isLoading)
              LinearProgressIndicator(
                value: _progress,
                color: AppTheme.primaryViolet,
                backgroundColor: Colors.transparent,
                minHeight: 2,
              ),
            Expanded(
              child: _showBookmarks
                  ? _buildBookmarksPanel()
                  : WebViewWidget(controller: _controller),
            ),
            _buildNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: AppTheme.darkBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.darkCardAlt,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _urlCtrl,
                onSubmitted: _navigate,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  hintText: 'Search or enter URL',
                  hintStyle:
                      const TextStyle(fontSize: 13, color: AppTheme.darkTextMuted),
                  isDense: true,
                  prefixIcon: Icon(
                    _currentUrl.startsWith('https')
                        ? Icons.lock_rounded
                        : Icons.info_outline_rounded,
                    size: 16,
                    color: _currentUrl.startsWith('https')
                        ? Colors.green
                        : Colors.orange,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _incognito ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              size: 20,
              color: _incognito ? AppTheme.accentPink : null,
            ),
            onPressed: () => setState(() => _incognito = !_incognito),
            tooltip: 'Incognito',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 20),
            onPressed: () => _showMenu(context),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: AppTheme.darkBorder, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: _canGoBack ? () => _controller.goBack() : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            onPressed: _canGoForward ? () => _controller.goForward() : null,
          ),
          IconButton(
            icon: Icon(_isLoading ? Icons.close_rounded : Icons.refresh_rounded,
                size: 20),
            onPressed: () {
              if (_isLoading) {
                _controller.loadRequest(Uri.parse(_currentUrl));
              } else {
                _controller.reload();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.home_rounded, size: 20),
            onPressed: () => _controller.loadRequest(Uri.parse(_homeUrl)),
          ),
          IconButton(
            icon: Icon(
              _bookmarks.contains(_currentUrl)
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              size: 20,
              color: _bookmarks.contains(_currentUrl)
                  ? AppTheme.accentGold
                  : null,
            ),
            onPressed: () {
              if (_bookmarks.contains(_currentUrl)) {
                setState(() => _bookmarks.remove(_currentUrl));
              } else {
                setState(() => _bookmarks.add(_currentUrl));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.book_rounded, size: 20),
            onPressed: () =>
                setState(() => _showBookmarks = !_showBookmarks),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Bookmarks',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (_bookmarks.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No bookmarks yet',
                  style: TextStyle(color: AppTheme.darkTextMuted)),
            ),
          ),
        ...(_bookmarks.reversed
            .map((url) => ListTile(
                  leading: const Icon(Icons.bookmark_rounded,
                      color: AppTheme.accentGold, size: 20),
                  title: Text(url,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    setState(() => _showBookmarks = false);
                    _navigate(url);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () =>
                        setState(() => _bookmarks.remove(url)),
                  ),
                ))
            .toList()),
        const SizedBox(height: 16),
        Text('History', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...(_history.reversed
            .take(50)
            .map((url) => ListTile(
                  leading: const Icon(Icons.history_rounded, size: 20),
                  title: Text(url,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13)),
                  onTap: () {
                    setState(() => _showBookmarks = false);
                    _navigate(url);
                  },
                ))
            .toList()),
      ],
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Share URL'),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: const Text('Download Page Resource'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pop(context, _currentUrl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Clear History'),
              onTap: () {
                setState(() => _history.clear());
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }
}
