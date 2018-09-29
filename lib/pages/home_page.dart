import 'package:currency/heplers/dollar_euro.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:currency/pages/converter_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:currency/heplers/bitcoin.dart';
import 'package:currency/heplers/other_currencies.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dateFormat = new DateFormat('dd.MM.yyyy');
  Future<Null> refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // checkConnection(context);
    });
    return null;
  }

// A function that will convert a response body into a List<Photo>
  List<Bitcoin> parseBitcoin(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Bitcoin>((json) => Bitcoin.fromJson(json)).toList();
  }

  Future<List<Bitcoin>> fetchBitcoin(http.Client client) async {
    final response =
        await client.get('https://api.coinmarketcap.com/v1/ticker/bitcoin/');

    return parseBitcoin(response.body);
    // return compute(parseBitcoin, response.body);
  }

  List<Currency> parseCurrencies(String responseBody) {
    final parsed = json.decode(responseBody);
    try {
      return parsed.map<Currency>((json) => Currency.fromJson(json)).toList();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Currency>> fetchCurrencies(http.Client client) async {
    try {
      final response = await client.get(ratesAPI);
      String body = utf8.decode(response.bodyBytes);
      var text = response.bodyBytes;

      return parseCurrencies(body);
      // return compute(parseCurrencies, response.body);
    } catch (e) {
      print(e);
      Flushbar()
        ..title = "Проблемы с сервером"
        ..message = "Проверьте подключение к сети"
        ..duration = Duration(seconds: 2)
        ..icon = Icon(
          Icons.info,
          color: Colors.white,
        )
        ..backgroundColor = accentColor
        ..show(context);
      // Fluttertoast.showToast(
      //     msg: " Проблемы с сервером. \n Проверьте подключение к сети ",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIos: 1,
      //     bgcolor: "#F9A333",
      //     textcolor: '#ffffff');
      return null;
    }
  }

  Future<DollarEuro> fetchDollar(http.Client client) async {
    try {
      final response = await client.get(euroDollarAPI);

      return DollarEuro.fromJson(json.decode(response.body));
      // return compute(parseCurrencies, response.body);
    } catch (e) {
      return null;
    }
  }

  @override
  initState() {
    super.initState();
    // checkConnection(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title,
        ),
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [backgroundColor, primaryDarkColor],
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      tileMode: TileMode.clamp)),
              child: Center(
                child: Text('Курсы валют',
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(color: Colors.white, fontSize: 25.0)),
              ),
            ),
            ListTileTheme(
              child: new ListTile(
                title: Text('Центральный банк РУз',
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: drawerSize)),
                leading: Image.asset(
                  'assets/images/central_bank.png',
                  width: 30.0,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/centralbank');
                },
              ),
              iconColor: accentColor,
            ),
            Divider(),
            ListTileTheme(
              child: new ListTile(
                title: Text('Банки',
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: drawerSize)),
                leading: new Icon(Icons.account_balance),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/banks');
                },
              ),
              iconColor: primaryColor,
            ),
            Divider(),
            ListTileTheme(
              child: new ListTile(
                title: Text('Статистика',
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: drawerSize)),
                leading: new Icon(Icons.monetization_on),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/currency_news');
                },
              ),
              iconColor: primaryColor,
            ),
            Divider(),
            ListTileTheme(
              child: new ListTile(
                title: Text('Новости',
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: drawerSize)),
                leading: new Icon(Icons.today),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/news');
                },
              ),
              iconColor: primaryColor,
            ),
            Divider(),
            ListTileTheme(
              child: new ListTile(
                title: Text('Конвертер валют по ЦБ',
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: drawerSize)),
                leading: new Icon(Icons.cached),
                onTap: () {
                  getJsonList();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/converter');
                },
              ),
              iconColor: primaryColor,
            ),
          ]),
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: refreshData,
        child: Container(
          padding: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [primaryColor, backgroundColor],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  tileMode: TileMode.clamp)),
          child: ListView(
            padding: EdgeInsets.only(top: 20.0),
            children: <Widget>[
              FutureBuilder<DollarEuro>(
                future: fetchDollar(http.Client()),
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  if (snapshot.hasData) {
                    return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                            color: backgroundColor),
                        margin: EdgeInsets.all(20.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 40.0, 10.0, 40.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/kursEx.png',
                                    height: 60.0,
                                    alignment: Alignment.centerLeft,
                                  )),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      '1 EUR = ' + data.eur + ' USD',
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      '1 USD = ' + data.usd + ' EUR',
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  } else {
                    return Container();
                  }
                },
              ),
              FutureBuilder<List<Bitcoin>>(
                  future: fetchBitcoin(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              color: backgroundColor),
                          margin: EdgeInsets.all(20.0),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 40.0, 10.0, 40.0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: Image.asset(
                                          'assets/images/bitcoin.png',
                                          height: 50.0,
                                          alignment: Alignment.centerLeft,
                                        )),
                                    Expanded(
                                      flex: 10,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 7,
                                              child: Stack(
                                                overflow: Overflow.visible,
                                                children: <Widget>[
                                                  Positioned(
                                                      child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          snapshot.data[0].rank
                                                                  .toString() +
                                                              " ",
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.0)),
                                                      Text(
                                                          " " +
                                                              snapshot.data[0]
                                                                  .symbol +
                                                              ' = ',
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20.0)),
                                                      Text(
                                                          " " +
                                                              double.parse(snapshot
                                                                      .data[0]
                                                                      .price_usd)
                                                                  .toStringAsFixed(
                                                                      2) +
                                                              '\$',
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.0)),
                                                    ],
                                                  )),
                                                  Positioned(
                                                    top: 45.0,
                                                    left: 0.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        ),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                            dateFormat
                                                                .format(DateTime.fromMillisecondsSinceEpoch(
                                                                    int.parse(snapshot
                                                                            .data[
                                                                                0]
                                                                            .last_updated) *
                                                                        1000,
                                                                    isUtc:
                                                                        true))
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: <Widget>[
                                                double.parse(snapshot.data[0]
                                                            .percent_change_24h) >
                                                        0
                                                    ? Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors.green,
                                                        size: 12.0,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_downward,
                                                        color: Colors.red,
                                                        size: 12.0,
                                                      ),
                                                Text(
                                                    snapshot.data[0]
                                                        .percent_change_24h,
                                                    textAlign: TextAlign.right,
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: double.parse(snapshot
                                                                    .data[0]
                                                                    .percent_change_24h) >
                                                                0
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontSize: 12.0)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ])));
                    } else {
                      return Container();
                    }
                  }),
              FutureBuilder<List<Currency>>(
                future: fetchCurrencies(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                                color: backgroundColor),
                            margin: EdgeInsets.all(20.0),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 40.0, 10.0, 40.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: Image.asset(
                                          'assets/images/usa.png',
                                          height: 50.0,
                                          alignment: Alignment.centerLeft,
                                        )),
                                    Expanded(
                                        flex: 7,
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Positioned(
                                                child: Row(
                                              children: <Widget>[
                                                Text(
                                                    snapshot.data[0].nominal
                                                            .toString() +
                                                        " ",
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                                Text(
                                                    " " +
                                                        snapshot
                                                            .data[0].curCode +
                                                        ' = ',
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                                Text(
                                                    " " +
                                                        double.parse(snapshot
                                                                .data[0].rate)
                                                            .toStringAsFixed(2),
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                              ],
                                            )),
                                            Positioned(
                                              top: 45.0,
                                              left: 0.0,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.white,
                                                    size: 14.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(snapshot.data[0].date,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: <Widget>[
                                          double.parse(snapshot.data[0].diff) >
                                                  0
                                              ? Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.green,
                                                  size: 12.0,
                                                )
                                              : Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.red,
                                                  size: 12.0,
                                                ),
                                          Text(snapshot.data[0].diff,
                                              textAlign: TextAlign.right,
                                              softWrap: true,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  color: double.parse(snapshot
                                                              .data[0].diff) >
                                                          0
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 12.0)),
                                        ],
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                                color: backgroundColor),
                            margin: EdgeInsets.all(20.0),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 40.0, 10.0, 40.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: Image.asset(
                                          'assets/images/euro.png',
                                          height: 50.0,
                                          alignment: Alignment.centerLeft,
                                        )),
                                    Expanded(
                                        flex: 7,
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Positioned(
                                                child: Row(
                                              children: <Widget>[
                                                Text(
                                                    snapshot.data[1].nominal
                                                            .toString() +
                                                        " ",
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                                Text(
                                                    " " +
                                                        snapshot
                                                            .data[1].curCode +
                                                        ' = ',
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                                Text(
                                                    " " +
                                                        double.parse(snapshot
                                                                .data[1].rate)
                                                            .toStringAsFixed(2),
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                              ],
                                            )),
                                            Positioned(
                                              top: 45.0,
                                              left: 0.0,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.white,
                                                    size: 14.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(snapshot.data[1].date,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: <Widget>[
                                          double.parse(snapshot.data[1].diff) >
                                                  0
                                              ? Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.green,
                                                  size: 12.0,
                                                )
                                              : Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.red,
                                                  size: 12.0,
                                                ),
                                          Text(snapshot.data[1].diff,
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: double.parse(snapshot
                                                              .data[1].diff) >
                                                          0
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 15.0)),
                                        ],
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                                color: backgroundColor),
                            margin: EdgeInsets.all(20.0),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 40.0, 10.0, 40.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: Image.asset(
                                          'assets/images/rub.png',
                                          height: 50.0,
                                          alignment: Alignment.centerLeft,
                                        )),
                                    Expanded(
                                        flex: 7,
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Positioned(
                                                child: Row(
                                              children: <Widget>[
                                                Text(
                                                    snapshot.data[2].nominal
                                                            .toString() +
                                                        " ",
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                                Text(
                                                    " " +
                                                        snapshot
                                                            .data[2].curCode +
                                                        ' = ',
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                                Text(
                                                    " " +
                                                        double.parse(snapshot
                                                                .data[2].rate)
                                                            .toStringAsFixed(2),
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0)),
                                              ],
                                            )),
                                            Positioned(
                                              top: 45.0,
                                              left: 0.0,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.white,
                                                    size: 12.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(snapshot.data[2].date,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: <Widget>[
                                          double.parse(snapshot.data[2].diff) >
                                                  0
                                              ? Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.green,
                                                  size: 12.0,
                                                )
                                              : Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.red,
                                                  size: 12.0,
                                                ),
                                          Text(snapshot.data[2].diff,
                                              textAlign: TextAlign.right,
                                              softWrap: true,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  color: double.parse(snapshot
                                                              .data[2].diff) >
                                                          0
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 15.0)),
                                        ],
                                      ),
                                    )
                                  ],
                                ))),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    print('{$snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
