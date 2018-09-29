class RateChange {
  final List dataList;
  final String title;

  RateChange({this.title, this.dataList});
  factory RateChange.fromJson(Map<String, dynamic> json) {
    return RateChange(
        title: json['title'] ?? '', dataList: json['daily_rates'] ?? '');
  }
}
