import 'package:flutter/material.dart';
import '../models/school_models.dart';

class AppModeStyle {
  final AppDisplayMode mode;
  final Color scaffoldBackground;
  final Gradient? scaffoldGradient;
  final Color headerBackground;
  final Gradient? headerGradient;
  final Color headerBorderColor;
  final Color headerTextColor;
  final Color headerSubtitleColor;
  final Color modeCircleColor;
  final Gradient? modeCircleGradient;
  final Color sectionTitleColor;
  final Color cardBackground;
  final Gradient? cardGradient;
  final Color cardBorderColor;
  final Color itemSurfaceColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final Color holidayBadgeColor;
  final Color holidayBadgeTextColor;

  const AppModeStyle({
    required this.mode,
    required this.scaffoldBackground,
    this.scaffoldGradient,
    required this.headerBackground,
    this.headerGradient,
    required this.headerBorderColor,
    required this.headerTextColor,
    required this.headerSubtitleColor,
    required this.modeCircleColor,
    this.modeCircleGradient,
    required this.sectionTitleColor,
    required this.cardBackground,
    this.cardGradient,
    required this.cardBorderColor,
    required this.itemSurfaceColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.accentColor,
    required this.holidayBadgeColor,
    required this.holidayBadgeTextColor,
  });

  static const List<Color> rainbowPalette = [
    Color(0xFFFF595E),
    Color(0xFFFF924C),
    Color(0xFFFFCA3A),
    Color(0xFF38B000),
    Color(0xFF1982C4),
    Color(0xFF6A4C93),
  ];

  static AppModeStyle of(AppDisplayMode mode) {
    switch (mode) {
      case AppDisplayMode.light:
        return const AppModeStyle(
          mode: AppDisplayMode.light,
          scaffoldBackground: Color(0xFFFFFFFF),
          headerBackground: Color(0xFFD9D9D9),
          headerBorderColor: Color(0xFF111111),
          headerTextColor: Color(0xFF000000),
          headerSubtitleColor: Color(0xFF4A4A4A),
          modeCircleColor: Color(0xFF9E4B4B),
          sectionTitleColor: Color(0xFF000000),
          cardBackground: Color(0xFFD9D9D9),
          cardBorderColor: Color(0x00000000),
          itemSurfaceColor: Color(0xCCF5F5F5),
          primaryTextColor: Color(0xFF141414),
          secondaryTextColor: Color(0xFF4F4F4F),
          accentColor: Color(0xFF9E4B4B),
          holidayBadgeColor: Color(0xFFFDE8E8),
          holidayBadgeTextColor: Color(0xFFB42318),
        );

      case AppDisplayMode.dark:
        return const AppModeStyle(
          mode: AppDisplayMode.dark,
          scaffoldBackground: Color(0xFF121418),
          headerBackground: Color(0xFF1F242D),
          headerBorderColor: Color(0xFF3A4252),
          headerTextColor: Color(0xFFF5F7FA),
          headerSubtitleColor: Color(0xFF9AA5B4),
          modeCircleColor: Color(0xFFD96B6B),
          sectionTitleColor: Color(0xFFF3F4F6),
          cardBackground: Color(0xFF232832),
          cardBorderColor: Color(0xFF323946),
          itemSurfaceColor: Color(0xFF2D3442),
          primaryTextColor: Color(0xFFF3F4F6),
          secondaryTextColor: Color(0xFFA0AEC0),
          accentColor: Color(0xFFE07A7A),
          holidayBadgeColor: Color(0xFF482328),
          holidayBadgeTextColor: Color(0xFFFCA5A5),
        );

      case AppDisplayMode.rainbow:
        return const AppModeStyle(
          mode: AppDisplayMode.rainbow,
          scaffoldBackground: Color(0xFFFFF8FC),
          scaffoldGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF0F3),
              Color(0xFFFFF9DB),
              Color(0xFFEBFBEE),
              Color(0xFFE7F5FF),
              Color(0xFFF3D9FA),
            ],
          ),
          headerBackground: Color(0xFFFFDDE6),
          headerGradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFB5C2),
              Color(0xFFFFD6A5),
              Color(0xFFFDFFB6),
              Color(0xFFCAFFBF),
              Color(0xFF9BF6FF),
              Color(0xFFA0C4FF),
              Color(0xFFBDB2FF),
            ],
          ),
          headerBorderColor: Color(0xFF3B2F4A),
          headerTextColor: Color(0xFF1F162B),
          headerSubtitleColor: Color(0xFF4A375E),
          modeCircleColor: Color(0xFFFF595E),
          modeCircleGradient: SweepGradient(
            colors: [
              Color(0xFFFF595E),
              Color(0xFFFF924C),
              Color(0xFFFFCA3A),
              Color(0xFF8AC926),
              Color(0xFF1982C4),
              Color(0xFF6A4C93),
              Color(0xFFFF595E),
            ],
          ),
          sectionTitleColor: Color(0xFF241634),
          cardBackground: Color(0xFFF4ECFF),
          cardGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xD9FFD6E0),
              Color(0xD9FFF3B0),
              Color(0xD9D8F3DC),
              Color(0xD9D0F4DE),
              Color(0xD9DCE8FF),
              Color(0xD9E8DAFF),
            ],
          ),
          cardBorderColor: Color(0x668338EC),
          itemSurfaceColor: Color(0xE6FFFFFF),
          primaryTextColor: Color(0xFF22182E),
          secondaryTextColor: Color(0xFF534368),
          accentColor: Color(0xFF7B2CBF),
          holidayBadgeColor: Color(0xFFFFE3E8),
          holidayBadgeTextColor: Color(0xFFD90429),
        );
    }
  }

  Color accentForIndex(int index) {
    if (mode == AppDisplayMode.rainbow) {
      return rainbowPalette[index % rainbowPalette.length];
    }
    return accentColor;
  }
}