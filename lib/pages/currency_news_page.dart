import 'package:currency/heplers/central_bank.dart';
import 'package:currency/heplers/daily_rates_model.dart';
import 'package:currency/heplers/rate_change_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:currency/heplers/app_constants.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:currency/heplers/future_currency.dart';
import 'package:currency/heplers/connectivity.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CurrencyNews extends StatefulWidget {
  CurrencyNews({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _CurrencyNewsState createState() => new _CurrencyNewsState();
}

class _CurrencyNewsState extends State<CurrencyNews> {
  String _dropDown_value;
  String value;
  String bankValue = centralBank;
  List<DailyRates> bankList;
  bool loaded = false;
  var dataList;
  var buttonColor1 = accentColor;
  var buttonTextColor1 = Colors.white;
  var buttonColor2 = Colors.white;
  var buttonTextColor2 = Colors.black;
  var buttonColor3 = Colors.white;
  var buttonTextColor3 = Colors.black;
  var response;
  List<FutureCurrency> usdCurrencyList = List<FutureCurrency>();
  List<FutureCurrency> euroCurrencyList = List<FutureCurrency>();
  List<FutureCurrency> rubCurrencyList = List<FutureCurrency>();
  List<USD> usdCentralBankList = List<USD>();
  List<EUR> euroCentralBankList = List<EUR>();
  List<RUB> rubCentralBankList = List<RUB>();
  List<DailyRates> parseData(String responseBody) {
    final parsed = json.decode(responseBody);
    final jsonData = (parsed['response']['data']).cast<Map<String, dynamic>>();

    bankList =
        jsonData.map<DailyRates>((json) => DailyRates.fromJson(json)).toList();
    getData();

    setState(() {
      loaded = true;
    });

    return bankList;
  }

  Future<List<DailyRates>> fetchData(http.Client client) async {
    try {
      response = await client.get(rateChangesAPI);
      if (response.statusCode == 200) {
        //  return compute(parseCurrencies, response.body);
        return parseData(response.body);
      } else {
        //show message
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<CentralBank> parceCentralBank(String responseBody) {
    final parsed = json.decode(responseBody);
    final jsonData = (parsed['data']).cast<Map<String, dynamic>>();

    return jsonData
        .map<RateChange>((json) => RateChange.fromJson(json))
        .toList();
  }

  fetchCentralBank(http.Client client) async {
    try {
      response = await client.get(centralBankAPI);

      if (response.statusCode == 200) {
        //  return compute(parseCurrencies, response.body);
        final parsed = json.decode(response.body);
        final jsonUSD = (parsed['data']['usd']).cast<Map<String, dynamic>>();
        usdCentralBankList =
            jsonUSD.map<USD>((json) => USD.fromJson(json)).toList();
        final jsonEUR = (parsed['data']['euro']).cast<Map<String, dynamic>>();
        euroCentralBankList =
            jsonEUR.map<EUR>((json) => EUR.fromJson(json)).toList();
        final jsonRub = (parsed['data']['rub']).cast<Map<String, dynamic>>();
        rubCentralBankList =
            jsonRub.map<RUB>((json) => RUB.fromJson(json)).toList();
      } else {
        //show message
        null;
      }
    } catch (e) {
      null;
    }
  }

  getData() {
    usdCurrencyList = [];
    euroCurrencyList = [];
    rubCurrencyList = [];
    FutureCurrency futureCurrency;
    for (var i = 0; i < bankList.length; i++) {
      var dailyrates = bankList[i];
      if (bankValue == halqBanki) {
        if (dailyrates.title.trim() == halqBanki) {
          futureCurrency = new FutureCurrency(dailyrates.date.substring(5),
              double.parse(dailyrates.dailyRateUsd));
          usdCurrencyList.add(futureCurrency);
          futureCurrency = new FutureCurrency(dailyrates.date.substring(5),
              double.parse(dailyrates.dailyRateEur));
          euroCurrencyList.add(futureCurrency);
          futureCurrency = new FutureCurrency(dailyrates.date.substring(5),
              double.parse(dailyrates.dailyRateRub));
          rubCurrencyList.add(futureCurrency);
        }
      } else if (bankValue == ofb) {
        if (dailyrates.title.trim() == ofb) {
          futureCurrency = new FutureCurrency(dailyrates.date.substring(5),
              double.parse(dailyrates.dailyRateUsd));
          usdCurrencyList.add(futureCurrency);
          futureCurrency = new FutureCurrency(dailyrates.date.substring(5),
              double.parse(dailyrates.dailyRateEur));
          euroCurrencyList.add(futureCurrency);
          futureCurrency = new FutureCurrency(dailyrates.date.substring(5),
              double.parse(dailyrates.dailyRateRub));
          rubCurrencyList.add(futureCurrency);
        }
      }
    }
    if (bankValue == centralBank) {
      for (var i = 0; i < usdCentralBankList.length; i++) {
        var usd = usdCentralBankList[i];
        futureCurrency =
            new FutureCurrency(usd.date.substring(5), double.parse(usd.cost));
        usdCurrencyList.add(futureCurrency);
      }
      for (var i = 0; i < euroCentralBankList.length; i++) {
        var euro = euroCentralBankList[i];
        futureCurrency =
            new FutureCurrency(euro.date.substring(5), double.parse(euro.cost));
        euroCurrencyList.add(futureCurrency);
      }
      for (var i = 0; i < rubCentralBankList.length; i++) {
        var rub = rubCentralBankList[i];
        futureCurrency =
            new FutureCurrency(rub.date.substring(5), double.parse(rub.cost));
        rubCurrencyList.add(futureCurrency);
      }
    }
  }

  List<Series<FutureCurrency, String>> _createSampleData() {
    return [
      new Series<FutureCurrency, String>(
        id: 'USD',
        domainFn: (FutureCurrency cost, _) => cost.date,
        measureFn: (FutureCurrency cost, _) => cost.cost,
        data: usdCurrencyList,
      ),
      new Series<FutureCurrency, String>(
        id: 'EUR',
        domainFn: (FutureCurrency cost, _) => cost.date,
        measureFn: (FutureCurrency cost, _) => cost.cost,
        data: euroCurrencyList,
      ),
      new Series<FutureCurrency, String>(
        id: 'RUB',
        domainFn: (FutureCurrency cost, _) => cost.date,
        measureFn: (FutureCurrency cost, _) => cost.cost,
        data: rubCurrencyList,
      ),
    ];
  }

  Widget buildChart() {
    //  Widget chart;
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: FutureBuilder(
          future: fetchData(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new BarChart(
                _createSampleData(),

                animate: true,
                barGroupingType: BarGroupingType.grouped,
                // Add the series legend behavior to the chart to turn on series legends.
                // By default the legend will display above the chart.
                behaviors: [new SeriesLegend()],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
    //return chart;
  }

  @override
  void initState() {
    super.initState();
    fetchCentralBank(http.Client());
  }

  Future<Null> refreshData() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      checkConnection(context);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            softWrap: true,
                                overflow: TextOverflow.fade,
          ),
        ),
        body: RefreshIndicator(
            onRefresh: refreshData,
            child: ListView(children: <Widget>[
              Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white,
                  ),
                  child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: 300.0,
                      child: buildChart())),
              Divider(),
              SizedBox(
                height: 10.0,
              ),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    color:
                        bankValue == centralBank ? accentColor : Colors.white10,
                    child: ListTile(
                      title: Text(centralBank,
                          textAlign: TextAlign.center,
                           softWrap: true,
                                overflow: TextOverflow.fade,
                          style: TextStyle(
                            
                              fontSize: 18.0,
                              color: bankValue == centralBank
                                  ? Colors.white
                                  : Colors.black)),
                      onTap: () {
                        setState(() {
                          loaded = false;
                          bankValue = centralBank;
                        });
                      },
                    ),
                  ),
                  Container(
                    color:
                        bankValue == halqBanki ? accentColor : Colors.white10,
                    child: ListTile(
                      title: Text(halqBanki,
                          textAlign: TextAlign.center,
                           softWrap: true,
                                overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: bankValue == halqBanki
                                  ? Colors.white
                                  : Colors.black)),
                      onTap: () {
                        setState(() {
                          loaded = false;
                          bankValue = halqBanki;
                        });
                      },
                    ),
                  ),
                  Container(
                    color: bankValue == ofb ? accentColor : Colors.white10,
                    child: ListTile(
                      title: Text(ofb,
                          textAlign: TextAlign.center,
                           softWrap: true,
                                overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: bankValue == ofb
                                  ? Colors.white
                                  : Colors.black)),
                      onTap: () {
                        setState(() {
                          loaded = false;
                          bankValue = ofb;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(child: loaded ? null : CircularProgressIndicator()),
            ])));
  }
}
