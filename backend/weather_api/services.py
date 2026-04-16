import requests
from rest_framework import status

class WeatherEngine:
    """
    Expert Service for fetching and processing weather data from Open-Meteo.
    Uses modern weather_code parameter for maximum compatibility.
    """
    
    BASE_URL = "https://api.open-meteo.com/v1/forecast"

    @staticmethod
    def get_forecast(lat, lon):
        params = {
            "latitude": lat,
            "longitude": lon,
            "hourly": "temperature_2m,precipitation_probability,weather_code",
            "daily": "weather_code,temperature_2m_max,temperature_2m_min",
            "current_weather": "true",
            "timezone": "America/Argentina/Buenos_Aires",
        }
        
        try:
            # Validamos que lat y lon no sean None
            if lat is None or lon is None:
                return {"success": False, "error": "Coordenadas faltantes en la llamada al servicio."}

            response = requests.get(WeatherEngine.BASE_URL, params=params, timeout=10)
            
            if response.status_code != 200:
                # Capturamos el error detallado de la API externa
                try:
                    error_details = response.json().get('reason', response.text)
                except:
                    error_details = response.text

                return {
                    "success": False,
                    "error": f"Open-Meteo API Error {response.status_code}",
                    "details": error_details
                }

            data = response.json()
            return {
                "success": True,
                "data": data
            }
            
        except requests.exceptions.Timeout:
            return {"success": False, "error": "Tiempo de espera agotado con el servicio de clima."}
        except requests.exceptions.RequestException as e:
            return {"success": False, "error": f"Error de red: {str(e)}"}
