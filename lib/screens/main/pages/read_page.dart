import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/provider/prayer_time_provider.dart';
import 'package:quranapp/screens/tab_pages/hijab_tab.dart';
import 'package:quranapp/screens/tab_pages/page_tab.dart';
import 'package:quranapp/screens/tab_pages/para_tab.dart';
import 'package:quranapp/screens/tab_pages/surah_tab.dart';
import 'package:quranapp/widgets/drawer_widget.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  @override
  void initState() {
    super.initState();
    // Load prayer times when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PrayerTimeProvider>(context, listen: false);
      if (provider.prayerTimes.isEmpty) {
        provider.loadLocationAndPrayerTimes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrayerTimeProvider>(context);
    final hijriDate = HijriCalendar.now(); // Get current Hijri date
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(),
        drawer: DrawerWidget(),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: ClipPath(
                clipper: CloudClipper(),
                child: Container(
                  height: 255,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF017B84),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                const Text(
                                  'Jadwal solat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear}H',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                if (provider.currentLocation != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      provider.currentLocation!.name,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Image.asset(
                              'assets/logo.png',
                              height: 50,
                              width: 50,
                            ),
                          ],
                        ),
                      ),

                      /// Prayer times row
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: provider.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : provider.error != null
                            ? Text(
                                'Error: ${provider.error}',
                                style: const TextStyle(color: Colors.white),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildPrayerTime(
                                    'Fajr',
                                    provider.getPrayerTime('Fajr'),
                                    Icons.wb_cloudy,
                                    provider.isCurrentPrayer('Fajr'),
                                  ),
                                  _buildPrayerTime(
                                    'Dhuhr',
                                    provider.getPrayerTime('Dhuhr'),
                                    Icons.wb_sunny,
                                    provider.isCurrentPrayer('Dhuhr'),
                                  ),
                                  _buildPrayerTime(
                                    'Asr',
                                    provider.getPrayerTime('Asr'),
                                    Icons.cloud,
                                    provider.isCurrentPrayer('Asr'),
                                  ),
                                  _buildPrayerTime(
                                    'Maghrib',
                                    provider.getPrayerTime('Maghrib'),
                                    Icons.nightlight_round,
                                    provider.isCurrentPrayer('Maghrib'),
                                  ),
                                  _buildPrayerTime(
                                    'Isha',
                                    provider.getPrayerTime('Isha'),
                                    Icons.dark_mode,
                                    provider.isCurrentPrayer('Isha'),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const TabBar(
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              tabs: [
                Tab(text: 'Surah'),
                Tab(text: 'Para'),
                Tab(text: 'Page'),
                Tab(text: 'Hijab'),
              ],
            ),

            // 🔽 Add TabBarView inside Expanded
            Expanded(
              child: TabBarView(
                children: [SurahTab(), ParaTab(), PageTab(), HijabTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTime(
    String title,
    String time,
    IconData icon,
    bool isCurrent,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            fontSize: isCurrent ? 16 : 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            fontSize: isCurrent ? 16 : 14,
          ),
        ),
        const SizedBox(height: 4),
        Icon(icon, size: 20, color: isCurrent ? Colors.white : Colors.white70),
        if (isCurrent)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

/// Widget for individual prayer time block
class PrayerTimeWidget extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;

  const PrayerTimeWidget({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Icon(icon, size: 20, color: Colors.white70),
      ],
    );
  }
}

/// Custom Clipper for curved cloud shape
class CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Draw cloud-like top
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.1,
      size.width * 0.25,
      size.height * 0.25,
    );
    path.quadraticBezierTo(
      size.width * 0.4,
      0,
      size.width * 0.5,
      size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.3,
      size.width * 0.7,
      size.height * 0.15,
    );
    path.quadraticBezierTo(size.width * 0.85, 0, size.width, size.height * 0.3);

    // Right edge and bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
