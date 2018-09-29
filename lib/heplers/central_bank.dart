class USD {
  final String date;
  final String cost;

  USD({this.date, this.cost});

  factory USD.fromJson(Map<String, dynamic> json) {
    return USD(date: json['value'] ?? '', cost: json['usd'] ?? '');
  }
}

class EUR {
  final String date;
  final String cost;

  EUR({this.date, this.cost});

  factory EUR.fromJson(Map<String, dynamic> json) {
    return EUR(date: json['value'] ?? '', cost: json['euro'] ?? '');
  }
}

class RUB {
  final String date;
  final String cost;

  RUB({this.date, this.cost});

  factory RUB.fromJson(Map<String, dynamic> json) {
    return RUB(date: json['value'] ?? '', cost: json['rub'] ?? '');
  }
}

class CentralBank {
  final List usd;
  final List euro;
  final List rub;

  CentralBank({this.usd, this.euro, this.rub});

  factory CentralBank.fromJson(Map<String, dynamic> json) {
    return CentralBank(usd: json['usd'], euro: json['euro'], rub: json['rub']);
  }
}
