import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  const CustomThemeColors({
    required this.playButtonBackground,
    required this.flashCardListItemBackground
  });

  final Color? playButtonBackground;
  final Color? flashCardListItemBackground;

  @override
  CustomThemeColors copyWith({Color? playButtonBackground, Color? flashCardListItemBackground}) {
    return CustomThemeColors(
        playButtonBackground: playButtonBackground ?? this.playButtonBackground,
        flashCardListItemBackground: playButtonBackground ?? this.flashCardListItemBackground
    );
  }

  @override
  CustomThemeColors lerp(CustomThemeColors? other, double t) {
    if (other is! CustomThemeColors) {
      return this;
    }
    return CustomThemeColors(
      playButtonBackground: Color.lerp(playButtonBackground, other.playButtonBackground, t),
      flashCardListItemBackground: Color.lerp(flashCardListItemBackground, other.flashCardListItemBackground, t)
    );
  }

}