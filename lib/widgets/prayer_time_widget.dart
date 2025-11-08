import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/provider/prayer_time_provider.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangla_quran/model/prayer_location.dart';
import 'package:bangla_quran/model/prayer_model.dart';
import 'package:bangla_quran/screens/locations/location_selector.dart';

class PrayerTimesWidget extends StatelessWidget {
  const PrayerTimesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrayerTimeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArabicText(
                languageProvider.localizedStrings['Prayer Times'] ??
                    'Prayer Times',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1D3B2A),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: isDark ? Colors.white70 : const Color(0xFF1D3B2A),
                ),
                onPressed: () async {
                  final newLocation = await Navigator.push<PrayerLocation>(
                    context,
                    MaterialPageRoute(builder: (context) => LocationSelector()),
                  );
                  if (newLocation != null) {
                    provider.updateLocation(newLocation);
                  }
                },
              ),
            ],
          ),

          /// Location Info
          if (provider.currentLocation != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 16,
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ArabicText(
                      provider.currentLocation!.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: provider.resetToCurrentLocation,
                    child: ArabicText(
                      languageProvider.localizedStrings['Reset to Current'] ??
                          'Reset to Current',
                      style: TextStyle(
                        color: isDark ? Colors.amber : const Color(0xFF1D3B2A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          /// Prayer Times / States
          if (provider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (provider.error != null)
            ArabicText(
              'Error: ${provider.error}',
              style: const TextStyle(color: Colors.red),
            )
          else
            ...provider.prayerTimes.map(
              (prayer) => _buildPrayerTimeRow(context, prayer),
            ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeRow(BuildContext context, PrayerTime prayer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: prayer.isCurrent
            ? (isDark
                  ? Colors.amber.withOpacity(0.1)
                  : const Color(0xFF1D3B2A).withOpacity(0.1))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (prayer.isCurrent)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.amber : const Color(0xFF1D3B2A),
                    shape: BoxShape.circle,
                  ),
                ),
              ArabicText(
                prayer.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: prayer.isCurrent
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: prayer.isCurrent
                      ? (isDark ? Colors.amber : const Color(0xFF1D3B2A))
                      : (isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          ArabicText(
            prayer.time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: prayer.isCurrent
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: prayer.isCurrent
                  ? (isDark ? Colors.amber : const Color(0xFF1D3B2A))
                  : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
