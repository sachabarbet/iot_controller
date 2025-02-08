import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/mqtt/data/esp_mode_enum.dart';
import '../data/led_control_entity.dart';

final ledControlProvider =
StateNotifierProvider<LedControlNotifier, LedControl>((ref) {
  return LedControlNotifier(ref);
});

class LedControlNotifier extends StateNotifier<LedControl> {
  final Ref ref;

  LedControlNotifier(this.ref) : super(LedControl(
    isSubscribed: false,
    lastUpdateAt: null,
    espMode: EspMode.auto,
    ledValues: [0, 0, 0],
    luxValue: 0,
    luxTriggerOn: 0,
    luxTriggerOff: 0,
    luxDebounced: false,
  ));
}
