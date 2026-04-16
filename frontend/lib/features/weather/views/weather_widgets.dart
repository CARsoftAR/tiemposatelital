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
      backgroundColor: const Color(0xFF001529),
      body: Stack(
        children: [
          // Fondo de Referencia (5 Capas Orgánicas)
          Positioned.fill(
            child: CustomPaint(
              painter: DeepTopographicPainter(),
            ),
          ),
          // Contenido principal
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class DeepTopographicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Capa 1: Azul Profundo Base
    paint.color = const Color(0xFF001A33);
    _drawLayer(canvas, size, 0.25, 0.45, paint, 10);

    // Capa 2: Azul Cobalto
    paint.color = const Color(0xFF003366);
    _drawLayer(canvas, size, 0.35, 0.55, paint, 15);

    // Capa 3: Azul Eléctrico Vibrante
    paint.color = const Color(0xFF004080);
    _drawLayer(canvas, size, 0.45, 0.65, paint, 20);

    // Capa 4: Azul Cielo Oscuro
    paint.color = const Color(0xFF0059B3);
    _drawLayer(canvas, size, 0.55, 0.75, paint, 25);

    // Capa 5: Azul Acero (Más cercana)
    paint.color = const Color(0xFF0073E6);
    _drawLayer(canvas, size, 0.65, 0.85, paint, 30);
  }

  void _drawLayer(Canvas canvas, Size size, double y1, double y2, Paint paint, double shadowDepth) {
    final path = Path();
    path.moveTo(0, size.height * y1);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * (y1 - 0.15),
      size.width * 0.6, size.height * y2,
    );
    path.quadraticBezierTo(
      size.width * 0.85, size.height * (y2 + 0.12),
      size.width, size.height * (y1 + 0.05),
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Sombra Proyectada Profunda (Estilo Paper-cut)
    canvas.drawShadow(path, Colors.black, shadowDepth, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PaperCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color color;

  const PaperCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.color = const Color(0xFF003366),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.9), // Opaca
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
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
    // Usamos Lottie con relieve si es posible, o una representación robusta
    String url = 'https://lottie.host/8cd7b26c-d64e-4f0e-8f2e-4b77f9f234b4/T98653dTeD.json'; // Sun 3D style
    
    if (weatherCode > 0 && weatherCode <= 3) {
      url = 'https://lottie.host/c9d92e59-c290-410e-88f5-7d5a5a1f6a1e/X3N9sE6n7q.json'; // Cloud 3D
    } else if (weatherCode > 3) {
      url = 'https://lottie.host/2e707e7b-f1de-448f-8973-10e3d937b83d/vOQ7Y6Yv8Z.json'; // Rain 3D
    }

    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.wb_cloudy_rounded,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
