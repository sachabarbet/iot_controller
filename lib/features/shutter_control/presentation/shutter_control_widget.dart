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
    notifier.getData();
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
    final shutterState = ref.watch(shutterControlProvider);
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
                    Text("Manual"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Switch(
                        value: shutterState.espMode == EspMode.auto,
                        onChanged: (value) =>
                            notifier.setControlMode(
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
              Icons.roller_shades_closed,
              size: 100,
              color: _getColorFromShutterState(),
            ),
            Column(
              children: [
                Text("Value: ${shutterState.shutterValue}"),
                Slider(
                  value: shutterState.shutterValue.toDouble(),
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
            Text("Lux value: ${shutterState.luxValue}"),
            Text("Trigger on: ${shutterState.luxTriggerOn}"),
            Text("Trigger off: ${shutterState.luxTriggerOff}"),
            Text("Debounced: ${shutterState.luxDebounced}"),
          ],
        ),
      ),
    );
  }
}
