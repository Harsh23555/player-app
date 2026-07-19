package com.novaplayer.app

import android.app.PictureInPictureParams
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {

    private val PIP_CHANNEL = "com.novaplayer.app/pip"
    private val SHARE_CHANNEL = "com.novaplayer.app/share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // PiP channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PIP_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enterPiP" -> {
                    if (startPictureInPictureMode()) {
                        result.success(null)
                    } else {
                        result.error("PIP_FAILED", "Unable to enter PiP mode", null)
                    }
                }
                "isPipSupported" -> {
                    result.success(isPipSupported())
                }
                else -> result.notImplemented()
            }
        }

        // Share channel — Issue 015: Share To Download
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SHARE_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedUrl" -> {
                    val sharedUrl = extractSharedUrl(intent)
                    result.success(sharedUrl)
                }
                else -> result.notImplemented()
            }
        }

        // Handle initial share intent
        handleShareIntent(intent, flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        // Notify Flutter of new share intent
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, SHARE_CHANNEL).invokeMethod(
                "onNewShareIntent",
                extractSharedUrl(intent)
            )
        }
    }

    private fun handleShareIntent(intent: Intent?, flutterEngine: FlutterEngine) {
        val url = extractSharedUrl(intent) ?: return
        // Notify Flutter side
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SHARE_CHANNEL
        ).invokeMethod("onNewShareIntent", url)
    }

    private fun extractSharedUrl(intent: Intent?): String? {
        if (intent == null) return null
        val action = intent.action
        val type = intent.type

        return when {
            // Text/URL shared
            action == Intent.ACTION_SEND && type?.startsWith("text/") == true -> {
                intent.getStringExtra(Intent.EXTRA_TEXT)
                    ?: intent.getStringExtra(Intent.EXTRA_SUBJECT)
            }
            // Stream URL (e.g., from browser download interception)
            action == Intent.ACTION_VIEW -> {
                intent.dataString
            }
            else -> null
        }
    }

    private fun startPictureInPictureMode(): Boolean {
        if (!isPipSupported()) return false
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(Rational(16, 9))
                    .build()
                enterPictureInPictureMode(params)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun isPipSupported(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
        } else {
            false
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // Auto-enter PiP when user presses Home during video playback
        // This is handled from Flutter side via WidgetsBindingObserver
    }
}
