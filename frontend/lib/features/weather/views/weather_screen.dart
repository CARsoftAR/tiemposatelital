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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  _buildHeader(),
                  const SizedBox(height: 50),
                  _buildMainBody(weather, code),
                  const SizedBox(height: 60),
                  _buildSectionLabel('H O Y'),
                  const SizedBox(height: 15),
                  _buildHourlyRow(weather),
                  const SizedBox(height: 40),
                  _buildSectionLabel('P R Ó X I M O S  D Í A S'),
                  const SizedBox(height: 20),
                  _buildDailyList(weather),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => _buildLoading(),
      error: (err, stack) => _buildErrorScreen(ref),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BERAZATEGUI',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'BUENOS AIRES, ARGENTINA',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, color: Colors.white),
      ],
    );
  }

  Widget _buildMainBody(weather, int code) {
    return Center(
      child: Column(
        children: [
          WeatherIcon(
            weatherCode: code,
            size: 150,
          ),
          const SizedBox(height: 30),
          Text(
            '${weather.current.temperature.round()}°',
            style: GoogleFonts.poppins(
              fontSize: 130, // Gigante
              fontWeight: FontWeight.w200, // Delgado y elegante
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            _getLabel(code).toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 14,
              letterSpacing: 6,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        color: Colors.white.withOpacity(0.4),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildHourlyRow(weather) {
    final hourly = weather.hourly.take(6).toList();
    
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hourly.length,
        itemBuilder: (context, index) {
          final item = hourly[index];
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GlassCard(
              child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${DateTime.parse(item.time).hour}h',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.5), 
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    WeatherIcon(weatherCode: item.weatherCode, size: 28),
                    const SizedBox(height: 10),
                    Text(
                      '${item.temperature.round()}°',
                      style: GoogleFonts.poppins(
                        color: Colors.white, 
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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

  Widget _buildDailyList(weather) {
    return Column(
      children: [
        for (var day in weather.daily)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getDay(day.date).toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: Colors.white, 
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    WeatherIcon(weatherCode: day.weatherCode, size: 28),
                    const SizedBox(width: 30),
                    Text(
                      '${day.maxTemp.round()}°',
                      style: GoogleFonts.poppins(
                        color: Colors.white, 
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${day.minTemp.round()}°',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
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
      backgroundColor: Color(0xFF001F3F),
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _buildErrorScreen(WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 48),
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
