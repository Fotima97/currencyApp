import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'package:currency/pages/home_page.dart';
import 'package:currency/pages/central_bank_page.dart';
import 'package:currency/pages/other_banks_page.dart';
import 'package:currency/pages/news_list_page.dart';
import 'package:currency/pages/currency_news_page.dart';
import 'package:currency/pages/converter_page.dart';
import 'package:currency/pages/currency_list_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Курсы валют',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primaryColor: primaryColor, fontFamily: 'Roboto'),
      home: new MyHomePage(title: 'Курсы валют'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => MyHomePage(title: 'Курсы валют'),
        '/centralbank': (BuildContext context) =>
            CentralBankPage(title: 'Центральный банк РУз'),
        '/banks': (BuildContext context) => BanksPage(title: 'Банки'),
        '/currency_news': (BuildContext context) =>
            CurrencyNews(title: 'Статистика'),
        '/news': (BuildContext context) => NewsListPage(title: 'Новости'),
        '/converter': (BuildContext context) =>
            ConverterPage(title: 'Конвертер валют'),
        '/currency_list': (BuildContext context) =>
            CurrencyList(title: 'Все валюты'),
      },
    );
  }
}
