from rest_framework import serializers

class WeatherResponseSerializer(serializers.Serializer):
    """
    Structured serializer that handles Open-Meteo's weather_code correctly.
    """
    current = serializers.SerializerMethodField()
    hourly = serializers.SerializerMethodField()
    daily = serializers.SerializerMethodField()
    metadata = serializers.SerializerMethodField()

    def get_current(self, obj):
        current = obj.get('current_weather', {})
        return {
            "temperature": current.get('temperature'),
            "weather_code": current.get('weathercode') or current.get('weather_code'),
            "time": current.get('time')
        }

    def get_hourly(self, obj):
        hourly = obj.get('hourly', {})
        times = hourly.get('time', [])
        temps = hourly.get('temperature_2m', [])
        rain_probs = hourly.get('precipitation_probability', [])
        codes = hourly.get('weather_code', hourly.get('weathercode', []))
        
        return [
            {
                "time": times[i],
                "temperature": temps[i],
                "rain_probability": rain_probs[i],
                "weather_code": codes[i]
            }
            for i in range(len(times))
        ]

    def get_daily(self, obj):
        daily = obj.get('daily', {})
        times = daily.get('time', [])
        max_temps = daily.get('temperature_2m_max', [])
        min_temps = daily.get('temperature_2m_min', [])
        codes = daily.get('weather_code', daily.get('weathercode', []))
        
        return [
            {
                "date": times[i],
                "max_temp": max_temps[i],
                "min_temp": min_temps[i],
                "weather_code": codes[i]
            }
            for i in range(len(times))
        ]

    def get_metadata(self, obj):
        return {
            "latitude": obj.get("latitude"),
            "longitude": obj.get("longitude"),
            "timezone": obj.get("timezone"),
            "elevation": obj.get("elevation")
        }
