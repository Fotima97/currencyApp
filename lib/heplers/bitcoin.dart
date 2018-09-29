class Bitcoin {
  final String name;
  final String symbol;
  final String rank;
  final String price_usd;
  final String percent_change_1h;
  final String percent_change_24h;
  final String percent_change_7d;
  final String last_updated;

  Bitcoin(
      {this.name,
      this.symbol,
      this.rank,
      this.price_usd,
      this.percent_change_1h,
      this.percent_change_24h,
      this.percent_change_7d,
      this.last_updated});

  factory Bitcoin.fromJson(Map<String, dynamic> json) {
    return Bitcoin(
        name: json['name'] ?? '',
        symbol: json['symbol'] ?? '',
        rank: json['rank'] ?? '',
        price_usd: json['price_usd'] ?? '',
        percent_change_1h: json['percent_change_1h'] ?? '',
        percent_change_24h: json['percent_change_24h'] ?? '',
        percent_change_7d: json['percent_change_7d'] ?? '',
        last_updated: json['last_updated'] ?? '');
  }
}
