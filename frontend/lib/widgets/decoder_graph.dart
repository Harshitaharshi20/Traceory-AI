import 'package:flutter/material.dart';
import 'dart:math';

class DecoderGraph extends StatelessWidget {
  final String sessionId;
  const DecoderGraph({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          CustomPaint(
            painter: _DecoderGraphPainter(sessionId: sessionId),
            child: Container(),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Lissajous Match: 99.8%\nAttribution Confirmed',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _DecoderGraphPainter extends CustomPainter {
  final String sessionId;
  _DecoderGraphPainter({required this.sessionId});

  @override
  void paint(Canvas canvas, Size size) {
    int seed = sessionId.codeUnits.fold(0, (prev, curr) => prev + curr);
    double a = 3.0 + (seed % 3);
    double b = 2.0 + (seed % 2);
    double delta = (seed % 100) / 100.0 * pi;

    final curvePaint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final scatterPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;

    double A = size.width / 2.5;
    double B = size.height / 2.5;
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Draw expected curve (ideal math formula)
    final path = Path();
    for (double i = 0; i <= 2 * pi; i += 0.05) {
      double px = centerX + A * sin(a * i + delta);
      double py = centerY + B * sin(b * i);
      if (i == 0) path.moveTo(px, py);
      else path.lineTo(px, py);
    }
    canvas.drawPath(path, curvePaint);

    // Draw extracted points (simulating noise from compressed pirated video)
    final random = Random(seed);
    for (double i = 0; i <= 2 * pi; i += 0.2) {
      double noiseX = (random.nextDouble() - 0.5) * 15;
      double noiseY = (random.nextDouble() - 0.5) * 15;
      
      double px = centerX + A * sin(a * i + delta) + noiseX;
      double py = centerY + B * sin(b * i) + noiseY;
      
      canvas.drawCircle(Offset(px, py), 2.5, scatterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DecoderGraphPainter oldDelegate) => false;
}
