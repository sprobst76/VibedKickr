import 'package:flutter/material.dart';

import '../../main.dart';
import '../ble/ble_manager.dart';

/// Beobachtet App-Lebenszyklusänderungen für BLE-Reconnection
class AppLifecycleObserver with WidgetsBindingObserver {
  final BleManager bleManager;

  AppLifecycleObserver(this.bleManager) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App kam in den Vordergrund
        logger.i('App resumed - checking BLE connection');
        _handleAppResumed();

      case AppLifecycleState.paused:
        // App geht in den Hintergrund
        logger.i('App paused');
        _handleAppPaused();

      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Keine Aktion erforderlich
        break;
    }
  }

  void _handleAppResumed() {
    // Wenn Auto-Reconnect aktiviert und Trainer disconnected ist, versuche zu reconnecten
    // Dies ist besonders wichtig für iOS, wo die Verbindung bei Backgrounding droppt
    if (bleManager.autoReconnectEnabled && bleManager.currentState.isDisconnected) {
      logger.i('App resumed with disconnected trainer - attempting reconnect');

      // Gib dem BLE-Stack etwas Zeit zum Stabilisieren
      Future.delayed(const Duration(milliseconds: 500), () {
        bleManager.reconnectTrainer();
      });
    }

    // Gleiches für HR Monitor
    if (bleManager.autoReconnectEnabled && bleManager.hrCurrentState.isDisconnected) {
      logger.i('App resumed with disconnected HR monitor - attempting reconnect');

      Future.delayed(const Duration(milliseconds: 500), () async {
        await bleManager.startScan(timeout: const Duration(seconds: 5));
        // Die automatische Reconnect-Logik im BLE Manager wird die Reconnection behandeln
      });
    }
  }

  void _handleAppPaused() {
    // Bei iOS: BLE wird nach ~10 Sekunden Hintergrund disconnected
    // Bei Android: Verbindung wird typischerweise beibehalten
    // Keine spezielle Aktion erforderlich - Lebenszykluslogik wird beim Resume gehandhabt
  }

  /// Cleanup - Call wenn Observer nicht mehr nötig
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
