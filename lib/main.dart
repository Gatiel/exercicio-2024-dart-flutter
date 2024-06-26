import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'calendar.dart';
import 'information.dart';
import 'models/activity.dart';

void main() {
  runApp(const ChuvaDart());
}

class ChuvaDart extends StatelessWidget {
  const ChuvaDart({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Calendar(),
        ),
        GoRoute(
          path: '/information',
          builder: (context, state) {
            final activity = state.extra as Activity;
            return InformationScreen(activity: activity);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF456189),
        ),
        useMaterial3: true,
      ),
    );
  }
}
