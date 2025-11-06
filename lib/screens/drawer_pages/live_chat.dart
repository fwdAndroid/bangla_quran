import 'package:bangla_quran/chat/chat_screen.dart';
import 'package:bangla_quran/provider/language_provider.dart';
import 'package:bangla_quran/widgets/arabic_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({super.key});

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      setState(() {
        userName = snapshot['username'] ?? 'User';
      });
    } else {
      setState(() {
        userName = 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (userName == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: ArabicText(
          languageProvider.localizedStrings["Live Chat"] ?? "Live Chat",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where(
              'users',
              arrayContains: FirebaseAuth.instance.currentUser!.uid,
            )
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 100),
                  const SizedBox(height: 20),
                  const ArabicText(
                    'No messages yet. Tap admin to start chatting!',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String chatId =
                          "${FirebaseAuth.instance.currentUser!.uid}_${"ldERUuQLVCaBzAuXaHMkNvmgtIL2"}";
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .set({
                            'users': [
                              FirebaseAuth.instance.currentUser!.uid,
                              "ldERUuQLVCaBzAuXaHMkNvmgtIL2",
                            ],
                            'lastMessage': '',
                            'lastMessageTime': FieldValue.serverTimestamp(),
                          });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatId: chatId,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            userName: userName!,
                            adminId: "ldERUuQLVCaBzAuXaHMkNvmgtIL2",
                            adminName: "Al Quran Live Support",
                          ),
                        ),
                      );
                    },
                    child: ArabicText('Chat with AL Quran Live Support'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              return Card(
                child: ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: const CircleAvatar(
                    child: Icon(Icons.admin_panel_settings),
                  ),
                  title: ArabicText("Al Quran Live Support"),
                  subtitle: ArabicText(chat['lastMessage'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          chatId: chat.id,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          userName: userName!,
                          adminId: "ldERUuQLVCaBzAuXaHMkNvmgtIL2",
                          adminName: "Al Quran Live Support",
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
