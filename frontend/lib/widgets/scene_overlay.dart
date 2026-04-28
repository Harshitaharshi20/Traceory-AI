import 'package:flutter/material.dart';

class SceneOverlay extends StatelessWidget {
  const SceneOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            _buildBoundingBox(constraints.maxWidth, constraints.maxHeight, 'Crowd', 0.1, 0.1, 0.8, 0.3, Colors.purple),
            _buildBoundingBox(constraints.maxWidth, constraints.maxHeight, 'Jersey', 0.4, 0.4, 0.2, 0.4, Colors.orange),
            _buildBoundingBox(constraints.maxWidth, constraints.maxHeight, 'Grass', 0.1, 0.8, 0.8, 0.2, Colors.green),
          ],
        );
      }
    );
  }

  Widget _buildBoundingBox(double width, double height, String label, double x, double y, double w, double h, Color color) {
    return Positioned(
      left: width * x,
      top: height * y,
      width: width * w,
      height: height * h,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          color: color.withOpacity(0.1),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: color.withOpacity(0.7),
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ),
      ),
    );
  }
}
