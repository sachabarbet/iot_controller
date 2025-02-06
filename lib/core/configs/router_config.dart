import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/mqtt_config/presentation/mqtt_config_page.dart';

final GoRouter routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/mqtt_config',
      builder: (context, state) => const MqttConfigPage(),
    ),
  ],
);