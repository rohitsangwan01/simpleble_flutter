import 'package:pigeon/pigeon.dart';

// dart run pigeon --input pigeon/simple_ble_pigeon.dart
@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'simpleble_flutter',
    dartOut: 'lib/src/simple_ble.g.dart',
    dartOptions: DartOptions(),
    cppOptions: CppOptions(namespace: 'simpleble_flutter'),
    cppHeaderOut: 'windows/simpleble_flutter.g.h',
    cppSourceOut: 'windows/simpleble_flutter.g.cpp',
  ),
)
@HostApi()
abstract class SimpleBlePlatformChannel {
  bool isBluetoothAvailable();

  void startScan();

  void stopScan();

  void connect(String deviceId);

  void disconnect(String deviceId);

  // (Service -> (Characteristic -> Properties))
  List<Map<String, Map<String, List<int>>>> discoverServices(String deviceId);

  void setNotifiable(
    String deviceId,
    String service,
    String characteristic,
    int bleInputProperty,
  );

  Uint8List readValue(
    String deviceId,
    String service,
    String characteristic,
  );

  void writeValue(
    String deviceId,
    String service,
    String characteristic,
    Uint8List value,
    int bleOutputProperty,
  );

  int requestMtu(String deviceId, int expectedMtu);
}

@FlutterApi()
abstract class SimpleBleCallbackChannel {
  void onScanResult(SimpleBleScanResult result);

  void onConnectionChanged(String deviceId, int state);

  void onValueChanged(
    String deviceId,
    String characteristicId,
    Uint8List value,
  );
}

class SimpleBleScanResult {
  String deviceId;
  String? name;
  Uint8List? manufacturerData;
  int? rssi;

  SimpleBleScanResult({
    required this.deviceId,
    this.name,
    this.manufacturerData,
    this.rssi,
  });
}
