import 'dart:ui'; // Necesario para ImageFilter
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          // Fondo Profundo (Identidad Flowy)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF001529), Color(0xFF003366)], 
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: TopographicPainter(),
            ),
          ),
          // Contenido principal con Glassmorphism
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

    // Capas Orgánicas con Sombras Profundas
    paint.color = const Color(0xFF002D5A).withOpacity(0.6);
    _drawLayer(canvas, size, 0.35, 0.55, paint);

    paint.color = const Color(0xFF004080).withOpacity(0.5);
    _drawLayer(canvas, size, 0.45, 0.65, paint);

    paint.color = const Color(0xFF0059B3).withOpacity(0.4);
    _drawLayer(canvas, size, 0.55, 0.75, paint);
  }

  void _drawLayer(Canvas canvas, Size size, double y1, double y2, Paint paint) {
    final path = Path();
    path.moveTo(0, size.height * y1);
    path.quadraticBezierTo(
      size.width * 0.45, size.height * (y1 - 0.12),
      size.width * 0.75, size.height * y2,
    );
    path.quadraticBezierTo(
      size.width * 0.95, size.height * (y2 + 0.08),
      size.width, size.height * (y1 + 0.02),
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.8), 20, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blur = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.1), // Hilo blanco casi invisible
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
