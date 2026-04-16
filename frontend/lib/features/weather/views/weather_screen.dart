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
                _buildPremiumSearchBar(),
                const SizedBox(height: 35),
                _buildMasterHero(weather, code),
                const SizedBox(height: 50),
                _buildSectionLabel('D E T A L L E  H O R A R I O'),
                const SizedBox(height: 15),
                _buildMasterHourly(weather),
                const SizedBox(height: 40),
                _buildSectionLabel('P R Ó X I M O S  D Í A S'),
                const SizedBox(height: 15),
                _buildMasterDaily(weather),
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

  Widget _buildPremiumSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PremiumGlassCard(
        borderRadius: 30,
        blur: 40,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white70, size: 20),
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
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.tune_outlined, color: Colors.white.withOpacity(0.7), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasterHero(weather, int code) {
    return Center(
      child: Column(
        children: [
          VolumetricIcon(
            weatherCode: code,
            size: 130, // Proporción perfecta
          ),
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
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterHourly(weather) {
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
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateTime.parse(item.time).hour}h',
                      style: GoogleFonts.manrope(
                        color: Colors.white38, 
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    VolumetricIcon(weatherCode: item.weatherCode, size: 35),
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

  Widget _buildMasterDaily(weather) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weather.daily.length,
      itemBuilder: (context, index) {
        final day = weather.daily[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PremiumGlassCard(
            borderRadius: 25,
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
                            fontWeight: FontWeight.w500,
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
                      color: Colors.white.withOpacity(0.1),
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
          color: Colors.white.withOpacity(0.25),
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
      backgroundColor: Color(0xFF000B18),
      body: Center(child: CircularProgressIndicator(color: Colors.white24)),
    );
  }

  Widget _buildErrorScreen(WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF000B18),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, color: Colors.white24, size: 50),
            const SizedBox(height: 20),
            Text(
              'CONEXIÓN FALLIDA',
              style: GoogleFonts.manrope(color: Colors.white24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              onPressed: () => ref.refresh(weatherProvider),
              child: const Text('REINTENTAR', style: TextStyle(color: Colors.white60)),
            ),
          ],
        ),
      ),
    );
  }
}
