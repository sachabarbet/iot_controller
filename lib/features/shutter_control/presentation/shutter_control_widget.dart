import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/mqtt/data/esp_mode_enum.dart';
import 'shutter_control_provider.dart';

class ShutterControlWidget extends ConsumerStatefulWidget {
  const ShutterControlWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShutterControlState();
}

class _ShutterControlState extends ConsumerState<ShutterControlWidget> {
  @override
  void initState() {
    final ShutterControlNotifier notifier = ref.read(
        shutterControlProvider.notifier);
    notifier.subscribeToLedState();
    notifier.requestLedState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _getColorFromShutterState() {
    final shutterValue = ref.watch(shutterControlProvider);
    return shutterValue.shutterValue == 0 ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final ledState = ref.watch(shutterControlProvider);
    final notifier = ref.watch(shutterControlProvider.notifier);

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
                    Text("Auto"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Switch(
                        value: ledState.espMode == EspMode.manual,
                        onChanged: (value) =>
                            notifier.setControlMode(
                              value ? EspMode.auto : EspMode.manual,
                            ),
                      ),
                    ),
                    Text("Manual")
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
              Icons.roller_shades_closed,
              size: 100,
              color: _getColorFromShutterState(),
            ),
            Column(
              children: [
                Text("Value: ${ledState.shutterValue}"),
                Slider(
                  value: ledState.shutterValue.toDouble(),
                  onChanged: (value) => notifier.setShutterValue(value.toInt()),
                  min: 0,
                  max: 100,
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
