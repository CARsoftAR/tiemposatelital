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
      backgroundColor: const Color(0xFF000B18), // Profundidad absoluta
      body: Stack(
        children: [
          // Capas de Papel Artísticas (REESCRITURA TOTAL)
          Positioned.fill(
            child: CustomPaint(
              painter: MasterPaperCutPainter(),
            ),
          ),
          // Scrollable content
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class MasterPaperCutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // CAPA 1: Azul Profundo (Base)
    _drawComplexLayer(canvas, size, paint, const Color(0xFF001F3D), 0.3, 0.5, [
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.3),
    ], 20);

    // CAPA 2: Azul Marino
    _drawComplexLayer(canvas, size, paint, const Color(0xFF00305C), 0.4, 0.6, [
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.35),
      Offset(size.width * 0.9, size.height * 0.5),
    ], 22);

    // CAPA 3: Azul Cobalto
    _drawComplexLayer(canvas, size, paint, const Color(0xFF004481), 0.5, 0.7, [
      Offset(size.width * 0.1, size.height * 0.55),
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.7, size.height * 0.5),
    ], 25);

    // CAPA 4: Azul Eléctrico
    _drawComplexLayer(canvas, size, paint, const Color(0xFF0059B3), 0.6, 0.8, [
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.8, size.height * 0.85),
    ], 28);

    // CAPA 5: Azul Acero (Cima)
    _drawComplexLayer(canvas, size, paint, const Color(0xFF0074D9), 0.7, 0.9, [
      Offset(size.width * 0.15, size.height * 0.85),
      Offset(size.width * 0.45, size.height * 0.95),
      Offset(size.width * 0.75, size.height * 0.8),
    ], 30);
  }

  void _drawComplexLayer(Canvas canvas, Size size, Paint paint, Color color, double yStart, double yEnd, List<Offset> controlPoints, double blur) {
    paint.color = color;
    final path = Path();
    path.moveTo(0, size.height * yStart);
    
    // Curvas orgánicas complejas para evitar el "efecto onda genérica"
    path.cubicTo(
      controlPoints[0].dx, controlPoints[0].dy,
      controlPoints[1].dx, controlPoints[1].dy,
      controlPoints[2].dx, controlPoints[2].dy,
    );
    
    path.lineTo(size.width, size.height * yEnd);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Sombra profunda Master
    canvas.drawShadow(path, Colors.black, blur, true);
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
    this.blur = 25.0, // Elevada sofisticación
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04), // Sutil elegancia Flowy
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
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
      url = 'https://lottie.host/8cd7b26c-d64e-4f0e-8f2e-4b77f9f234b4/T98653dTeD.json'; // Sun
    } else if (weatherCode <= 3) {
      url = 'https://lottie.host/c9d92e59-c290-410e-88f5-7d5a5a1f6a1e/X3N9sE6n7q.json'; // Cloud
    } else {
      url = 'https://lottie.host/2e707e7b-f1de-448f-8973-10e3d937b83d/vOQ7Y6Yv8Z.json'; // Rain
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
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}
