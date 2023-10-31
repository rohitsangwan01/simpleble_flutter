// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:simpleble_flutter/simpleble_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<BleScanResult> scanResults = [];
  List<String> connectedDevices = [];

  @override
  void initState() {
    super.initState();
    SimpleBleFlutter.initialize();

    SimpleBleFlutter.onScanResult = (BleScanResult scanResult) {
      if (!scanResults
          .any((element) => element.deviceId == scanResult.deviceId)) {
        setState(() {
          scanResults.add(scanResult);
        });
      } else {
        int index = scanResults
            .indexWhere((element) => element.deviceId == scanResult.deviceId);
        setState(() {
          scanResults[index] = scanResult;
        });
      }
    };

    SimpleBleFlutter.onConnectionChanged =
        (String deviceId, BleConnectionState state) {
      print("$deviceId $state");
      if (state == BleConnectionState.connected) {
        onDeviceConnected(deviceId);
        if (!connectedDevices.contains(deviceId)) {
          setState(() {
            connectedDevices.add(deviceId);
          });
        }
      } else {
        if (connectedDevices.contains(deviceId)) {
          setState(() {
            connectedDevices.remove(deviceId);
          });
        }
      }
    };

    SimpleBleFlutter.onValueChanged =
        (String deviceId, String characteristicId, Uint8List value) {
      print("$deviceId $characteristicId $value");
    };
  }

  void onDeviceConnected(String deviceId) async {
    // print("Device connected: $deviceId");
    // try {
    //   List<BleService> services =
    //       await SimpleBleFlutter.discoverServices(deviceId);
    //   for (var service in services) {
    //     print("Service: ${service.uuid}");
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SimpleBle Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => SimpleBleFlutter.startScan(),
                    child: const Text("Start Scan")),
                FutureBuilder(
                    future: SimpleBleFlutter.isBluetoothAvailable(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            "BleAvailable: ${snapshot.data.toString()}");
                      } else {
                        return const Text("BleAvailable: Loadig..");
                      }
                    }),
                ElevatedButton(
                    onPressed: () => SimpleBleFlutter.stopScan(),
                    child: const Text("Stop Scan")),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (BuildContext context, int index) {
                  String? name = scanResults[index].name;
                  if (name == null || name.isEmpty) name = "NA";
                  bool isConnected =
                      connectedDevices.contains(scanResults[index].deviceId);
                  String deviceId = scanResults[index].deviceId;
                  return ListTile(
                    title: Text("$name ( ${scanResults[index].rssi} )"),
                    subtitle: Text(deviceId),
                    tileColor: isConnected ? Colors.green[100] : null,
                    trailing: isConnected
                        ? const Icon(Icons.bluetooth_connected)
                        : null,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title:
                                  Text("Connect to ${scanResults[index].name}"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        !isConnected
                                            ? await SimpleBleFlutter.connect(
                                                deviceId)
                                            : await SimpleBleFlutter.disconnect(
                                                deviceId);
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text(
                                      isConnected ? "Disconnect" : "Connect",
                                    )),
                              ],
                            );
                          });
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
