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
              // Barra de Búsqueda Flotante / SliverAppBar
              _buildSliverAppBar(),

              // Contenido Principal en Slivers
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: _buildVolumetricHero(weather, code),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildSectionHeader('DETALLE POR HORA'),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: _buildHorizontalHourly(weather),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildSectionHeader('PRÓXIMOS 7 DÍAS'),
                ),
              ),

              // Lista fluida de pronóstico diario
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

              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        );
      },
      loading: () => _buildLoading(),
      error: (err, stack) => _buildErrorScreen(ref),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 100, // Espacio para que respire
      floating: true,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: PremiumGlassCard(
            blur: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white70, size: 20),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'BERAZATEGUI',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
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
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.tune_rounded, color: Colors.white70, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumetricHero(weather, int code) {
    return Column(
      children: [
        VolumetricIcon(weatherCode: code, size: 140),
        const SizedBox(height: 5),
        Text(
          '${weather.current.temperature.round()}°',
          style: GoogleFonts.manrope(
            fontSize: 140,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            height: 1,
          ),
        ),
        Text(
          _getLabel(code).toUpperCase(),
          style: GoogleFonts.manrope(
            fontSize: 12,
            letterSpacing: 12,
            color: Colors.white.withOpacity(0.4),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalHourly(weather) {
    final hourly = weather.hourly.take(6).toList();
    
    return SizedBox(
      height: 150,
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
              borderRadius: 24,
              child: Container(
                width: 85,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateTime.parse(item.time).hour}h',
                      style: GoogleFonts.manrope(
                        color: Colors.white.withOpacity(0.4), 
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    VolumetricIcon(weatherCode: item.weatherCode, size: 32),
                    Text(
                      '${item.temperature.round()}°',
                      style: GoogleFonts.manrope(
                        color: Colors.white, 
                        fontWeight: FontWeight.w900,
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
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
        child: Row(
          children: [
            VolumetricIcon(weatherCode: day.weatherCode, size: 32),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDay(day.date).toUpperCase(),
                    style: GoogleFonts.manrope(
                      color: Colors.white, 
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    _getLabel(day.weatherCode),
                    style: GoogleFonts.manrope(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${day.maxTemp.round()}°',
              style: GoogleFonts.manrope(
                color: Colors.white, 
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              '${day.minTemp.round()}°',
              style: GoogleFonts.manrope(
                color: Colors.white.withOpacity(0.2),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: GoogleFonts.manrope(
          color: Colors.white.withOpacity(0.25),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 3,
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
      backgroundColor: Color(0xFF00050A),
      body: Center(child: CircularProgressIndicator(color: Colors.white12)),
    );
  }

  Widget _buildErrorScreen(WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF00050A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white12, size: 60),
            const SizedBox(height: 20),
            Text(
              'SISTEMA FUERA DE LÍNEA',
              style: GoogleFonts.manrope(
                color: Colors.white.withOpacity(0.12),
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.05),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => ref.refresh(weatherProvider),
              child: Text(
                'REINTENTAR',
                style: TextStyle(color: Colors.white.withOpacity(0.4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
