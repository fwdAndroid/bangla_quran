import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/provider/prayer_time_provider.dart';
import 'package:quranapp/widgets/hijri_widget.dart';
import 'package:quranapp/widgets/prayer_time_widget.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  _PrayerPageState createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrayerTimeProvider>(context, listen: false);

    // Load data if not already loaded
    if (provider.prayerTimes.isEmpty && !provider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.loadLocationAndPrayerTimes();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prayer Times',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1D3B2A),
      ),
      body: RefreshIndicator(
        onRefresh: () async => provider.loadLocationAndPrayerTimes(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const HijriWidget(),
              const SizedBox(height: 20),
              const PrayerTimesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
