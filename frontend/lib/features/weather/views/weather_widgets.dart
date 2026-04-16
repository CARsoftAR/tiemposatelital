import 'dart:ui'; // Necesario para ImageFilter
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DynamicWeatherBackground extends StatelessWidget {
  final int? weatherCode;
  final Widget child;

  const DynamicWeatherBackground({
    super.key,
    this.weatherCode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000814), // Fondo base ultra profundo
      body: Stack(
        children: [
          // Capas de Papel con Profundidad Real (5 capas de Path)
          Positioned.fill(
            child: CustomPaint(
              painter: MasterSliverPainter(),
            ),
          ),
          // Contenido principal (Slivers se manejarán en la pantalla)
          child,
        ],
      ),
    );
  }
}

class MasterSliverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Capas Orgánicas Únicas con Sombras de 25.0
    _drawPathLayer(canvas, size, paint, const Color(0xFF001D3D), 25, [
      Offset(0, size.height * 0.2),
      Offset(size.width * 0.4, size.height * 0.45),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width, size.height * 0.35),
    ]);

    _drawPathLayer(canvas, size, paint, const Color(0xFF003566), 25, [
      Offset(0, size.height * 0.4),
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.55),
      Offset(size.width, size.height * 0.45),
    ]);

    _drawPathLayer(canvas, size, paint, const Color(0xFF00509E), 25, [
      Offset(0, size.height * 0.55),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.5),
      Offset(size.width, size.height * 0.6),
    ]);

    _drawPathLayer(canvas, size, paint, const Color(0xFF0077B6), 25, [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.85),
      Offset(size.width, size.height * 0.75),
    ]);

    _drawPathLayer(canvas, size, paint, const Color(0xFF00B4D8), 25, [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.2, size.height * 0.95),
      Offset(size.width * 0.6, size.height * 0.8),
      Offset(size.width, size.height * 0.9),
    ]);
  }

  void _drawPathLayer(Canvas canvas, Size size, Paint paint, Color color, double depth, List<Offset> pts) {
    paint.color = color;
    final path = Path();
    path.moveTo(pts[0].dx, pts[0].dy);
    path.cubicTo(pts[1].dx, pts[1].dy, pts[2].dx, pts[2].dy, pts[3].dx, pts[3].dy);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Sombra de Papel Real
    canvas.drawShadow(path, Colors.black, depth, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PremiumGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;

  const PremiumGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blur = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // Opacidad solicitada del 0.1
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 0.8,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class VolumetricIcon extends StatelessWidget {
  final int weatherCode;
  final double size;

  const VolumetricIcon({
    super.key,
    required this.weatherCode,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    String url;
    if (weatherCode == 0) {
      url = 'https://lottie.host/8cd7b26c-d64e-4f0e-8f2e-4b77f9f234b4/T98653dTeD.json';
    } else if (weatherCode <= 3) {
      url = 'https://lottie.host/c9d92e59-c290-410e-88f5-7d5a5a1f6a1e/X3N9sE6n7q.json';
    } else {
      url = 'https://lottie.host/2e707e7b-f1de-448f-8973-10e3d937b83d/vOQ7Y6Yv8Z.json';
    }

    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.wb_cloudy_rounded,
          size: size * 0.5,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}
