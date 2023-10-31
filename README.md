# SimpleBle Flutter

SimpleBle flutter implementation to control bluetooth low energy on windows

## Getting Started

Initialize and set handlers

```dart
SimpleBleFlutter.initialize();

SimpleBleFlutter.onScanResult = (BleScanResult scanResult) {
    // Handle scan results
};

SimpleBleFlutter.onConnectionChanged = (String deviceId, BleConnectionState state) {
    // Handle connection state updates
};

SimpleBleFlutter.onValueChanged = (String deviceId, String characteristicId, Uint8List value) {
    // Handle characteristic value changes
};
```

Other Methods

```dart
SimpleBleFlutter.isBluetoothAvailable();

SimpleBleFlutter.startScan();

SimpleBleFlutter.stopScan();

SimpleBleFlutter.connect(String deviceId);

SimpleBleFlutter.disconnect(String deviceId);

SimpleBleFlutter.discoverServices(String deviceId);

SimpleBleFlutter.setNotifiable(
  String deviceId,
  String service,
  String characteristic,
  BleInputProperty bleInputProperty,
);

SimpleBleFlutter.readValue(
    String deviceId,
    String service,
    String characteristic,
  );

SimpleBleFlutter.writeValue(
    String deviceId,
    String service,
    String characteristic,
    Uint8List value,
    BleOutputProperty bleOutputProperty,
  );

SimpleBleFlutter.requestMtu(String deviceId, int expectedMtu);
```

## SimpleBle Windows Plugin Integration

Using [SimpleBle](https://github.com/OpenBluetoothToolbox/SimpleBLE) for windows

To update/add simpleBle , follow [this](https://simpleble.readthedocs.io/en/latest/simpleble/usage.html#installing-simpleble) guide to install simpleble Or follow these steps:

Download SimpleBle from [main](https://github.com/OpenBluetoothToolbox/SimpleBLE) ( make sure [cmake](https://cmake.org/download/) is installed ), and run these commands on root of simpleble ( run these commands with administrator permission )

- cmake simpleble -B build_simpleble -DSIMPLEBLE_LOG_LEVEL=NONE
- cmake --build build_simpleble -j7
- cmake --install build_simpleble --config Debug --prefix <path-to-simpleble_flutter-root>\windows

That's it, this will add required files in `windows` folder of the plugin, and finally edit `CmakeList.txt`:

```cmake
## Add these
set(simpleble_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lib/cmake/simpleble")
find_package(simpleble REQUIRED CONFIG)

....
..
## Modify this
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin simpleble::simpleble)
```

## Note

This is initial version, and apis might change
