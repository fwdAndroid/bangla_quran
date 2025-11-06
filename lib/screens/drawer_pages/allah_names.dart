import 'package:bangla_quran/model/allah_model.dart';
import 'package:bangla_quran/utils/all_names_utils.dart';
import 'package:flutter/material.dart';

class AllahNamesScreen extends StatelessWidget {
  const AllahNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AllahName> names = allahNames;

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: const Text(
          'আল্লাহর ৯৯ নাম',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(height: 100, color: Colors.green),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                itemCount: names.length,
                itemBuilder: (context, index) {
                  final item = names[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          item.arabic,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 28,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.pronunciation,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.meaning,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _ShimmerDivider(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🌟 Custom shimmer divider like previous screen
class _ShimmerDivider extends StatefulWidget {
  @override
  State<_ShimmerDivider> createState() => _ShimmerDividerState();
}

class _ShimmerDividerState extends State<_ShimmerDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.4 + (_controller.value * 0.6);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.1),
                  Colors.green.withOpacity(opacity),
                  Colors.green.withOpacity(0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
