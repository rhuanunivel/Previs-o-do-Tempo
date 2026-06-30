import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/clima.dart';
import '../services/weather_service.dart';
import 'pesquisar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Clima? clima;

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarClima();
  }

  Future<void> carregarClima() async {
    final local = await DatabaseHelper.instance.buscarLocalizacao();

    if (local == null) {
      setState(() {
        carregando = false;
      });

      return;
    }

    clima = await WeatherService().buscarClima(local.latitude, local.longitude);

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previsão do Tempo"),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pesquisar()),
              );
            },
          ),
        ],
      ),

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "🌡 Temperatura: ${clima!.temperatura} °C",
                    style: const TextStyle(fontSize: 22),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "💨 Vento: ${clima!.vento} km/h",
                    style: const TextStyle(fontSize: 22),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "💧 Umidade: ${clima!.umidade} %",
                    style: const TextStyle(fontSize: 22),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "⬆ Máxima: ${clima!.maxima} °C",
                    style: const TextStyle(fontSize: 22),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "⬇ Mínima: ${clima!.minima} °C",
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
    );
  }
}
