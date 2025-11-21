import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InjectionContainer.init();

  runApp(const App());
}
