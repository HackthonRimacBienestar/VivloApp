import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Dispositivos conectados / wearables
class ConnectedDevicesPage extends StatelessWidget {
  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Dispositivos',
      body: Center(child: Text('Dispositivos conectados / wearables')),
    );
  }
}
