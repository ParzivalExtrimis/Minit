import 'dart:async';
import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class BackgroundService {
  static Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        isForegroundMode: true,
      ),
    );

    await service.startService();
  }

  static Future<void> _onStart(ServiceInstance serviceInstance) async {
    if (serviceInstance is AndroidServiceInstance) {
      serviceInstance.on('setAsForeground').listen((event) {
        serviceInstance.setAsForegroundService();
      });

      serviceInstance.on('setAsBackground').listen((event) {
        serviceInstance.setAsBackgroundService();
      });

      serviceInstance.on('stopService').listen((event) {
        serviceInstance.stopSelf();
      });
    }

    // run a foreground notification periodically
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (serviceInstance is AndroidServiceInstance) {
        if (await serviceInstance.isForegroundService()) {
          // setup nptofication channel
          serviceInstance.setForegroundNotificationInfo(
              title: "Minit - Test Notification",
              content: 'Triggered at: ${DateTime.now()}');
        }
        log("Notifcation being sent: ${DateTime.now()}");
      }
    });
  }
}
