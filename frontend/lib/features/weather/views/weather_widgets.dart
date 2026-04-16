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
      backgroundColor: const Color(0xFF00050A), // Negro profundidad
      body: Stack(
        children: [
          // Capas de Papel Erratas y Orgánicas (Profundidad Real)
          Positioned.fill(
            child: CustomPaint(
              painter: PaperCutArtPainter(),
            ),
          ),
          // El contenido debe ser un Sliver para el scroll fluido
          child,
        ],
      ),
    );
  }
}

class PaperCutArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // CAPA 1: Abismo (Azul Casi Negro)
    _drawErraticPath(canvas, size, paint, const Color(0xFF001021), 25, [
      Offset(0, size.height * 0.15),
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.1),
      Offset(size.width, size.height * 0.3),
    ]);

    // CAPA 2: Marino Profundo
    _drawErraticPath(canvas, size, paint, const Color(0xFF001E3C), 25, [
      Offset(0, size.height * 0.4),
      Offset(size.width * 0.35, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.5),
      Offset(size.width, size.height * 0.4),
    ]);

    // CAPA 3: Cobalto Real
    _drawErraticPath(canvas, size, paint, const Color(0xFF003870), 25, [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.75),
      Offset(size.width * 0.85, size.height * 0.55),
      Offset(size.width, size.height * 0.65),
    ]);

    // CAPA 4: Azul Eléctrico
    _drawErraticPath(canvas, size, paint, const Color(0xFF0059B3), 25, [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.3, size.height * 0.65),
      Offset(size.width * 0.65, size.height * 0.85),
      Offset(size.width, size.height * 0.7),
    ]);

    // CAPA 5: Acero Neón (Cima)
    _drawErraticPath(canvas, size, paint, const Color(0xFF0080FF), 25, [
      Offset(0, size.height * 0.9),
      Offset(size.width * 0.4, size.height * 0.95),
      Offset(size.width * 0.75, size.height * 0.85),
      Offset(size.width, size.height * 0.95),
    ]);
  }

  void _drawErraticPath(Canvas canvas, Size size, Paint paint, Color color, double depth, List<Offset> pts) {
    paint.color = color;
    final path = Path();
    path.moveTo(pts[0].dx, pts[0].dy);
    
    // Curvas Bezier de tercer grado para formas mucho más orgánicas
    path.cubicTo(
      pts[1].dx, pts[1].dy,
      pts[2].dx, pts[2].dy,
      pts[3].dx, pts[3].dy,
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

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
    this.borderRadius = 28.0,
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
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 0.5,
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
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}
