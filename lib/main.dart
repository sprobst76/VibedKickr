import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'core/ble/ble_manager.dart';
import 'core/lifecycle/app_lifecycle_observer.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
  ),
);

// Global app lifecycle observer - für BLE Reconnection bei App Resume
// ignore: unused_field
late AppLifecycleObserver _appLifecycleObserver;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize BLE (will gracefully handle unsupported platforms)
  try {
    await BleManager.instance.initialize();

    // Initialisiere App Lifecycle Observer für BLE Reconnection
    _appLifecycleObserver = AppLifecycleObserver(BleManager.instance);
  } catch (e) {
    logger.e('BLE initialization failed: $e');
    // App will continue without BLE support
  }

  runApp(
    const ProviderScope(
      child: KickrTrainerApp(),
    ),
  );
}
