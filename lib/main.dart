import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:neurai_app/views/login.dart';

void main() {
  runApp(DevicePreview(builder: (context) => App()));
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Login());
  }
}
