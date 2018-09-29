import 'package:currency/heplers/other_currencies.dart';
import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:currency/heplers/dialogbox.dart';
import 'package:currency/heplers/converter.dart';
import 'package:currency/heplers/reverse_convert.dart';

List<Currency> curList;
bool reverseConvert = false;

class ConverterPage extends StatefulWidget {
  ConverterPage({Key key, this.title}) : super(key: key);
  final title;
  @override
  _ConvertPageState createState() => new _ConvertPageState();
}

class _ConvertPageState extends State<ConverterPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCurrencyList();
    editingController.text = '1000.0';
  }

  Widget buildBody() {
    if (reverseConvert && curList.length == 1) {
      return ReverseConverter();
    } else {
      return ConverterWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (curList.length == 1) {
            setState(() {
              buildBody();
              reverseConvert = !reverseConvert;
            });
          } else {
            if (!reverseConvert) {
              showDialogBox(context);
            } else {
              Navigator.pushNamed(context, '/currency_list');
              reverseConvert = !reverseConvert;
            }
          }
        },
        backgroundColor: reverseConvert ? backgroundColor : accentColor,
        child: Icon(Icons.import_export),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Navigator.pushNamed(context, '/currency_list');
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: buildBody(),
      //  (reverseConvert && curList.length == 1)
      //     ? ReverseConverter()
      //     : ConverterWidget();
    );
  }
}

getJsonList() async {
  curList = [];
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getString(currencyList) != null) {
    json
        .decode(preferences.getString(currencyList))
        .forEach((map) => curList.add(new Currency.fromJson(map)));
  }

  //print(curList.length);
}

saveCurrencyList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString(currencyList, json.encode(curList));
}
