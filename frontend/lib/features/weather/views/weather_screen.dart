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
                const SizedBox(height: 20),
                _buildPaperSearchBar(),
                const SizedBox(height: 40),
                _buildHeroRelief(weather, code),
                const SizedBox(height: 50),
                _buildSectionLabel('DETALLE POR HORA'),
                const SizedBox(height: 20),
                _buildHourlyRelief(weather),
                const SizedBox(height: 40), // Espacio preventivo entre secciones
                _buildSectionLabel('PRÓXIMOS DÍAS'),
                const SizedBox(height: 20),
                _buildDailyRelief(weather),
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

  Widget _buildPaperSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PaperCard(
        borderRadius: 20,
        color: const Color(0xFF002244),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white, size: 22),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BERAZATEGUI',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'BUENOS AIRES, ARGENTINA',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.mic_none, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroRelief(weather, int code) {
    return Center(
      child: Column(
        children: [
          VolumetricIcon(
            weatherCode: code,
            size: 160, // Ajustado para evitar empujar contenido
          ),
          const SizedBox(height: 10),
          Text(
            '${weather.current.temperature.round()}°',
            style: GoogleFonts.manrope(
              fontSize: 120, // Ajustado ligeramente para balance
              fontWeight: FontWeight.w200,
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            _getLabel(code).toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 14,
              letterSpacing: 10,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyRelief(weather) {
    final hourly = weather.hourly.take(6).toList();
    
    return SizedBox(
      height: 155, // Altura balanceada
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hourly.length,
        itemBuilder: (context, index) {
          final item = hourly[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PaperCard(
              borderRadius: 24,
              color: const Color(0xFF003D7A),
              child: Container(
                width: 90,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribución controlada
                  children: [
                    Text(
                      '${DateTime.parse(item.time).hour}h',
                      style: GoogleFonts.manrope(
                        color: Colors.white.withOpacity(0.6), 
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    VolumetricIcon(weatherCode: item.weatherCode, size: 38), // Reducido para evitar overflow
                    Text(
                      '${item.temperature.round()}°',
                      style: GoogleFonts.manrope(
                        color: Colors.white, 
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
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

  Widget _buildDailyRelief(weather) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weather.daily.length,
      itemBuilder: (context, index) {
        final day = weather.daily[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: PaperCard(
            borderRadius: 24,
            color: const Color(0xFF002D5A),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Row(
                children: [
                  VolumetricIcon(weatherCode: day.weatherCode, size: 38),
                  const SizedBox(width: 20),
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
                            color: Colors.white.withOpacity(0.5),
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
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
          color: Colors.white.withOpacity(0.4),
          fontSize: 13,
          fontWeight: FontWeight.w600, // Ajustado a pedido
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
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 50),
            const SizedBox(height: 20),
            const Text(
              'ERROR DE SISTEMA',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
