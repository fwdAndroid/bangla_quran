import 'package:bangla_quran/model/dua_model.dart';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/provider/theme_provider.dart';
import 'package:bangla_quran/services/read_json.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({super.key});

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final AudioPlayer _player = AudioPlayer();
  int? _currentIndex;
  DuaModel? _currentDua;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest2<Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.durationStream,
        (position, duration) =>
            PositionData(position, duration ?? Duration.zero),
      );

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(List<String> audios, DuaModel dua, int index) async {
    try {
      if (_currentIndex == index) {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
      } else {
        await _player.stop();
        await _player.setUrl(audios.first);
        await _player.play();
        setState(() {
          _currentIndex = index;
          _currentDua = dua;
        });
      }
      setState(() {});
    } catch (e) {
      debugPrint("Error playing audio: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: ArabicText("Error playing audio")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      backgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF9F9F9),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<DuaModel>>(
              future: ReadJSON().ReadJsonDua(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: ArabicText("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final duas = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: duas.length,
                  itemBuilder: (context, index) {
                    final dua = duas[index];
                    final isPlaying = _currentIndex == index && _player.playing;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.85)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode ? Colors.white12 : Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            ArabicText(
                              '﷽',
                              style: TextStyle(
                                fontSize: 36,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ArabicText(
                              dua.dua ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ScheherazadeNew',
                                color: isDarkMode ? Colors.white : Colors.black,
                                shadows: [
                                  Shadow(
                                    color: Colors.amberAccent.withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ArabicText(
                              dua.translation ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ArabicText(
                              dua.reference ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? Colors.white12
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () =>
                                  _playAudio(dua.audios!, dua, index),
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                size: 24,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              label: ArabicText(
                                isPlaying ? "Pause" : "Play Audio",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🌙 Mini Player
          if (_currentDua != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  final position = positionData?.position ?? Duration.zero;
                  final duration = positionData?.duration ?? Duration.zero;
                  final isPlaying = _player.playing;

                  return Container(
                    height: 80,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.9)
                          : Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? Colors.white12 : Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              size: 36,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onPressed: () async {
                              if (isPlaying) {
                                await _player.pause();
                              } else {
                                await _player.play();
                              }
                              setState(() {});
                            },
                          ),
                          title: Text(
                            _currentDua?.dua?.substring(
                                  0,
                                  (_currentDua!.dua!.length > 20
                                      ? 20
                                      : _currentDua!.dua!.length),
                                ) ??
                                '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Slider(
                            min: 0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds
                                .clamp(0, duration.inMilliseconds)
                                .toDouble(),
                            onChanged: (value) {
                              _player.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                            },
                            activeColor: isDarkMode
                                ? Colors.white
                                : Colors.black,
                            inactiveColor: Colors.grey,
                          ),
                          trailing: Text(
                            _formatDuration(position),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            "Total: ${_formatDuration(duration)}",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDarkMode
                                  ? Colors.white54
                                  : Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

class PositionData {
  final Duration position;
  final Duration duration;
  PositionData(this.position, this.duration);
}
