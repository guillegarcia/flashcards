import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  const CustomThemeColors({
    required this.playButtonBackground,
    required this.flashCardListItemBackground,
    required this.flashCardListItemBorderColor,
    required this.playButtonBoxShadows
  });

  final Color? playButtonBackground;
  final Color? flashCardListItemBackground;
  final Color? flashCardListItemBorderColor;
  final List<BoxShadow>? playButtonBoxShadows;

  @override
  CustomThemeColors copyWith({Color? playButtonBackground, Color? flashCardListItemBackground, Color? flashCardListItemBorderColor, List<BoxShadow>? playButtonBoxShadows}) {
    return CustomThemeColors(
        playButtonBackground: playButtonBackground ?? this.playButtonBackground,
        flashCardListItemBackground: playButtonBackground ?? this.flashCardListItemBackground,
        flashCardListItemBorderColor: playButtonBackground ?? this.flashCardListItemBorderColor,
        playButtonBoxShadows:playButtonBoxShadows??this.playButtonBoxShadows
    );
  }

  @override
  CustomThemeColors lerp(CustomThemeColors? other, double t) {
    if (other is! CustomThemeColors) {
      return this;
    }
    return CustomThemeColors(
      playButtonBackground: Color.lerp(playButtonBackground, other.playButtonBackground, t),
      flashCardListItemBackground: Color.lerp(flashCardListItemBackground, other.flashCardListItemBackground, t),
      flashCardListItemBorderColor: Color.lerp(flashCardListItemBorderColor, other.flashCardListItemBorderColor, t),
      playButtonBoxShadows:other.playButtonBoxShadows
    );
  }
}