import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DuaTab extends StatefulWidget {
  const DuaTab({super.key});

  @override
  State<DuaTab> createState() => _DuaTabState();
}

class _DuaTabState extends State<DuaTab> {
  QuerySnapshot? categorySnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("dua").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/Icon.png"),
                Center(child: Text('No dua available.')),
              ],
            );
          }

          var data = snapshot.data!.docs;
          List<DocumentSnapshot> sortedData = List.from(data);
          sortedData.sort((a, b) {
            var aName =
                (a.data() as Map<String, dynamic>)['categoryName'] ?? '';
            var bName =
                (b.data() as Map<String, dynamic>)['categoryName'] ?? '';
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
                      'Dua Title: ${documentData['title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      documentData['dua'],
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
