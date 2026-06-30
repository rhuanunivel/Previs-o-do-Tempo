import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/clima.dart';

class WeatherService {
  Future<Clima> buscarClima(double latitude, double longitude) async {
    final url =
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$latitude"
        "&longitude=$longitude"
        "&current=temperature_2m,wind_speed_10m,relative_humidity_2m"
        "&daily=temperature_2m_max,temperature_2m_min"
        "&timezone=auto";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      return Clima.fromJson(dados);
    } else {
      throw Exception("Erro ao consultar o clima.");
    }
  }
}
