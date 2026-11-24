import 'package:flutter/material.dart';

import 'models/school_models.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SeoulFinanceApp());
}

class SeoulFinanceApp extends StatefulWidget {
  final DateTime? initialDate;

  const SeoulFinanceApp({super.key, this.initialDate});

  @override
  State<SeoulFinanceApp> createState() => _SeoulFinanceAppState();
}

class _SeoulFinanceAppState extends State<SeoulFinanceApp> {
  AppDisplayMode _displayMode = AppDisplayMode.light;

  void _updateDisplayMode(AppDisplayMode nextMode) {
    setState(() {
      _displayMode = nextMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _displayMode == AppDisplayMode.dark;

    return MaterialApp(
      title: '서울금융고등학교 학사·급식',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        colorSchemeSeed: const Color(0xFF9E4B4B),
      ),
      home: FinanceSchoolHomeScreen(
        currentMode: _displayMode,
        onModeChanged: _updateDisplayMode,
        initialDate: widget.initialDate,
      ),
    );
  }
}
