import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/mqtt/data/esp_mode_enum.dart';
import 'led_control_provider.dart';

class LedControlWidget extends ConsumerStatefulWidget {
  const LedControlWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LedControlState();
}

class _LedControlState extends ConsumerState<LedControlWidget> {
  @override
  void initState() {
    final LedControlNotifier notifier = ref.read(ledControlProvider.notifier);
    notifier.getData();
    notifier.subscribeToLedState();
    notifier.requestLedState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showColorPicker(BuildContext context, Color selectedColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a Color"),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
            enableLabel: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _sendColorToMqtt(selectedColor);
              Navigator.pop(context);
            },
            child: const Text("Set Color"),
          ),
        ],
      ),
    );
  }

  void _sendColorToMqtt(Color color) {
    // Convert color to RGB values
    List<int> rgbValues = [(color.r*255).toInt(), (color.g*255).toInt(), (color.b*255).toInt()];
    print("DATAAAAAAA ->  " + rgbValues.toString());
    ref.read(ledControlProvider.notifier).setLedValues(rgbValues);
  }

  @override
  Widget build(BuildContext context) {
    final ledState = ref.watch(ledControlProvider);
    final notifier = ref.watch(ledControlProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Control mode: "),
                Row(
                  children: [
                    Text("Manual"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Switch(
                        value: ledState.espMode == EspMode.auto,
                        onChanged: (value) => notifier.setControlMode(
                          value ? EspMode.auto : EspMode.manual,
                        ),
                      ),
                    ),
                    Text("Auto")
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(),
            ),
            // Led icon, color picker
            // Values not editable : Lux value, trigger on, trigger off, debounced
            Icon(
              Icons.lightbulb,
              size: 100,
              color: Color.fromRGBO(
                ledState.ledValues[0],
                ledState.ledValues[1],
                ledState.ledValues[2],
                1,
              ),
            ),
            Column(
              children: [
                Text("RGB: ${ledState.ledValues}"),
                ElevatedButton(
                  onPressed: () => _showColorPicker(
                    context,
                    Color.fromRGBO(
                      ledState.ledValues[0],
                      ledState.ledValues[1],
                      ledState.ledValues[2],
                      1,
                    ),
                  ),
                  child: const Text("Change color"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(),
            ),
            Text("Lux value: ${ledState.luxValue}"),
            Text("Trigger on: ${ledState.luxTriggerOn}"),
            Text("Trigger off: ${ledState.luxTriggerOff}"),
            Text("Debounced: ${ledState.luxDebounced}"),
          ],
        ),
      ),
    );
  }
}
