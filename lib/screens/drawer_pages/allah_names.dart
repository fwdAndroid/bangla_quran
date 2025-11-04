import 'package:flutter/material.dart';
import 'package:quranapp/utils/allah_names_utils.dart';

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
                  title: Text(
                    names[index]['arabic']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    names[index]['meaning']!,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
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
