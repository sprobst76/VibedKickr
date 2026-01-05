import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Standalone BLE Diagnose-Seite für Kickr Debugging
class BleDiagnosticPage extends StatefulWidget {
  const BleDiagnosticPage({super.key});

  @override
  State<BleDiagnosticPage> createState() => _BleDiagnosticPageState();
}

class _BleDiagnosticPageState extends State<BleDiagnosticPage> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  List<ScanResult> _scanResults = [];
  BluetoothDevice? _connectedDevice;
  List<BluetoothService>? _services;
  StreamSubscription<List<int>>? _dataSubscription;

  bool _isScanning = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _log('=== BLE Diagnostic Tool ===');
    _checkBleStatus();
  }

  void _log(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs.add('[$timestamp] $message');
    });
    // Auto-scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _checkBleStatus() async {
    _log('Checking BLE status...');

    final isSupported = await FlutterBluePlus.isSupported;
    _log('BLE supported: $isSupported');

    final adapterState = await FlutterBluePlus.adapterState.first;
    _log('Adapter state: $adapterState');
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _scanResults = [];
    });

    _log('Starting scan...');

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final name = result.device.platformName;
          final id = result.device.remoteId.str;
          final rssi = result.rssi;
          final services = result.advertisementData.serviceUuids;

          // Nur Geräte mit Namen oder relevanten Services
          if (name.isNotEmpty || services.isNotEmpty) {
            final existing = _scanResults.indexWhere((r) => r.device.remoteId == result.device.remoteId);
            if (existing < 0) {
              _log('Found: $name ($id) RSSI: $rssi');
              _log('  Services: ${services.map((s) => s.toString().substring(4, 8)).join(", ")}');
              setState(() {
                _scanResults.add(result);
              });
            }
          }
        }
      });

      await Future.delayed(const Duration(seconds: 10));
    } catch (e) {
      _log('Scan error: $e');
    } finally {
      setState(() => _isScanning = false);
      _log('Scan complete. Found ${_scanResults.length} devices');
    }
  }

  Future<void> _connectToDevice(ScanResult result) async {
    if (_isConnecting) return;

    setState(() => _isConnecting = true);

    final device = result.device;
    _log('Connecting to ${device.platformName}...');

    try {
      // Verschiedene Connect-Methoden testen
      _log('Method: autoConnect=false, timeout=30s');

      await device.connect(
        timeout: const Duration(seconds: 30),
        autoConnect: false,
      );

      _log('✓ Connected!');
      setState(() => _connectedDevice = device);

      // Services entdecken
      await _discoverServices();

    } catch (e) {
      _log('✗ Connection failed: $e');

      // Alternative Methode versuchen
      _log('Trying alternative: autoConnect=true...');
      try {
        await device.connect(
          timeout: const Duration(seconds: 30),
          autoConnect: true,
        );
        _log('✓ Connected with autoConnect!');
        setState(() => _connectedDevice = device);
        await _discoverServices();
      } catch (e2) {
        _log('✗ Alternative also failed: $e2');
      }
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;

    _log('Discovering services...');

    try {
      final services = await _connectedDevice!.discoverServices();
      setState(() => _services = services);

      _log('Found ${services.length} services:');

      for (final service in services) {
        final uuid = service.uuid.toString();
        final shortUuid = uuid.substring(4, 8).toUpperCase();
        String serviceName = _getServiceName(shortUuid);

        _log('');
        _log('SERVICE: $shortUuid ($serviceName)');
        _log('  Full UUID: $uuid');

        for (final char in service.characteristics) {
          final charUuid = char.uuid.toString();
          final shortCharUuid = charUuid.substring(4, 8).toUpperCase();
          String charName = _getCharacteristicName(shortCharUuid);

          _log('  CHAR: $shortCharUuid ($charName)');
          _log('    Properties: ${_formatProperties(char.properties)}');
        }
      }

      // FTMS automatisch testen
      await _testFtms();

    } catch (e) {
      _log('Service discovery error: $e');
    }
  }

  Future<void> _testFtms() async {
    if (_services == null) return;

    _log('');
    _log('=== FTMS TEST ===');

    // FTMS Service finden (0x1826)
    BluetoothService? ftmsService;
    for (final service in _services!) {
      if (service.uuid.toString().toLowerCase().contains('1826')) {
        ftmsService = service;
        break;
      }
    }

    if (ftmsService == null) {
      _log('✗ FTMS Service (1826) NOT FOUND!');

      // Alternative Services suchen
      _log('Checking for alternative services...');
      for (final service in _services!) {
        final uuid = service.uuid.toString().substring(4, 8).toUpperCase();
        if (uuid == '1818') {
          _log('  Found Cycling Power Service (1818)');
        } else if (uuid == '1816') {
          _log('  Found Cycling Speed/Cadence Service (1816)');
        }
      }
      return;
    }

    _log('✓ FTMS Service found!');

    // Indoor Bike Data Characteristic (0x2AD2)
    BluetoothCharacteristic? bikeDataChar;
    BluetoothCharacteristic? controlPointChar;

    for (final char in ftmsService.characteristics) {
      final uuid = char.uuid.toString().toLowerCase();
      if (uuid.contains('2ad2')) {
        bikeDataChar = char;
        _log('✓ Indoor Bike Data (2AD2) found');
      } else if (uuid.contains('2ad9')) {
        controlPointChar = char;
        _log('✓ Control Point (2AD9) found');
      }
    }

    if (bikeDataChar == null) {
      _log('✗ Indoor Bike Data characteristic NOT FOUND!');
      return;
    }

    // Notifications aktivieren
    _log('Enabling notifications...');
    try {
      await bikeDataChar.setNotifyValue(true);
      _log('✓ Notifications enabled');

      // Daten empfangen
      _log('Waiting for data (pedal to generate!)...');
      _dataSubscription?.cancel();
      _dataSubscription = bikeDataChar.onValueReceived.listen((data) {
        _log('DATA: ${data.length} bytes: $data');
        _parseFtmsData(data);
      });

    } catch (e) {
      _log('✗ Notification error: $e');
    }

    // Control Point testen
    if (controlPointChar != null) {
      _log('Testing Control Point...');
      try {
        // Request Control (0x00)
        await controlPointChar.write([0x00], withoutResponse: false);
        _log('✓ Request Control sent');
      } catch (e) {
        _log('✗ Control Point error: $e');
      }
    }
  }

  void _parseFtmsData(List<int> data) {
    if (data.length < 2) return;

    final flags = data[0] | (data[1] << 8);
    _log('  Flags: 0x${flags.toRadixString(16)}');

    int offset = 2;

    // Speed (if bit 0 = 0, speed is present)
    if ((flags & 0x01) == 0 && data.length >= offset + 2) {
      final speed = (data[offset] | (data[offset + 1] << 8)) * 0.01;
      _log('  Speed: ${speed.toStringAsFixed(1)} km/h');
      offset += 2;
    }

    // Average Speed (bit 1)
    if ((flags & 0x02) != 0) offset += 2;

    // Cadence (bit 2)
    if ((flags & 0x04) != 0 && data.length >= offset + 2) {
      final cadence = ((data[offset] | (data[offset + 1] << 8)) * 0.5).round();
      _log('  Cadence: $cadence rpm');
      offset += 2;
    }

    // Average Cadence (bit 3)
    if ((flags & 0x08) != 0) offset += 2;

    // Distance (bit 4)
    if ((flags & 0x10) != 0) offset += 3;

    // Resistance (bit 5)
    if ((flags & 0x20) != 0) offset += 2;

    // Power (bit 6)
    if ((flags & 0x40) != 0 && data.length >= offset + 2) {
      final power = data[offset] | (data[offset + 1] << 8);
      _log('  ⚡ POWER: $power W');
      offset += 2;
    }
  }

  Future<void> _disconnect() async {
    _dataSubscription?.cancel();
    _dataSubscription = null;

    if (_connectedDevice != null) {
      _log('Disconnecting...');
      await _connectedDevice!.disconnect();
      _log('Disconnected');
    }

    setState(() {
      _connectedDevice = null;
      _services = null;
    });
  }

  String _getServiceName(String uuid) {
    return switch (uuid) {
      '1826' => 'FTMS (Fitness Machine)',
      '1818' => 'Cycling Power',
      '1816' => 'Cycling Speed/Cadence',
      '180D' => 'Heart Rate',
      '180A' => 'Device Information',
      '1800' => 'Generic Access',
      '1801' => 'Generic Attribute',
      _ => 'Unknown',
    };
  }

  String _getCharacteristicName(String uuid) {
    return switch (uuid) {
      '2AD2' => 'Indoor Bike Data',
      '2AD9' => 'Fitness Machine Control Point',
      '2ADA' => 'Fitness Machine Status',
      '2AD6' => 'Supported Resistance Range',
      '2AD8' => 'Supported Power Range',
      '2AD3' => 'Training Status',
      '2A5B' => 'CSC Measurement',
      '2A63' => 'Cycling Power Measurement',
      '2A37' => 'Heart Rate Measurement',
      _ => 'Unknown',
    };
  }

  String _formatProperties(CharacteristicProperties props) {
    final list = <String>[];
    if (props.read) list.add('R');
    if (props.write) list.add('W');
    if (props.writeWithoutResponse) list.add('WNR');
    if (props.notify) list.add('N');
    if (props.indicate) list.add('I');
    return list.join(', ');
  }

  void _copyLogs() {
    Clipboard.setData(ClipboardData(text: _logs.join('\n')));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logs kopiert!')),
    );
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Diagnostic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyLogs,
            tooltip: 'Logs kopieren',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => _logs.clear()),
            tooltip: 'Logs löschen',
          ),
        ],
      ),
      body: Column(
        children: [
          // Control Buttons
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _startScan,
                  icon: _isScanning
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.search),
                  label: Text(_isScanning ? 'Scanning...' : 'Scan'),
                ),
                if (_connectedDevice != null)
                  ElevatedButton.icon(
                    onPressed: _disconnect,
                    icon: const Icon(Icons.bluetooth_disabled),
                    label: const Text('Disconnect'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
              ],
            ),
          ),

          // Found Devices
          if (_scanResults.isNotEmpty && _connectedDevice == null)
            Container(
              height: 120,
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _scanResults.length,
                itemBuilder: (context, index) {
                  final result = _scanResults[index];
                  final name = result.device.platformName.isNotEmpty
                    ? result.device.platformName
                    : 'Unknown';
                  final isKickr = name.toLowerCase().contains('kickr');

                  return Card(
                    color: isKickr ? Colors.blue[100] : null,
                    child: InkWell(
                      onTap: _isConnecting ? null : () => _connectToDevice(result),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isKickr ? Icons.pedal_bike : Icons.bluetooth,
                              size: 32,
                              color: isKickr ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(height: 4),
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('RSSI: ${result.rssi}', style: const TextStyle(fontSize: 12)),
                            if (_isConnecting)
                              const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Connection Status
          if (_connectedDevice != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.green[100],
              child: Row(
                children: [
                  const Icon(Icons.bluetooth_connected, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Connected: ${_connectedDevice!.platformName}'),
                ],
              ),
            ),

          // Logs
          Expanded(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  Color color = Colors.white;
                  if (log.contains('✓')) color = Colors.green;
                  if (log.contains('✗')) color = Colors.red;
                  if (log.contains('POWER:')) color = Colors.yellow;
                  if (log.contains('===')) color = Colors.cyan;

                  return Text(
                    log,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: color,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
