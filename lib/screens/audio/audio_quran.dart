import 'package:bangla_quran/api/api_calls.dart';
import 'package:bangla_quran/model/qari_model.dart';
import 'package:bangla_quran/model/quran_audio_model.dart';
import 'package:bangla_quran/screens/audio/audio_surah_screen.dart';
import 'package:bangla_quran/widgets/qari_custom_tile_widget.dart';
import 'package:flutter/material.dart';

class AudioQuran extends StatefulWidget {
  const AudioQuran({super.key});

  @override
  State<AudioQuran> createState() => _AudioQuranState();
}

class _AudioQuranState extends State<AudioQuran> {
  late Future<QuranAudio> _quranAudio;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quranAudio = ApiCalls().getQuranAudio();
  }

  @override
  Widget build(BuildContext context) {
    ApiCalls apiServices = ApiCalls();
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: apiServices.getQariList(),
        builder: (BuildContext context, AsyncSnapshot<List<Qari>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Qari's data not found"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        QariCustomTile(
                          index: index, // 👈 pass index here

                          qari: snapshot.data![index],
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AudioSurahScreen(
                                  qari: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
