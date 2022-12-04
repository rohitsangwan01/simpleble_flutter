import 'package:flutter/services.dart';

class SimplebleFlutter {
  final methodChannel = const MethodChannel('simpleble_flutter');

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// this will call native code , to check if bluetooth is available
  Future<bool> isBleAvailable() async {
    final result = await methodChannel.invokeMethod<bool>('isBleAvailable');
    return result ?? false;
  }
}
