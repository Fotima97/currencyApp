class Bank {
  final String fieldImage;
  final String fieldUsdBuy;
  final String fieldUsdSell;

  final String fieldEuroSell;
  final String fieldEuroBuy;

  final String fieldRubBuy;
  final String fieldRubSell;
  final String changed;

  Bank(
      {this.fieldImage,
      this.fieldUsdBuy,
      this.fieldUsdSell,
      this.fieldEuroBuy,
      this.fieldEuroSell,
      this.fieldRubBuy,
      this.fieldRubSell,
      this.changed});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
        fieldImage: json['field_image'] ?? '',
        fieldUsdBuy: json['field_usd_buy'] ?? '',
        fieldUsdSell: json['field_usd_sell'] ?? '',
        fieldEuroBuy: json['field_euro_buy'] ?? '',
        fieldEuroSell: json['field_euro_sell'] ?? '',
        fieldRubBuy: json['field_rub_buy'] ?? '',
        fieldRubSell: json['field_rub_sell'] ?? '',
        changed: json['changed'] ?? '');
  }
}
