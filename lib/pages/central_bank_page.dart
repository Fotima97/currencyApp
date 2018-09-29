import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'dart:async';
import 'package:currency/heplers/connectivity.dart';
import 'package:currency/heplers/other_currencies.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CentralBankPage extends StatefulWidget {
  CentralBankPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CentralBankPageState createState() => new _CentralBankPageState();
}

class _CentralBankPageState extends State<CentralBankPage> {
  @override
  void initState() {
    super.initState();

    // fetchAllData();
  }

  List<Currency> parseCurrencies(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Currency>((json) => Currency.fromJson(json)).toList();
  }

  Future<List<Currency>> fetchCurrencies(http.Client client) async {
    try {
      final response =
          await client.get('http://cbu.uz/ru/arkhiv-kursov-valyut/json/');

      //  return compute(parseCurrencies, response.body);
      return parseCurrencies(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // fetchAllData();
      //checkConnection(context);
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: refreshList,
        child: FutureBuilder<List<Currency>>(
          future: fetchCurrencies(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var currency = snapshot.data[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 25.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text(
                                currency.curCode,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Positioned(
                                    child: Text(
                                      currency.nominal +
                                          ' = ' +
                                          double.parse(currency.rate)
                                              .toStringAsFixed(2),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                  Positioned(
                                    top: 33.0,
                                    child: Text(currency.curName,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 15.0)),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Row(
                                  children: <Widget>[
                                    Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          child: Icon(
                                            double.parse(currency.diff) > 0
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward,
                                            color:
                                                double.parse(currency.diff) > 0
                                                    ? Colors.green
                                                    : Colors.red,
                                            size: 17.0,
                                          ),
                                        ),
                                        Positioned(
                                          left: 25.0,
                                          top: 2.0,
                                          child: Text(
                                            currency.diff,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: double.parse(
                                                            currency.diff) >
                                                        0
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                        ),
                                        Positioned(
                                          top: 35.0,
                                          left: 30.0,
                                          child: Row(
                                            children: <Widget>[
                                              // Icon(
                                              //   Icons.calendar_today,
                                              //   size: 18.0,
                                              //   color: Colors.grey,
                                              // ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                currency.date,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13.0),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Divider(
                        color: primaryColor,
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              print('{$snapshot.error}');
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              )
                  // child: CircularProgressIndicator(),
                  );
            }
          },
        ),
      ),
    );
  }
}
