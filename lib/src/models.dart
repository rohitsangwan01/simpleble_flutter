import 'dart:typed_data';

class BleScanResult {
  final String deviceId;
  final String? name;
  Uint8List? manufacturerData;
  final int? rssi;

  BleScanResult({
    required this.name,
    required this.deviceId,
    Uint8List? manufacturerData,
    required this.rssi,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'name': name,
      'manufacturerData': manufacturerData,
      'rssi': rssi,
    };
  }
}

enum BleConnectionState {
  connected(0),
  disconnected(1);

  final int value;
  const BleConnectionState(this.value);

  factory BleConnectionState.parse(int value) =>
      BleConnectionState.values.firstWhere((element) => element.value == value);
}

enum BleInputProperty {
  disabled(0),
  notification(1),
  indication(2);

  final int value;
  const BleInputProperty(this.value);

  factory BleInputProperty.parse(int value) =>
      BleInputProperty.values.firstWhere((element) => element.value == value);
}

enum BleOutputProperty {
  withResponse(0),
  withoutResponse(1);

  final int value;
  const BleOutputProperty(this.value);

  factory BleOutputProperty.parse(int value) =>
      BleOutputProperty.values.firstWhere((element) => element.value == value);
}

class BleService {
  String uuid;
  List<BleCharacteristic> characteristics;
  BleService(this.uuid, this.characteristics);
}

class BleCharacteristic {
  String uuid;
  List<CharacteristicProperty> properties;
  BleCharacteristic(this.uuid, this.properties);
}

enum CharacteristicProperty {
  broadcast(0),
  read(1),
  writeWithoutResponse(2),
  write(3),
  notify(4),
  indicate(5),
  authenticatedSignedWrites(6),
  extendedProperties(7);

  final int value;
  const CharacteristicProperty(this.value);

  factory CharacteristicProperty.parse(int value) =>
      CharacteristicProperty.values
          .firstWhere((element) => element.value == value);
}
