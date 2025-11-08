import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class HijriWidget extends StatelessWidget {
  const HijriWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriCalendar.now();
    final gregorianDate = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Format the Hijri and Gregorian dates
    final hijriFormatted =
        "${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} AH";
    final gregorianFormatted = DateFormat(
      'EEEE, d MMMM y',
    ).format(gregorianDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ArabicText(
            hijriFormatted,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1D3B2A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ArabicText(
            gregorianFormatted,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ArabicText(
            hijriDate.longMonthName,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
