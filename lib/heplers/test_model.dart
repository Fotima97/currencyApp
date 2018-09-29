class TestModel {
  final String date;
  final String dailyRateUsd;
  final String dailyRateEur;
  final String dailyRateRub;

  TestModel(
      {this.dailyRateEur, this.dailyRateRub, this.dailyRateUsd, this.date});
  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
        date: json['date']['#markup'] ?? '',
        dailyRateUsd: json['daily_rate_usd']['#markup'] ?? '',
        dailyRateEur: json['daily_rate_eur']['#markup'] ?? '',
        dailyRateRub: json['daily_rate_rub']['#markup'] ?? '');
  }
}
