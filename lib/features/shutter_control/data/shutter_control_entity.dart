import '../../../shared/mqtt/data/esp_mode_enum.dart';

class ShutterControl {
  final EspMode espMode;
  final int shutterValue;
  final int luxValue;
  final int luxTriggerOn;
  final int luxTriggerOff;
  final bool luxDebounced;

  const ShutterControl({
    required this.espMode,
    required this.shutterValue,
    required this.luxValue,
    required this.luxTriggerOn,
    required this.luxTriggerOff,
    required this.luxDebounced,
  });

  ShutterControl copyWith({
    bool? isSubscribed,
    DateTime? lastUpdateAt,
    EspMode? espMode,
    int? shutterValue,
    int? luxValue,
    int? luxTriggerOn,
    int? luxTriggerOff,
    bool? luxDebounced,
  }) {
    return ShutterControl(
      espMode: espMode ?? this.espMode,
      shutterValue: shutterValue ?? this.shutterValue,
      luxValue: luxValue ?? this.luxValue,
      luxTriggerOn: luxTriggerOn ?? this.luxTriggerOn,
      luxTriggerOff: luxTriggerOff ?? this.luxTriggerOff,
      luxDebounced: luxDebounced ?? this.luxDebounced,
    );
  }
}