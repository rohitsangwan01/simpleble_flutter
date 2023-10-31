// Autogenerated from Pigeon (v12.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
List<Object?> wrapResponse({Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

class SimpleBleScanResult {
  SimpleBleScanResult({
    required this.deviceId,
    this.name,
    this.manufacturerData,
    this.rssi,
  });

  String deviceId;

  String? name;

  Uint8List? manufacturerData;

  int? rssi;

  Object encode() {
    return <Object?>[
      deviceId,
      name,
      manufacturerData,
      rssi,
    ];
  }

  static SimpleBleScanResult decode(Object result) {
    result as List<Object?>;
    return SimpleBleScanResult(
      deviceId: result[0]! as String,
      name: result[1] as String?,
      manufacturerData: result[2] as Uint8List?,
      rssi: result[3] as int?,
    );
  }
}

class SimpleBlePlatformChannel {
  /// Constructor for [SimpleBlePlatformChannel].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  SimpleBlePlatformChannel({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = StandardMessageCodec();

  Future<bool> isBluetoothAvailable() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.isBluetoothAvailable', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<void> startScan() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.startScan', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> stopScan() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.stopScan', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> connect(String arg_deviceId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.connect', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_deviceId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> disconnect(String arg_deviceId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.disconnect', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_deviceId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<List<Map<String?, Map<String?, List<int?>?>?>?>> discoverServices(String arg_deviceId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.discoverServices', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_deviceId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<Map<String?, Map<String?, List<int?>?>?>?>();
    }
  }

  Future<void> setNotifiable(String arg_deviceId, String arg_service, String arg_characteristic, int arg_bleInputProperty) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.setNotifiable', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_deviceId, arg_service, arg_characteristic, arg_bleInputProperty]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<Uint8List> readValue(String arg_deviceId, String arg_service, String arg_characteristic) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.readValue', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_deviceId, arg_service, arg_characteristic]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as Uint8List?)!;
    }
  }

  Future<void> writeValue(String arg_deviceId, String arg_service, String arg_characteristic, Uint8List arg_value, int arg_bleOutputProperty) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.writeValue', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_deviceId, arg_service, arg_characteristic, arg_value, arg_bleOutputProperty]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<int> requestMtu(String arg_deviceId, int arg_expectedMtu) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.simpleble_flutter.SimpleBlePlatformChannel.requestMtu', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_deviceId, arg_expectedMtu]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as int?)!;
    }
  }
}

class _SimpleBleCallbackChannelCodec extends StandardMessageCodec {
  const _SimpleBleCallbackChannelCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is SimpleBleScanResult) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return SimpleBleScanResult.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class SimpleBleCallbackChannel {
  static const MessageCodec<Object?> codec = _SimpleBleCallbackChannelCodec();

  void onScanResult(SimpleBleScanResult result);

  void onConnectionChanged(String deviceId, int state);

  void onValueChanged(String deviceId, String characteristicId, Uint8List value);

  static void setup(SimpleBleCallbackChannel? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onScanResult', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onScanResult was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final SimpleBleScanResult? arg_result = (args[0] as SimpleBleScanResult?);
          assert(arg_result != null,
              'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onScanResult was null, expected non-null SimpleBleScanResult.');
          try {
            api.onScanResult(arg_result!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onConnectionChanged', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onConnectionChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_deviceId = (args[0] as String?);
          assert(arg_deviceId != null,
              'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onConnectionChanged was null, expected non-null String.');
          final int? arg_state = (args[1] as int?);
          assert(arg_state != null,
              'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onConnectionChanged was null, expected non-null int.');
          try {
            api.onConnectionChanged(arg_deviceId!, arg_state!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onValueChanged', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onValueChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_deviceId = (args[0] as String?);
          assert(arg_deviceId != null,
              'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onValueChanged was null, expected non-null String.');
          final String? arg_characteristicId = (args[1] as String?);
          assert(arg_characteristicId != null,
              'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onValueChanged was null, expected non-null String.');
          final Uint8List? arg_value = (args[2] as Uint8List?);
          assert(arg_value != null,
              'Argument for dev.flutter.pigeon.simpleble_flutter.SimpleBleCallbackChannel.onValueChanged was null, expected non-null Uint8List.');
          try {
            api.onValueChanged(arg_deviceId!, arg_characteristicId!, arg_value!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}
