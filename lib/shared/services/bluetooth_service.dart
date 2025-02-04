import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothService  {

  static Future<void> initialize() async {
    if (await FlutterBluePlus.isSupported == false) {
      if (kDebugMode) {
        print("Bluetooth not supported by this device");
      }
      return;
    }

    if (!kIsWeb && Platform.isAndroid &&
        await FlutterBluePlus.adapterState.first == BluetoothAdapterState.off) {
      await FlutterBluePlus.turnOn();
    }
  }
}