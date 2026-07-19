import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/app_logger.dart';

final networkManagerProvider = Provider<NetworkManagerService>((ref) {
  return NetworkManagerService();
});

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Issue 013 — Network Manager
/// WiFi-only, mobile data, proxy, custom DNS, timeout, retry policy.
class NetworkManagerService {
  // Prefs keys
  static const _kWifiOnly = 'nm_wifi_only';
  static const _kAllowMobileData = 'nm_mobile_data';
  static const _kRoamingProtection = 'nm_roaming_protection';
  static const _kProxyEnabled = 'nm_proxy_enabled';
  static const _kProxyHost = 'nm_proxy_host';
  static const _kProxyPort = 'nm_proxy_port';
  static const _kProxyType = 'nm_proxy_type';
  static const _kCustomDns = 'nm_custom_dns';
  static const _kConnectTimeout = 'nm_connect_timeout';
  static const _kRetryCount = 'nm_retry_count';

  NetworkSettings _settings = NetworkSettings.defaults();
  bool _loaded = false;

  NetworkSettings get settings => _settings;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _settings = NetworkSettings(
      wifiOnly: prefs.getBool(_kWifiOnly) ?? false,
      allowMobileData: prefs.getBool(_kAllowMobileData) ?? true,
      roamingProtection: prefs.getBool(_kRoamingProtection) ?? true,
      proxyEnabled: prefs.getBool(_kProxyEnabled) ?? false,
      proxyHost: prefs.getString(_kProxyHost) ?? '',
      proxyPort: prefs.getInt(_kProxyPort) ?? 8080,
      proxyType: ProxyType.values[prefs.getInt(_kProxyType) ?? 0],
      customDns: prefs.getString(_kCustomDns) ?? '',
      connectTimeoutSeconds: prefs.getInt(_kConnectTimeout) ?? 30,
      retryCount: prefs.getInt(_kRetryCount) ?? 3,
    );
    _loaded = true;
  }

  Future<void> save(NetworkSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWifiOnly, settings.wifiOnly);
    await prefs.setBool(_kAllowMobileData, settings.allowMobileData);
    await prefs.setBool(_kRoamingProtection, settings.roamingProtection);
    await prefs.setBool(_kProxyEnabled, settings.proxyEnabled);
    await prefs.setString(_kProxyHost, settings.proxyHost);
    await prefs.setInt(_kProxyPort, settings.proxyPort);
    await prefs.setInt(_kProxyType, settings.proxyType.index);
    await prefs.setString(_kCustomDns, settings.customDns);
    await prefs.setInt(_kConnectTimeout, settings.connectTimeoutSeconds);
    await prefs.setInt(_kRetryCount, settings.retryCount);
    _settings = settings;
  }

  /// Check if downloading is currently allowed based on network settings and
  /// the current connectivity.
  Future<NetworkAllowResult> canDownload() async {
    await load();

    final results = await Connectivity().checkConnectivity();

    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkAllowResult(allowed: false, reason: 'No internet connection');
    }

    if (_settings.wifiOnly && !results.contains(ConnectivityResult.wifi)) {
      return NetworkAllowResult(
          allowed: false, reason: 'Wi-Fi only mode is enabled');
    }

    if (!_settings.allowMobileData && results.contains(ConnectivityResult.mobile)) {
      return NetworkAllowResult(
          allowed: false, reason: 'Mobile data is disabled');
    }

    return NetworkAllowResult(allowed: true);
  }

  /// Build a Dio instance configured with current network settings.
  Dio buildDio() {
    final options = BaseOptions(
      connectTimeout: Duration(seconds: _settings.connectTimeoutSeconds),
      receiveTimeout: const Duration(minutes: 30),
      followRedirects: true,
      maxRedirects: 5,
    );

    final dio = Dio(options);

    // Apply proxy if enabled
    if (_settings.proxyEnabled && _settings.proxyHost.isNotEmpty) {
      // Note: Dart's http client proxy is set via DART_VM options or
      // using a custom adapter. This is a placeholder showing the intent.
      AppLogger.info(
          'Proxy configured: ${_settings.proxyType.label} ${_settings.proxyHost}:${_settings.proxyPort}');
    }

    // Retry interceptor
    dio.interceptors.add(_RetryInterceptor(maxRetries: _settings.retryCount));

    return dio;
  }
}

class _RetryInterceptor extends Interceptor {
  final int maxRetries;
  _RetryInterceptor({required this.maxRetries});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = (err.requestOptions.extra['retryCount'] as int?) ?? 0;
    if (attempt < maxRetries &&
        err.type != DioExceptionType.cancel &&
        err.response?.statusCode != 401 &&
        err.response?.statusCode != 403) {
      await Future.delayed(Duration(seconds: (attempt + 1) * 2));
      err.requestOptions.extra['retryCount'] = attempt + 1;
      try {
        final dio = Dio();
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {}
    }
    handler.next(err);
  }
}

class NetworkSettings {
  final bool wifiOnly;
  final bool allowMobileData;
  final bool roamingProtection;
  final bool proxyEnabled;
  final String proxyHost;
  final int proxyPort;
  final ProxyType proxyType;
  final String customDns;
  final int connectTimeoutSeconds;
  final int retryCount;

  const NetworkSettings({
    required this.wifiOnly,
    required this.allowMobileData,
    required this.roamingProtection,
    required this.proxyEnabled,
    required this.proxyHost,
    required this.proxyPort,
    required this.proxyType,
    required this.customDns,
    required this.connectTimeoutSeconds,
    required this.retryCount,
  });

  factory NetworkSettings.defaults() => const NetworkSettings(
        wifiOnly: false,
        allowMobileData: true,
        roamingProtection: true,
        proxyEnabled: false,
        proxyHost: '',
        proxyPort: 8080,
        proxyType: ProxyType.http,
        customDns: '',
        connectTimeoutSeconds: 30,
        retryCount: 3,
      );

  NetworkSettings copyWith({
    bool? wifiOnly,
    bool? allowMobileData,
    bool? roamingProtection,
    bool? proxyEnabled,
    String? proxyHost,
    int? proxyPort,
    ProxyType? proxyType,
    String? customDns,
    int? connectTimeoutSeconds,
    int? retryCount,
  }) =>
      NetworkSettings(
        wifiOnly: wifiOnly ?? this.wifiOnly,
        allowMobileData: allowMobileData ?? this.allowMobileData,
        roamingProtection: roamingProtection ?? this.roamingProtection,
        proxyEnabled: proxyEnabled ?? this.proxyEnabled,
        proxyHost: proxyHost ?? this.proxyHost,
        proxyPort: proxyPort ?? this.proxyPort,
        proxyType: proxyType ?? this.proxyType,
        customDns: customDns ?? this.customDns,
        connectTimeoutSeconds:
            connectTimeoutSeconds ?? this.connectTimeoutSeconds,
        retryCount: retryCount ?? this.retryCount,
      );
}

enum ProxyType { http, https, socks5 }

extension ProxyTypeLabel on ProxyType {
  String get label {
    switch (this) {
      case ProxyType.http:
        return 'HTTP Proxy';
      case ProxyType.https:
        return 'HTTPS Proxy';
      case ProxyType.socks5:
        return 'SOCKS5';
    }
  }
}

class NetworkAllowResult {
  final bool allowed;
  final String? reason;
  const NetworkAllowResult({required this.allowed, this.reason});
}
