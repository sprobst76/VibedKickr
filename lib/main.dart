import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'core/ble/ble_manager.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize BLE (will gracefully handle unsupported platforms)
  try {
    await BleManager.instance.initialize();
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
