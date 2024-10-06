import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  const CustomThemeColors( {
    required this.playButtonBackground,
    required this.flashCardListItemBackground,
    required this.flashCardListItemBorderColor,
    required this.examCardAnswerBackground,
    required this.examCardAnswerTextColor,
    required this.examButtonBackground,
    required this.playButtonBoxShadows,
    required this.examCardBoxShadows
  });

  final Color? playButtonBackground;
  final Color? flashCardListItemBackground;
  final Color? flashCardListItemBorderColor;
  final Color? examCardAnswerBackground;
  final Color? examCardAnswerTextColor;
  final Color? examButtonBackground;
  final List<BoxShadow>? playButtonBoxShadows;
  final List<BoxShadow>? examCardBoxShadows;

  @override
  CustomThemeColors copyWith({
    Color? playButtonBackground,
    Color? flashCardListItemBackground,
    Color? flashCardListItemBorderColor,
    Color? examCardAnswerBackground,
    Color? examCardAnswerTextColor,
    Color? examButtonBackground,
    List<BoxShadow>? playButtonBoxShadows,
    List<BoxShadow>? examCardBoxShadows
  }) {
    return CustomThemeColors(
        playButtonBackground: playButtonBackground ?? this.playButtonBackground,
        flashCardListItemBackground: flashCardListItemBackground ?? this.flashCardListItemBackground,
        flashCardListItemBorderColor: flashCardListItemBorderColor ?? this.flashCardListItemBorderColor,
        examCardAnswerBackground: examCardAnswerBackground ?? this.examCardAnswerBackground,
        examCardAnswerTextColor: examCardAnswerTextColor ?? this.examCardAnswerTextColor,
        examButtonBackground: examButtonBackground ?? this.examButtonBackground,
        playButtonBoxShadows: playButtonBoxShadows ?? this.playButtonBoxShadows,
        examCardBoxShadows: examCardBoxShadows ?? this.examCardBoxShadows
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
      examCardAnswerBackground: Color.lerp(examCardAnswerBackground, other.examCardAnswerBackground, t),
      examCardAnswerTextColor: Color.lerp(examCardAnswerTextColor, other.examCardAnswerTextColor, t),
      examButtonBackground: Color.lerp(examButtonBackground, other.examButtonBackground, t),
      playButtonBoxShadows: other.playButtonBoxShadows,
      examCardBoxShadows: other.examCardBoxShadows
    );
  }
}