import 'dart:ui'; // Necesario para ImageFilter
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

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
      body: Stack(
        children: [
          // Capas Topográficas de Fondo (Estilo Papel Azul)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF001F3F), Color(0xFF003366)], // Azul Profundo
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: TopographicPainter(),
            ),
          ),
          // Contenido Principal
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class TopographicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Capa 1 (Más profunda)
    paint.color = const Color(0xFF004080).withOpacity(0.5);
    _drawLayer(canvas, size, 0.4, 0.6, paint, shadow: true);

    // Capa 2
    paint.color = const Color(0xFF0059B3).withOpacity(0.4);
    _drawLayer(canvas, size, 0.5, 0.7, paint, shadow: true);

    // Capa 3
    paint.color = const Color(0xFF0073E6).withOpacity(0.3);
    _drawLayer(canvas, size, 0.6, 0.8, paint, shadow: true);
  }

  void _drawLayer(Canvas canvas, Size size, double y1, double y2, Paint paint, {bool shadow = false}) {
    final path = Path();
    path.moveTo(0, size.height * y1);
    path.quadraticBezierTo(
      size.width * 0.4, size.height * (y1 - 0.1),
      size.width * 0.7, size.height * y2,
    );
    path.quadraticBezierTo(
      size.width * 0.9, size.height * (y2 + 0.1),
      size.width, size.height * (y1 + 0.05),
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    if (shadow) {
      canvas.drawShadow(path, Colors.black, 15, true);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class WeatherIcon extends StatelessWidget {
  final int weatherCode;
  final double size;
  final Color color;

  const WeatherIcon({
    super.key,
    required this.weatherCode,
    this.size = 24.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    if (weatherCode == 0) {
      iconData = Icons.wb_sunny_rounded;
    } else if (weatherCode <= 3) {
      iconData = Icons.wb_cloudy_rounded;
    } else if (weatherCode <= 48) {
      iconData = Icons.filter_drama_rounded;
    } else if (weatherCode <= 67) {
      iconData = Icons.umbrella_rounded;
    } else {
      iconData = Icons.flash_on_rounded;
    }

    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}
