import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundServiceControlButtonLayout extends StatelessWidget {
  const BackgroundServiceControlButtonLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  if (await service.isRunning()) {
                    log('Stopping Service...',
                        name: "Background Service (home.dart)");
                    service.invoke("stopService");
                  } else {
                    log('Starting Service...',
                        name: "Background Service (home.dart)");
                    service.startService();
                  }
                },
                child: const Text('Start/Stop Service')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  log('Switching to foreground...',
                      name: "Background Service (home.dart)");
                  service.invoke("setAsForeground");
                },
                child: const Text('Set as foreground')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  log('Switching to background...',
                      name: "Background Service (home.dart)");
                  service.invoke("setAsBackground");
                },
                child: const Text('Set as background')),
          ),
        ],
      ),
    );
  }
}
