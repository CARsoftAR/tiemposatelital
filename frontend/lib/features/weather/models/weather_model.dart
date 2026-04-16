class WeatherData {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;
  final Map<String, dynamic> metadata;

  WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.metadata,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current']),
      hourly: (json['hourly'] as List)
          .map((i) => HourlyWeather.fromJson(i))
          .toList(),
      daily: (json['daily'] as List)
          .map((i) => DailyWeather.fromJson(i))
          .toList(),
      metadata: json['metadata'],
    );
  }
}

class CurrentWeather {
  final double temperature;
  final int weatherCode;
  final String time;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      weatherCode: json['weather_code'],
      time: json['time'],
    );
  }
}

class HourlyWeather {
  final String time;
  final double temperature;
  final int rainProbability;
  final int weatherCode;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.rainProbability,
    required this.weatherCode,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json['time'],
      temperature: (json['temperature'] as num).toDouble(),
      rainProbability: json['rain_probability'],
      weatherCode: json['weather_code'],
    );
  }
}

class DailyWeather {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: json['date'],
      maxTemp: (json['max_temp'] as num).toDouble(),
      minTemp: (json['min_temp'] as num).toDouble(),
      weatherCode: json['weather_code'],
    );
  }
}
