from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .services import WeatherEngine
from .serializers import WeatherResponseSerializer
import logging

class WeatherForecastView(APIView):
    """
    Enhanced view for retrieving the weather forecast.
    Includes advanced debugging and robust coordinate parsing.
    """
    
    def get(self, request):
        # 1. Debugging: Imprimimos los parámetros recibidos
        print(f"DEBUG - Parámetros recibidos: {request.GET}")
        
        lat_raw = request.query_params.get('lat')
        lon_raw = request.query_params.get('lon')
        
        # 2. Validación de presencia
        if lat_raw is None or lon_raw is None:
            return Response(
                {"error": "Faltan parámetros", "details": "lat y lon son obligatorios."},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # 3. Parsing robusto de coordenadas (manejamos comas y puntos)
        try:
            # Reemplazamos coma por punto por si el sistema operativo del celular usa formato regional
            lat = float(str(lat_raw).replace(',', '.'))
            lon = float(str(lon_raw).replace(',', '.'))
        except (ValueError, TypeError):
            return Response(
                {"error": "Formato inválido", "details": f"No se pudo convertir '{lat_raw}' o '{lon_raw}' a número."},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # 4. Validación de rango geográfico
        if not (-90 <= lat <= 90) or not (-180 <= lon <= 180):
            return Response(
                {"error": "Fuera de rango", "details": "La latitud debe estar en [-90, 90] y longitud en [-180, 180]."},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # 5. Llamada al servicio
        result = WeatherEngine.get_forecast(lat, lon)
        
        if not result.get("success"):
            return Response(
                {
                    "error": "Error en servicio externo", 
                    "details": result.get("error"),
                    "extra": result.get("details")
                },
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
        # 6. Serialización y respuesta
        try:
            serializer = WeatherResponseSerializer(result.get("data"))
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"error": "Error de procesamiento", "details": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
