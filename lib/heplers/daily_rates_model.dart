class DailyRates {
  final String date;
  final String dailyRateUsd;
  final String dailyRateEur;
  final String dailyRateRub;
  final String title;

  DailyRates(
      {this.date,
      this.dailyRateEur,
      this.dailyRateRub,
      this.dailyRateUsd,
      this.title});
  factory DailyRates.fromJson(Map<String, dynamic> json) {
    return DailyRates(
        date: json['date'],
        dailyRateUsd: json['daily_rate_usd'],
        dailyRateEur: json['daily_rate_eur'],
        dailyRateRub: json['daily_rate_rub'],
        title: json['title']);
  }
}
