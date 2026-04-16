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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                _buildGlassSearchBar(),
                const SizedBox(height: 40),
                _buildHeroTemperature(weather, code),
                const SizedBox(height: 60),
                _buildSectionLabel('H O Y'),
                const SizedBox(height: 15),
                _buildHourlyDiscovery(weather),
                const SizedBox(height: 40),
                _buildSectionLabel('P R Ó X I M O S  D Í A S'),
                const SizedBox(height: 20),
                _buildDailyExperiences(weather),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoading(),
      error: (err, stack) => _buildErrorScreen(ref),
    );
  }

  Widget _buildGlassSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GlassCard(
        borderRadius: 32,
        blur: 30, // Más blur para la barra superior
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 12),
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
                        letterSpacing: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'BUENOS AIRES, ARGENTINA',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTemperature(weather, int code) {
    return Center(
      child: Column(
        children: [
          WeatherIcon(
            weatherCode: code,
            size: 140,
          ),
          const SizedBox(height: 20),
          Text(
            '${weather.current.temperature.round()}°',
            style: GoogleFonts.manrope(
              fontSize: 140,
              fontWeight: FontWeight.w200, // Flowy/Apple Sophistication
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            _getLabel(code).toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 13,
              letterSpacing: 8,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyDiscovery(weather) {
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
            child: GlassCard(
              borderRadius: 24,
              child: Container(
                width: 85,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${DateTime.parse(item.time).hour}h',
                      style: GoogleFonts.manrope(
                        color: Colors.white.withOpacity(0.4), 
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    WeatherIcon(weatherCode: item.weatherCode, size: 32),
                    const SizedBox(height: 12),
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

  Widget _buildDailyExperiences(weather) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weather.daily.length,
      itemBuilder: (context, index) {
        final day = weather.daily[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderRadius: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Row(
                children: [
                  WeatherIcon(weatherCode: day.weatherCode, size: 30),
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
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          _getLabel(day.weatherCode),
                          style: GoogleFonts.manrope(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${day.maxTemp.round()}°',
                    style: GoogleFonts.manrope(
                      color: Colors.white, 
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${day.minTemp.round()}°',
                    style: GoogleFonts.manrope(
                      color: Colors.white.withOpacity(0.2),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          color: Colors.white.withOpacity(0.3),
          fontSize: 12,
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
      backgroundColor: Color(0xFF001529),
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _buildErrorScreen(WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF001529),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text('Error de conexión', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(weatherProvider),
              child: const Text('REINTENTAR'),
            ),
          ],
        ),
      ),
    );
  }
}
