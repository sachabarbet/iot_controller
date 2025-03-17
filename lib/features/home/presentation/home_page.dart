import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../shared/mqtt/presentation/mqtt_config_provider.dart';
import '../../../shared/mqtt/presentation/mqtt_service_provider.dart';
import '../../led_control/presentation/led_control_widget.dart';
import '../../shutter_control/presentation/shutter_control_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final SpeechToText _speechToText = SpeechToText();

  int _selectedIndex = 0;
  bool _speechEnabled = false;
  bool isListening = false;
  String _lastWords = '';

  // List of pages to navigate to
  final List<Widget> _pages = [
    LedControlWidget(),
    ShutterControlWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening(BuildContext context) async {
    setState(() {
      isListening = false;
    });
    _speechToText.stop();
    Navigator.pop(context);
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      setState(() {
        _lastWords = result.recognizedWords;
      });
      processCommand(_lastWords);
    });
  }

  void _startListening(BuildContext context) async {
    if (_speechEnabled) {
      setState(() => isListening = true);
      showBottomSheet(context);
      _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: 'fr_FR',
      );
    }
  }

  void processCommand(String text) {
    text = text.toLowerCase();

    if (text.contains("allume la lumière de la chambre")) {
      print("led/chamber/control 1",);
    } else if (text.contains("éteins la lumière de la chambre")) {
      print("led/chamber/control 0");
    } else if (text.contains("allume la lumière du salon")) {
      print("led/livingroom/control 1");
    } else if (text.contains("éteins la lumière du salon")) {
      print("led/livingroom/control 0");
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _lastWords,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _stopListening(context),
                    child: Text("Arrêter"),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() => isListening = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(child: Text('Connect to MQTT broker first by clicking on the settings icon in the top right corner')),
        ),

      floatingActionButton: connectionState == MqttConnectionState.connected ? FloatingActionButton(
        onPressed: () {
          _startListening(context);
        },
        tooltip: 'Listen',
        child: Icon(isListening ? Icons.mic : Icons.mic_off),
      ) : null,

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