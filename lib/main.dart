import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MannmaujiBakersApp(),
    ),
  );
}

class MannmaujiBakersApp extends StatelessWidget {
  const MannmaujiBakersApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'Humari Bakery + Cafe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.themeMode,
      home: const MainNavigation(),
    );
  }
}
