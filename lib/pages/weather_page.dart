import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('5d8068ea6910f7fd3545f1952e7df398');
  Weather? _weather;
  List<Weather> _forecast = [];

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      final forecast = await _weatherService.get3DayForecast(cityName);
      setState(() {
        _weather = weather;
        _forecast = forecast;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy_weather.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain_weather.json';
      case 'thunderstorm':
        return 'assets/thunder_weather.json';
      case 'clear':
        return 'assets/sunny_weather.json';
      default:
        return 'assets/sunny_weather.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildBackground(),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlassmorphicContainer(
                          width: 300,
                          height: 400,
                          borderRadius: 20,
                          blur: 15,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderGradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          child: _buildWeatherContent(),
                        ),
                        const SizedBox(height: 20),
                        _buildForecast(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Created by Aditya Kumar",
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade300,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _weather?.cityName ?? 'Loading...',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Lottie.asset(
          getWeatherAnimation(_weather?.mainCondition ?? ""),
          height: 150,
        ),
        const SizedBox(height: 20),
        Text(
          '${_weather?.temperature.round()}°C',
          style: GoogleFonts.roboto(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _weather?.mainCondition ?? "",
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildForecast() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _forecast.map((weather) {
          return Column(
            children: [
              Text(
                '${weather.date.day}/${weather.date.month}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Lottie.asset(
                getWeatherAnimation(weather.mainCondition),
                height: 50,
              ),
              Text(
                '${weather.temperature.round()}°C',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
