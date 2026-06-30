class Clima {
  final double temperatura;
  final double vento;
  final double minima;
  final double maxima;
  final int umidade;

  Clima({
    required this.temperatura,
    required this.vento,
    required this.minima,
    required this.maxima,
    required this.umidade,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      temperatura: (json["current"]["temperature_2m"] as num).toDouble(),
      vento: (json["current"]["wind_speed_10m"] as num).toDouble(),
      umidade: json["current"]["relative_humidity_2m"],
      maxima: (json["daily"]["temperature_2m_max"][0] as num).toDouble(),
      minima: (json["daily"]["temperature_2m_min"][0] as num).toDouble(),
    );
  }
}
