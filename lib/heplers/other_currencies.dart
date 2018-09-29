class Currency {
  final String curCode;
  final String nominal;
  final String rate;
  final String diff;
  final String date;
  final String curName;

  Currency(
      {this.curCode,
      this.nominal,
      this.rate,
      this.diff,
      this.date,
      this.curName});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
        curCode: json['Ccy'] ?? ' ',
        nominal: json['Nominal'] ?? ' ',
        rate: json['Rate'] ?? ' ',
        diff: json['Diff'] ?? ' ',
        date: json['Date'] ?? ' ',
        curName: json['CcyNm_RU'] ?? ' ');
  }

  Map<String, dynamic> toJson() => {
        'Ccy': curCode,
        'Nominal': nominal,
        'Rate': rate,
        'Diff': diff,
        'Date': date,
        'CcyNm_RU': curName,
      };
}
