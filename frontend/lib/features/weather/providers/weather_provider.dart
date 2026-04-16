import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

final weatherProvider = FutureProvider<WeatherData>((ref) async {
  // Coordenadas de Berazategui por defecto
  const double lat = -34.763;
  const double lon = -58.212;
  
  // URL del backend de Django (IP local del PC)
  final url = Uri.parse('http://192.168.100.58:8000/api/weather/forecast/?lat=$lat&lon=$lon');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return WeatherData.fromJson(data);
    } else {
      throw Exception('Error al cargar datos del clima: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
});
