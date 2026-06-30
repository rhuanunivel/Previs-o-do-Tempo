import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/clima.dart';
import '../services/weather_service.dart';

class Pesquisar extends StatefulWidget {
  const Pesquisar({super.key});

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();

  Clima? clima;

  bool carregando = false;

  Future<void> pesquisar() async {
    setState(() {
      carregando = true;
      clima = null;
    });

    final url =
        "https://geocoding-api.open-meteo.com/v1/search"
        "?name=${cidadeController.text}"
        "&count=10"
        "&language=pt"
        "&format=json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      final resultados = dados["results"];

      if (resultados == null || resultados.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Cidade não encontrada.")));

        setState(() {
          carregando = false;
        });

        return;
      }

      for (var cidade in resultados) {
        if (cidade["admin1"].toString().toLowerCase() ==
            estadoController.text.toLowerCase()) {
          clima = await WeatherService().buscarClima(
            cidade["latitude"],
            cidade["longitude"],
          );

          break;
        }
      }

      if (clima == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cidade ou estado não encontrados.")),
        );
      }
    }

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesquisar Cidade")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: cidadeController,
              decoration: const InputDecoration(labelText: "Cidade"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: estadoController,
              decoration: const InputDecoration(labelText: "Estado"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pesquisar,
              child: const Text("Pesquisar"),
            ),

            const SizedBox(height: 30),

            if (carregando) const CircularProgressIndicator(),

            if (clima != null)
              Column(
                children: [
                  Text(
                    "Temperatura: ${clima!.temperatura}°C",
                    style: const TextStyle(fontSize: 22),
                  ),

                  Text(
                    "Vento: ${clima!.vento} km/h",
                    style: const TextStyle(fontSize: 22),
                  ),

                  Text(
                    "Umidade: ${clima!.umidade}%",
                    style: const TextStyle(fontSize: 22),
                  ),

                  Text(
                    "Máxima: ${clima!.maxima}°C",
                    style: const TextStyle(fontSize: 22),
                  ),

                  Text(
                    "Mínima: ${clima!.minima}°C",
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
