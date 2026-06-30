import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> obterLocalizacao() async {
    bool servicoAtivado;
    LocationPermission permissao;

    // Verifica se o GPS está ligado
    servicoAtivado = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivado) {
      throw Exception("O GPS está desligado.");
    }

    // Verifica a permissão
    permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        throw Exception("Permissão negada.");
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        "Permissão negada permanentemente. Vá nas configurações do aparelho.",
      );
    }

    // Retorna a localização atual
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
