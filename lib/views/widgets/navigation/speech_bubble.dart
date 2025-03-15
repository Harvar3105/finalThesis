import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final List<Widget> buttons;
  final Color bubbleColor;
  final double bubbleWidth;

  const SpeechBubble({
    super.key,
    required this.buttons,
    this.bubbleColor = Colors.white,
    this.bubbleWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeechBubblePainter(bubbleColor),
      child: Container(
        width: bubbleWidth,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buttons,
        ),
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final Color bubbleColor;

  _SpeechBubblePainter(this.bubbleColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = bubbleColor;
    final path = Path();

    final rect = Rect.fromLTWH(0, 15, size.width, size.height -15);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    path.addRRect(rrect);

    path.moveTo(size.width, 15);
    path.lineTo(size.width + 15, 0);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}