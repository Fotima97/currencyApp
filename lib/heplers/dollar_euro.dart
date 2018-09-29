class DollarEuro {
  final String eur;
  final String usd;

  DollarEuro({this.eur, this.usd});

  factory DollarEuro.fromJson(Map<String, dynamic> json) {
    return DollarEuro(usd: json['usd'] ?? '', eur: json['eur'] ?? '');
  }
}
