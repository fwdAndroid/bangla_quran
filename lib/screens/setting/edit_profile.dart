import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quranapp/screens/main/main_dashboard.dart';
import 'package:quranapp/utils/show_message_bar.dart';
import 'package:quranapp/widgets/save_button_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    setState(() {
      nameController.text = data['username'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Edit Profile")),
        body: Column(
          children: [
            // Profile Image Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/logo.png"),
            ),

            // Full Name Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Your Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            Spacer(),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1D3B2A),
                      ),
                    )
                  : SaveButton(
                      title: "Edit Profile",
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({"username": nameController.text});
                          showMessageBar(
                            "Successfully Updated Profile",
                            context,
                          );
                        } catch (e) {
                          print("Error updating profile: $e");
                          showMessageBar(
                            "Profile could not be updated",
                            context,
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => MainDashboard(),
                            ),
                          );
                        }
                      },
                    ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
