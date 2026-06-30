class Localizacao {
  final double latitude;
  final double longitude;

  Localizacao({required this.latitude, required this.longitude});

  factory Localizacao.fromMap(Map<String, dynamic> map) {
    return Localizacao(
      latitude: (map["latitude"] as num).toDouble(),
      longitude: (map["longitude"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {"latitude": latitude, "longitude": longitude};
  }
}
