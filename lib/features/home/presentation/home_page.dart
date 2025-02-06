import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../shared/mqtt_config/presentation/mqtt_config_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  // List of pages to navigate to
  final List<Widget> _pages = [
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MqttConfigNotifier notifier = ref.read(mqttConfigProvider.notifier);
    final connectionState = ref.watch(mqttServiceProvider);

    if (!notifier.getConnectionTriggered()) {
      notifier.connect(context);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.settings, size: 32,),
              onPressed: () {
                context.push('/mqtt_config');
              },
            ),
          ),
        ],
      ),

      body: connectionState == MqttConnectionState.connected ?
        _pages[_selectedIndex] :
        Center(child: Text('Connect to MQTT broker first')),

      bottomNavigationBar: connectionState == MqttConnectionState.connected ?
        BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.light), label: 'Led'),
            BottomNavigationBarItem(icon: Icon(Icons.roller_shades_closed), label: 'Shutter'),
          ],
        ) :
        null,
    );
  }
}