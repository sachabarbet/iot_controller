import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LedControlWidget extends ConsumerStatefulWidget {
  const LedControlWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LedControlState();
}

class _LedControlState extends ConsumerState<LedControlWidget> {

  @override
  void initState() {
    // TODO: subscribe to data topic and publish to ping topic
    super.initState();
  }

  @override
  void dispose() {
    // TODO: unsubscribe data led esp
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(

    );
  }
}