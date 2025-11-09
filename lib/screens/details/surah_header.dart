import 'package:flutter/material.dart';

class SurahHeaderOrnament extends StatelessWidget {
  final String surahName;
  final String revelationType; // "মাক্কী" or "মাদানী"
  final int totalVerses;

  const SurahHeaderOrnament({
    super.key,
    required this.surahName,
    required this.revelationType,
    required this.totalVerses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: OrnamentalHeaderPainter(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _badge(revelationType),
                Expanded(
                  child: Center(
                    child: Text(
                      surahName,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3C2F1B),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Amiri",
                      ),
                    ),
                  ),
                ),
                _badge("$totalVerses আয়াত"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFFDF9ED),
        border: Border.all(color: Color(0xFF8B6C3A), width: 1.6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6E5328),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class OrnamentalHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF4E7C7), Color(0xFFE9D8AF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final border = Paint()
      ..color = const Color(0xFF8A6B32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(18),
    );

    canvas.drawRRect(rect, bg);
    canvas.drawRRect(rect, border);

    // Ornamental Flourish Shapes
    final ornament = Paint()
      ..color = const Color(0xFF9A7B44).withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Left flourish
    final left = Path()
      ..moveTo(18, size.height * 0.55)
      ..quadraticBezierTo(4, size.height * 0.35, 18, size.height * 0.15)
      ..quadraticBezierTo(40, size.height * 0.33, 22, size.height * 0.55);
    canvas.drawPath(left, ornament);

    // Right flourish
    final right = Path()
      ..moveTo(size.width - 18, size.height * 0.55)
      ..quadraticBezierTo(
        size.width - 4,
        size.height * 0.35,
        size.width - 18,
        size.height * 0.15,
      )
      ..quadraticBezierTo(
        size.width - 40,
        size.height * 0.33,
        size.width - 22,
        size.height * 0.55,
      );
    canvas.drawPath(right, ornament);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
