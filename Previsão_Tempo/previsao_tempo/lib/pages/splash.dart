import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../database/database_helper.dart';
import '../services/location_service.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    iniciarApp();
  }

  Future<void> iniciarApp() async {
    try {
      Position position = await LocationService().obterLocalizacao();

      await DatabaseHelper.instance.salvarLocalizacao(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
