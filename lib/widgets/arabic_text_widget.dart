import 'package:bangla_quran/provider/font_provider.dart';
import 'package:bangla_quran/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArabicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontSettingsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Text(
      text,
      textDirection: TextDirection.rtl,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style:
          style?.copyWith(
            fontFamily: fontProvider.arabicFontFamily,
            fontSize: fontProvider.fontSize,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ) ??
          TextStyle(
            fontFamily: fontProvider.arabicFontFamily,
            fontSize: fontProvider.fontSize,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
