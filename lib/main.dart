import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/app.dart';
import 'core/database/isar_service.dart';
import 'core/utils/global_error_handler.dart';
import 'core/utils/app_logger.dart';
import 'data/models/db/audio_entity.dart';
import 'data/models/db/video_entity.dart';
import 'data/models/db/download_entity.dart';
import 'data/models/db/settings_entity.dart';
import 'data/models/db/recently_played_entity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global error handler
  GlobalErrorHandler.initialize();

  // Lock to portrait initially (can rotate during video playback)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  Isar? isar;
  try {
    // Audio background service
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.novaplayer.app.audio',
      androidNotificationChannelName: 'Nova Player Audio',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
      notificationColor: const Color(0xFF7C4DFF),
      preloadArtwork: true,
    );

    // Flutter Downloader initialization
    await FlutterDownloader.initialize(debug: false, ignoreSsl: true);

    // Initialize Isar database
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        AudioEntitySchema,
        VideoEntitySchema,
        DownloadEntitySchema,
        SettingsEntitySchema,
        RecentlyPlayedEntitySchema,
      ],
      directory: dir.path,
      name: 'nova_player_db',
    );
  } catch (e, stack) {
    AppLogger.fatal('App initialization failed', error: e, stackTrace: stack);
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Color(0xFFFF5252), size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to start Nova Player',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'monospace', color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  runApp(
    ProviderScope(
      observers: [GlobalErrorHandler.observer],
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const NovaPlayerApp(),
    ),
  );
}
