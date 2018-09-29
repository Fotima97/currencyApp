import 'package:currency/heplers/other_currencies.dart';
import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'package:currency/heplers/dialogbox.dart';
import 'package:currency/pages/converter_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:currency/heplers/reverse_convert.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CurrencyList extends StatefulWidget {
  CurrencyList({Key key, this.title}) : super(key: key);
  final title;

  @override
  _CurrencyListState createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  var data;
  @override
  void initState() {
    super.initState();
    print(curList.length);
  }

  List<Currency> parseCurrencies(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    data = parsed.map<Currency>((json) => Currency.fromJson(json)).toList();

    return data;
  }

  Future<List<Currency>> fetchCurrencies(http.Client client) async {
    try {
      final response = await client.get(ratesAPI);

      //  return compute(parseCurrencies, response.body);
      return parseCurrencies(response.body);
    } catch (e) {
      return null;
    }
  }

  bool iterateList(Currency currency) {
    bool alreadySaved = false; // curList.contains(currency);
    for (int i = 0; i < curList.length; i++) {
      if (curList[i].curCode == currency.curCode) {
        alreadySaved = true;
      }
    }
    return alreadySaved;
  }

  Widget _buildRow(Currency currency) {
    bool alreadySaved = false;
    for (int i = 0; i < curList.length; i++) {
      if (curList[i].curCode == currency.curCode) {
        alreadySaved = true;
      }
    }

    return ListTile(
      title: Text(
        currency.curCode,
        softWrap: true,
        overflow: TextOverflow.fade,
        style: TextStyle(fontSize: 18.0),
      ),
      subtitle: Text(
        currency.curName,
        softWrap: true,
        overflow: TextOverflow.fade,
        style: TextStyle(fontSize: 16.0),
      ),
      trailing: alreadySaved
          ? Icon(
              Icons.done,
              color: accentColor,
            )
          : null,
      onTap: () {
        setState(() {
          if (reverseConvert && curList.length == 1 && !alreadySaved) {
            showDilogBox2(context);
          } else {
            if (alreadySaved) {
              for (int i = 0; i < curList.length; i++) {
                if (curList[i].curCode == currency.curCode) {
                  curList.removeAt(i);
                }
              }
            } else {
              curList.add(currency);
            }
          }
          revConvertCur = curList.length > 0 ? curList[0] : null;
          saveCurrencyList();
        });
      },
    );
    // Add this line.
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
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder<List<Currency>>(
              future: fetchCurrencies(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var currency = snapshot.data[index];
                      return Column(
                        children: <Widget>[
                          _buildRow(currency),
                          Divider(),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )));
  }
}
