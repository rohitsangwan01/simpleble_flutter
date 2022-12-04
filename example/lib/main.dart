import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
  String _platformVersion = 'Unknown';
  final _simplebleFlutterPlugin = SimplebleFlutter();
  String bleAvailabilityState = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _simplebleFlutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
      if (!mounted) return;
      setState(() {
        _platformVersion = platformVersion;
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }

  Future checkBle() async {
    bool available = await _simplebleFlutterPlugin.isBleAvailable();
    setState(() {
      bleAvailabilityState = available ? "Available" : "Not Available";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () => checkBle(),
                child: const Text("Check BleAvailability")),
            Text("Ble Availability $bleAvailabilityState"),
            Text('Running on: $_platformVersion\n'),
          ],
        ),
      ),
    );
  }
}
