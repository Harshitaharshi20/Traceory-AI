import 'package:flutter/material.dart';
import 'dart:math';

class TrajectoryCanvas extends StatefulWidget {
  final String sessionId;
  const TrajectoryCanvas({super.key, required this.sessionId});

  @override
  State<TrajectoryCanvas> createState() => _TrajectoryCanvasState();
}

class _TrajectoryCanvasState extends State<TrajectoryCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double a, b, delta;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    
    int seed = widget.sessionId.codeUnits.fold(0, (prev, curr) => prev + curr);
    a = 3.0 + (seed % 3);
    b = 2.0 + (seed % 2);
    delta = (seed % 100) / 100.0 * pi;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _TrajectoryPainter(
            t: _controller.value * 2 * pi,
            a: a,
            b: b,
            delta: delta,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _TrajectoryPainter extends CustomPainter {
  final double t;
  final double a, b, delta;

  _TrajectoryPainter({required this.t, required this.a, required this.b, required this.delta});

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final dotPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    double A = size.width / 2.5;
    double B = size.height / 2.5;
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Draw full trajectory path (faint)
    final path = Path();
    for (double i = 0; i <= 2 * pi; i += 0.05) {
      double px = centerX + A * sin(a * i + delta);
      double py = centerY + B * sin(b * i);
      if (i == 0) path.moveTo(px, py);
      else path.lineTo(px, py);
    }
    canvas.drawPath(path, pathPaint);

    // Draw current watermark position
    double currentX = centerX + A * sin(a * t + delta);
    double currentY = centerY + B * sin(b * t);
    canvas.drawCircle(Offset(currentX, currentY), 6.0, dotPaint);
    canvas.drawCircle(Offset(currentX, currentY), 2.0, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _TrajectoryPainter oldDelegate) => true;
}
