import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:bangla_quran/utils/allah_names_utils.dart';

class AllahNames extends StatefulWidget {
  const AllahNames({super.key});

  @override
  State<AllahNames> createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('99 Names of Allah')),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: ArabicText(
                    names[index]['arabic']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: ArabicText(
                    names[index]['meaning']!,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: ArabicText(
                    names[index]['transliteration']!,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
