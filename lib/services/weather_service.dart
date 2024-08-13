import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
  final response = await http.get(
    Uri.parse('$BASE_URL/weather?q=$cityName&appid=$apiKey&units=metric'),
  );

  if (response.statusCode == 200) {
    return Weather.fromJson(json.decode(response.body));
  } else {
    print('Failed to load weather data: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load weather data');
  }
}


  Future<List<Weather>> get3DayForecast(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/forecast?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecastList = data['list'];
      List<Weather> threeDayForecast = [];

      for (int i = 0; i < forecastList.length; i++) {
        DateTime date = DateTime.parse(forecastList[i]['dt_txt']);
        if (date.hour == 12) { // Get the forecast for noon each day
          if (threeDayForecast.length < 3) {
            threeDayForecast.add(Weather.fromJson(forecastList[i]));
          }
        }
      }

      return threeDayForecast;
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;

    return city ?? "";
  }
}
