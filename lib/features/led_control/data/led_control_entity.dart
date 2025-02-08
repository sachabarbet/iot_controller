import '../../../shared/mqtt/data/esp_mode_enum.dart';

class LedControl {
  final bool isSubscribed;
  final DateTime? lastUpdateAt;
  final EspMode espMode;
  final List<int> ledValues;
  final int luxValue;
  final int luxTriggerOn;
  final int luxTriggerOff;
  final bool luxDebounced;

  const LedControl({
    required this.isSubscribed,
    required this.lastUpdateAt,
    required this.espMode,
    required this.ledValues,
    required this.luxValue,
    required this.luxTriggerOn,
    required this.luxTriggerOff,
    required this.luxDebounced,
  });

  LedControl copyWith({
    bool? isSubscribed,
    DateTime? lastUpdateAt,
    EspMode? espMode,
    List<int>? ledValues,
    int? luxValue,
    int? luxTriggerOn,
    int? luxTriggerOff,
    bool? luxDebounced,
  }) {
    return LedControl(
      isSubscribed: isSubscribed ?? this.isSubscribed,
      lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
      espMode: espMode ?? this.espMode,
      ledValues: ledValues ?? this.ledValues,
      luxValue: luxValue ?? this.luxValue,
      luxTriggerOn: luxTriggerOn ?? this.luxTriggerOn,
      luxTriggerOff: luxTriggerOff ?? this.luxTriggerOff,
      luxDebounced: luxDebounced ?? this.luxDebounced,
    );
  }
}