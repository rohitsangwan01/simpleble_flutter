import 'package:flutter/foundation.dart';
import 'package:simpleble_flutter/src/models.dart';
import 'package:simpleble_flutter/src/simple_ble.g.dart';

class SimpleBleFlutter {
  static final SimpleBlePlatformChannel _channel = SimpleBlePlatformChannel();

  static Function(BleScanResult)? onScanResult;
  static Function(String, BleConnectionState)? onConnectionChanged;
  static Function(String, String, Uint8List)? onValueChanged;

  /// Make sure to call initialize first
  static Future<void> initialize() async {
    SimpleBleCallbackChannel.setup(_SimpleBleCallbackHandler(
      onScanResultUpdate: (BleScanResult scanResult) =>
          onScanResult?.call(scanResult),
      onConnectionUpdate: (String deviceId, BleConnectionState state) =>
          onConnectionChanged?.call(deviceId, state),
      onValueUpdate:
          (String deviceId, String characteristicId, Uint8List value) =>
              onValueChanged?.call(deviceId, characteristicId, value),
    ));
  }

  static Future<bool> isBluetoothAvailable() => _channel.isBluetoothAvailable();

  static Future<void> startScan() => _channel.startScan();

  static Future<void> stopScan() => _channel.stopScan();

  static Future<void> connect(String deviceId) => _channel.connect(deviceId);

  static Future<void> disconnect(String deviceId) =>
      _channel.disconnect(deviceId);

  static Future<void> discoverServices(String deviceId) =>
      _channel.discoverServices(deviceId);

  static Future<void> setNotifiable(String deviceId, String service,
      String characteristic, BleInputProperty bleInputProperty) {
    return _channel.setNotifiable(
      deviceId,
      service,
      characteristic,
      bleInputProperty.value,
    );
  }

  static Future<void> readValue(
      String deviceId, String service, String characteristic) {
    return _channel.readValue(deviceId, service, characteristic);
  }

  static Future<void> writeValue(
      String deviceId,
      String service,
      String characteristic,
      Uint8List value,
      BleOutputProperty bleOutputProperty) {
    return _channel.writeValue(
      deviceId,
      service,
      characteristic,
      value,
      bleOutputProperty.value,
    );
  }

  static Future<void> requestMtu(String deviceId, int expectedMtu) =>
      _channel.requestMtu(deviceId, expectedMtu);
}

/// Handler for the callback channel
class _SimpleBleCallbackHandler extends SimpleBleCallbackChannel {
  final Function(String, BleConnectionState) onConnectionUpdate;
  final Function(BleScanResult) onScanResultUpdate;
  final Function(
    String deviceId,
    String characteristicId,
    Uint8List value,
  ) onValueUpdate;

  _SimpleBleCallbackHandler({
    required this.onConnectionUpdate,
    required this.onScanResultUpdate,
    required this.onValueUpdate,
  });

  @override
  void onConnectionChanged(String deviceId, int state) =>
      onConnectionUpdate(deviceId, BleConnectionState.parse(state));

  @override
  void onScanResult(SimpleBleScanResult result) {
    onScanResultUpdate(BleScanResult(
      name: result.name,
      deviceId: result.deviceId,
      rssi: result.rssi,
      manufacturerData: result.manufacturerData,
    ));
  }

  @override
  void onValueChanged(
    String deviceId,
    String characteristicId,
    Uint8List value,
  ) =>
      onValueUpdate(deviceId, characteristicId, value);
}
