class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final DateTime date;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? "",
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      date: DateTime.parse(json['dt_txt'] ?? DateTime.now().toString()),
    );
  }
}
