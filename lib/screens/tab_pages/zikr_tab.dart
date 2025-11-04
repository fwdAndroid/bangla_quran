import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ZikrTab extends StatefulWidget {
  const ZikrTab({super.key});

  @override
  State<ZikrTab> createState() => _ZikrTabState();
}

class _ZikrTabState extends State<ZikrTab> {
  QuerySnapshot? categorySnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("zikr").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/prayecolor.png"),
                  Text('No zikr available.'),
                ],
              ),
            );
          }

          var data = snapshot.data!.docs;
          List<DocumentSnapshot> sortedData = List.from(data);
          sortedData.sort((a, b) {
            var aName = (a.data() as Map<String, dynamic>)['zikr'] ?? '';
            var bName = (b.data() as Map<String, dynamic>)['zikr'] ?? '';
            return aName.toString().toLowerCase().compareTo(
              bName.toString().toLowerCase(),
            );
          });

          categorySnapshot = snapshot.data;

          return ListView.builder(
            itemCount: sortedData.length,
            itemBuilder: (context, index) {
              var documentData =
                  sortedData[index].data() as Map<String, dynamic>;

              return Column(
                children: [
                  ListTile(
                    title: Text(
                      'Zikr Title: ${documentData['title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      documentData['zikr'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
