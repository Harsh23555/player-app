import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_theme.dart';

/// Issue 016 — QR Code Download Scanner
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _scanned = false;
  String? _scannedUrl;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final raw = barcode.rawValue;
      if (raw == null) continue;
      // Validate it's a URL
      if (raw.startsWith('http://') || raw.startsWith('https://')) {
        setState(() {
          _scanned = true;
          _scannedUrl = raw;
        });
        _controller.stop();
        _showResult(raw);
        return;
      }
    }
  }

  void _showResult(String url) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (ctx) => _QrResultSheet(
        url: url,
        onDownload: (u) {
          Navigator.pop(ctx);
          Navigator.pop(context, u);
        },
        onRescan: () {
          Navigator.pop(ctx);
          setState(() {
            _scanned = false;
            _scannedUrl = null;
            _controller.start();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Scan QR Code'),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (ctx, state, _) => IconButton(
              icon: Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on_rounded
                    : Icons.flash_off_rounded,
                color: state.torchState == TorchState.on ? Colors.yellow : Colors.white,
              ),
              onPressed: _controller.toggleTorch,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ScanOverlayPainter(),
          ),

          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Point your camera at a QR code containing a download URL',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 800.ms),
          ),
        ],
      ),
    );
  }
}

class _QrResultSheet extends StatelessWidget {
  final String url;
  final void Function(String) onDownload;
  final VoidCallback onRescan;

  const _QrResultSheet({
    required this.url,
    required this.onDownload,
    required this.onRescan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.qr_code_scanner_rounded, color: Colors.green),
              ),
              const SizedBox(width: 12),
              const Text('QR Code Detected',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              url,
              style: const TextStyle(
                  color: Colors.white70, fontFamily: 'monospace', fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRescan,
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                  label: const Text('Scan Again'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white30)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () => onDownload(url),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download Now'),
                  style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryViolet),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    ).animate().slideY(begin: 0.3).fadeIn(duration: 300.ms);
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final scanSize = size.width * 0.7;
    final left = (size.width - scanSize) / 2;
    final top = (size.height - scanSize) / 2;
    final scanRect = Rect.fromLTWH(left, top, scanSize, scanSize);

    // Draw darkened areas around scanner
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, top), paint);
    canvas.drawRect(
        Rect.fromLTWH(0, top + scanSize, size.width, size.height - top - scanSize),
        paint);
    canvas.drawRect(Rect.fromLTWH(0, top, left, scanSize), paint);
    canvas.drawRect(
        Rect.fromLTWH(left + scanSize, top, size.width - left - scanSize, scanSize),
        paint);

    // Corner brackets
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const cornerLen = 24.0;
    final corners = [
      // Top-left
      [Offset(left, top + cornerLen), Offset(left, top), Offset(left + cornerLen, top)],
      // Top-right
      [
        Offset(left + scanSize - cornerLen, top),
        Offset(left + scanSize, top),
        Offset(left + scanSize, top + cornerLen)
      ],
      // Bottom-left
      [
        Offset(left, top + scanSize - cornerLen),
        Offset(left, top + scanSize),
        Offset(left + cornerLen, top + scanSize)
      ],
      // Bottom-right
      [
        Offset(left + scanSize - cornerLen, top + scanSize),
        Offset(left + scanSize, top + scanSize),
        Offset(left + scanSize, top + scanSize - cornerLen)
      ],
    ];

    for (final points in corners) {
      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, cornerPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
