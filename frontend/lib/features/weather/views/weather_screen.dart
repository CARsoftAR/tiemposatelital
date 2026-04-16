import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/weather_provider.dart';
import 'weather_widgets.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      data: (weather) {
        if (weather == null) return _buildLoading();
        final code = weather.current.weatherCode;

        return DynamicWeatherBackground(
          weatherCode: code,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Barra de Búsqueda Premium
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                  child: _buildSliverSearchBar(),
                ),
              ),
              
              // Hero Section: Temperatura y Icono
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 60),
                  child: _buildSliverHero(weather, code),
                ),
              ),

              // Sección: Detalle Horario
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('DETALLE POR HORA'),
                    const SizedBox(height: 15),
                    _buildSliverHourly(weather),
                    const SizedBox(height: 45),
                    _buildSectionTitle('PRÓXIMOS DÍAS'),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // Lista: Pronóstico Diario
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final day = weather.daily[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildDailyGlassCard(day),
                      );
                    },
                    childCount: weather.daily.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
      loading: () => _buildLoading(),
      error: (err, stack) => _buildErrorScreen(ref),
    );
  }

  Widget _buildSliverSearchBar() {
    return PremiumGlassCard(
      blur: 30,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.white60, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BERAZATEGUI',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'BUENOS AIRES, ARGENTINA',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.tune_outlined, color: Colors.white60, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHero(weather, int code) {
    return Column(
      children: [
        VolumetricIcon(weatherCode: code, size: 150),
        const SizedBox(height: 10),
        Text(
          '${weather.current.temperature.round()}°',
          style: GoogleFonts.manrope(
            fontSize: 130,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            height: 1,
          ),
        ),
        Text(
          _getLabel(code).toUpperCase(),
          style: GoogleFonts.manrope(
            fontSize: 12,
            letterSpacing: 10,
            color: Colors.white.withOpacity(0.4),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSliverHourly(weather) {
    final hourly = weather.hourly.take(6).toList();
    
    return SizedBox(
      height: 155,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hourly.length,
        itemBuilder: (context, index) {
          final item = hourly[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PremiumGlassCard(
              borderRadius: 25,
              child: Container(
                width: 85,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateTime.parse(item.time).hour}h',
                      style: GoogleFonts.manrope(
                        color: Colors.white38, 
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    VolumetricIcon(weatherCode: item.weatherCode, size: 32),
                    Text(
                      '${item.temperature.round()}°',
                      style: GoogleFonts.manrope(
                        color: Colors.white, 
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyGlassCard(day) {
    return PremiumGlassCard(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          children: [
            VolumetricIcon(weatherCode: day.weatherCode, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDay(day.date).toUpperCase(),
                    style: GoogleFonts.manrope(
                      color: Colors.white, 
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    _getLabel(day.weatherCode),
                    style: GoogleFonts.manrope(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${day.maxTemp.round()}°',
              style: GoogleFonts.manrope(
                color: Colors.white, 
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${day.minTemp.round()}°',
              style: GoogleFonts.manrope(
                color: Colors.white.withOpacity(0.15),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: GoogleFonts.manrope(
          color: Colors.white24,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
        ),
      ),
    );
  }

  String _getLabel(int code) {
    if (code == 0) return 'Despejado';
    if (code <= 3) return 'Nuboso';
    if (code <= 48) return 'Niebla';
    if (code <= 67) return 'Lluvia';
    return 'Tormenta';
  }

  String _getDay(String date) {
    final d = DateTime.parse(date);
    final names = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return names[d.weekday - 1];
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: Color(0xFF000814),
      body: Center(child: CircularProgressIndicator(color: Colors.white10)),
    );
  }

  Widget _buildErrorScreen(WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF000814),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_outlined, color: Colors.white10, size: 60),
            const SizedBox(height: 20),
            Text(
              'ERROR DE SISTEMA',
              style: GoogleFonts.manrope(color: Colors.white10, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.05)),
              onPressed: () => ref.refresh(weatherProvider),
              child: Text('REINTENTAR', style: TextStyle(color: Colors.white.withOpacity(0.38))),
            ),
          ],
        ),
      ),
    );
  }
}
