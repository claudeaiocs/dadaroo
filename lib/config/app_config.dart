import 'package:flutter/material.dart';

class AppConfig {
  final String appName;
  final String parentRole;
  final String parentRoleLower;
  final String parentEmoji;
  final String familyMemberEmoji;
  final String tagline;
  final String deepLinkScheme;

  // Theme colours
  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorDark;
  final Color darkAccent;
  final Color warmAccent;
  final Color lightAccent;
  final Color cream;
  final Color accentHighlight;

  const AppConfig({
    required this.appName,
    required this.parentRole,
    required this.parentRoleLower,
    required this.parentEmoji,
    required this.familyMemberEmoji,
    required this.tagline,
    required this.deepLinkScheme,
    required this.primaryColor,
    required this.primaryColorLight,
    required this.primaryColorDark,
    required this.darkAccent,
    required this.warmAccent,
    required this.lightAccent,
    required this.cream,
    required this.accentHighlight,
  });

  /// "Dad's" or "Mum's"
  String get parentPossessive => "$parentRole's";

  /// "DAD'S HOME!" or "MUM'S HOME!"
  String get arrivalShout => "${parentRole.toUpperCase()}'S HOME!";

  /// "Rate Your Dad" or "Rate Your Mum"
  String get rateParentLabel => 'Rate Your $parentRole';

  /// "Overall Dadness" or "Overall Mumness"
  String get overallRatingLabel => 'Overall ${parentRole}ness';

  /// "Dad Stats" or "Mum Stats"
  String get statsLabel => '$parentRole Stats';

  /// "Dad Leaderboard" or "Mum Leaderboard"
  String get leaderboardLabel => '$parentRole Leaderboard';

  /// Badge title helper - "5-Star Dad" or "5-Star Mum"
  String get fiveStarBadgeTitle => '5-Star $parentRole';

  /// "Consistent Dad" or "Consistent Mum"
  String get consistentBadgeTitle => 'Consistent $parentRole';

  /// "Variety King" or "Variety Queen"
  String get varietyBadgeTitle =>
      parentRole == 'Mum' ? 'Variety Queen' : 'Variety King';

  // ── Factory presets ──

  static const dadaroo = AppConfig(
    appName: 'Dadaroo',
    parentRole: 'Dad',
    parentRoleLower: 'dad',
    parentEmoji: '👨',
    familyMemberEmoji: '👨‍👩‍👧‍👦',
    tagline: 'Track the takeaway. Rate your Dad.',
    deepLinkScheme: 'dadaroo',
    primaryColor: Color(0xFFE8751A),
    primaryColorLight: Color(0xFFFF8C42),
    primaryColorDark: Color(0xFFD4600A),
    darkAccent: Color(0xFF4A2C0A),
    warmAccent: Color(0xFF8B5E3C),
    lightAccent: Color(0xFFFFF3E0),
    cream: Color(0xFFFFF8F0),
    accentHighlight: Color(0xFFFFB74D),
  );

  static const mumaroo = AppConfig(
    appName: 'Mumaroo',
    parentRole: 'Mum',
    parentRoleLower: 'mum',
    parentEmoji: '👩',
    familyMemberEmoji: '👨‍👩‍👧‍👦',
    tagline: 'Track the takeaway. Rate your Mum.',
    deepLinkScheme: 'mumaroo',
    primaryColor: Color(0xFFAD1457),
    primaryColorLight: Color(0xFFD81B60),
    primaryColorDark: Color(0xFF880E4F),
    darkAccent: Color(0xFF3E2723),
    warmAccent: Color(0xFF6D4C41),
    lightAccent: Color(0xFFFCE4EC),
    cream: Color(0xFFFFF8F6),
    accentHighlight: Color(0xFFF48FB1),
  );
}

/// The active config for this build. Change this one line to switch between Dadaroo and Mumaroo.
const AppConfig appConfig = AppConfig.dadaroo;
