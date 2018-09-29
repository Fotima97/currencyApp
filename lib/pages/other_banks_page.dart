import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'package:currency/heplers/banks.dart';
import 'package:currency/pages/bank_page.dart';
import 'package:currency/heplers/connectivity.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class BanksPage extends StatefulWidget {
  BanksPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BanksPageState createState() => new _BanksPageState();
}

class _BanksPageState extends State<BanksPage> with TickerProviderStateMixin {
  List<Bank> data = new List<Bank>();
  Animation<double> filterAppearAnimtion;
  AnimationController filterBoxAnimController;
  Animation<double> _translateButton;
  bool filterIsOpen = false;
  bool filtered = false;
  List<DropdownMenuItem<String>> _dropdDownMenuItems;
  List<DropdownMenuItem<String>> _dropdDownMenuItems2;
  String _dropDown_value;
  String _dropDown_value2;

  Widget filterBox() {
    return new Container(
      color: primaryColor,
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(right: 15.0),
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(color: primaryDarkColor),
                  child: Text(
                    'Сортировать по',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: primaryDarkColor,
                    ),
                    child: DropdownButton<String>(
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                      value: _dropDown_value,
                      items: _dropdDownMenuItems,
                      onChanged: (v) {
                        setState(() {
                          _dropDown_value = v;
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(right: 15.0),
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: primaryDarkColor,
                  ),
                  child: Text(
                    'Порядок',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: primaryDarkColor,
                    ),
                    child: DropdownButton<String>(
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                      value: _dropDown_value2,
                      items: _dropdDownMenuItems2,
                      onChanged: (v) {
                        setState(() {
                          _dropDown_value2 = v;
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Material(
            color: accentColor,
            child: MaterialButton(
              splashColor: primaryColor,
              highlightColor: Colors.transparent,
              height: 50.0,
              child: Text(
                'Применить',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () {
                filtered = true;
                filterBoxAnimController.reverse();
                filterIsOpen = !filterIsOpen;
                filterData(_dropDown_value, _dropDown_value2);
              },
            ),
          )
        ],
      ),
    );
  }

  double stringToDouble(String data) {
    double cost;
    if (data == '-') {
      cost = 0.0;
    } else {
      String costV1 = data.replaceAll(new RegExp(r"\s+\b|\b\s"), '');

      cost = double.parse(costV1.substring(0, costV1.length - 3));
    }
    return cost;
  }

  List<Bank> filterData(String sortArgument, String order) {
    setState(() {
      if (order == increase) {
        switch (sortArgument) {
          case 'usdBuy':
            data.sort((a, b) {
              return stringToDouble(a.fieldUsdBuy)
                  .compareTo(stringToDouble(b.fieldUsdBuy));
            });
            break;
          case 'usdSell':
            data.sort((a, b) {
              return stringToDouble(a.fieldUsdSell)
                  .compareTo(stringToDouble(b.fieldUsdSell));
            });
            break;
          case 'euroBuy':
            data.sort((a, b) {
              return stringToDouble(a.fieldEuroBuy)
                  .compareTo(stringToDouble(b.fieldEuroBuy));
            });
            break;
          case 'euroSell':
            data.sort((a, b) {
              return stringToDouble(a.fieldEuroSell)
                  .compareTo(stringToDouble(b.fieldEuroSell));
            });
            break;

          case 'rubBuy':
            data.sort((a, b) {
              return stringToDouble(a.fieldRubBuy)
                  .compareTo(stringToDouble(b.fieldRubBuy));
            });
            break;
          case 'rubSell':
            data.sort((a, b) {
              return stringToDouble(a.fieldRubSell)
                  .compareTo(stringToDouble(b.fieldRubSell));
            });
            break;
        }
      }
      if (order == decrease) {
        switch (sortArgument) {
          case 'usdBuy':
            data.sort((a, b) {
              return stringToDouble(b.fieldUsdBuy)
                  .compareTo(stringToDouble(a.fieldUsdBuy));
            });
            break;
          case 'usdSell':
            data.sort((a, b) {
              return stringToDouble(b.fieldUsdSell)
                  .compareTo(stringToDouble(a.fieldUsdSell));
            });
            break;
          case 'euroBuy':
            data.sort((a, b) {
              return stringToDouble(b.fieldEuroBuy)
                  .compareTo(stringToDouble(a.fieldEuroBuy));
            });
            break;
          case 'euroSell':
            data.sort((a, b) {
              return stringToDouble(b.fieldEuroSell)
                  .compareTo(stringToDouble(a.fieldEuroSell));
            });
            break;

          case 'rubBuy':
            data.sort((a, b) {
              return stringToDouble(b.fieldRubBuy)
                  .compareTo(stringToDouble(a.fieldRubBuy));
            });
            break;
          case 'rubSell':
            data.sort((a, b) {
              return stringToDouble(b.fieldRubSell)
                  .compareTo(stringToDouble(a.fieldRubSell));
            });
            break;
        }
      }
    });

    return data;
  }

  List<DropdownMenuItem<String>> _getDropdDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(
      value: usdBuy,
      child: new Text(
        'USD покупка',
        style: TextStyle(color: Colors.white),
      ),
    ));
    items.add(new DropdownMenuItem(
      value: usdSell,
      child: new Text(
        'USD продажа',
        style: TextStyle(color: Colors.white),
      ),
    ));

    items.add(new DropdownMenuItem(
      value: euroBuy,
      child: new Text(
        'EURO покупка',
        style: TextStyle(color: Colors.white),
      ),
    ));
    items.add(new DropdownMenuItem(
      value: euroSell,
      child: new Text(
        'EURO продажа',
        style: TextStyle(color: Colors.white),
      ),
    ));
    items.add(new DropdownMenuItem(
      value: rubBuy,
      child: new Text(
        'RUB покупка',
        style: TextStyle(color: Colors.white),
      ),
    ));
    items.add(new DropdownMenuItem(
      value: rubSell,
      child: new Text(
        'RUB продажа',
        style: TextStyle(color: Colors.white),
      ),
    ));
    return items;
  }

  List<DropdownMenuItem<String>> _getDropdDownMenuItems2() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(
      value: increase,
      child: new Text(
        'По возрастанию',
        style: TextStyle(color: Colors.white),
      ),
    ));
    items.add(new DropdownMenuItem(
      value: decrease,
      child: new Text(
        'По убыванию',
        style: TextStyle(color: Colors.white),
      ),
    ));

    return items;
  }

  @override
  initState() {
    super.initState();
    _dropdDownMenuItems = _getDropdDownMenuItems();
    _dropdDownMenuItems2 = _getDropdDownMenuItems2();
    _dropDown_value2 = _dropdDownMenuItems2[0].value;
    _dropDown_value = _dropdDownMenuItems[0].value;
    filterBoxAnimController = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this);
    _translateButton = Tween<double>(begin: 5.0, end: -14.0).animate(
        CurvedAnimation(
            parent: filterBoxAnimController,
            curve: Interval(0.00, 1.00, curve: Curves.ease)));
    filterAppearAnimtion = new Tween(begin: 0.0, end: 250.0).animate(
        CurvedAnimation(
            parent: filterBoxAnimController,
            curve: new Interval(0.0, 1.00, curve: Curves.ease)))
      ..addListener(() {
        setState(() {});
      });
  }

  void animate() {
    if (!filterIsOpen) {
      filterBoxAnimController.forward();
    } else {
      filterBoxAnimController.reverse();
    }
    filterIsOpen = !filterIsOpen;
  }

  List<Bank> parseBanks(String responseBody) {
    final parsed = json.decode(responseBody);
    final jsonData = (parsed['response']['data']).cast<Map<String, dynamic>>();
    if (!filtered) {
      data = jsonData.map<Bank>((json) => Bank.fromJson(json)).toList();
    }
    return data;
  }

  Future<List<Bank>> fetchBanks(http.Client client) async {
    try {
      final response =
          await client.get('http://kursvalut.uz/mobile_app_api/banks');

      //  return compute(parseCurrencies, response.body);
      return parseBanks(response.body);
    } catch (e) {
      return null;
    }
  }

  @override
  dispose() {
    super.dispose();
    filterBoxAnimController.dispose();
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(filterAppearAnimtion.value),
            child: Container(
              decoration: BoxDecoration(color: primaryColor),
              height: filterAppearAnimtion.value,
              child: filterBox(),
            ),
          ),
          actions: <Widget>[
            Material(
              shadowColor: Colors.transparent,
              animationDuration: Duration(microseconds: 1),
              color: Colors.transparent,
              child: MaterialButton(
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Transform(
                        transform: Matrix4.translationValues(
                            0.0, _translateButton.value * 2, 0.0),
                        child: Icon(Icons.filter_list, color: Colors.white)),
                    Transform(
                        transform: Matrix4.translationValues(0.0,
                            _translateButton.value == 5 ? 20.0 : -14.0, 0.0),
                        child: Icon(Icons.close, color: Colors.white)),
                  ],
                ),
                splashColor: primaryDarkColor,
                onPressed: () {
                  animate();
                },
              ),
            )
          ],
        ),
        body: FutureBuilder<List<Bank>>(
          future: fetchBanks(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final bank = snapshot.data[index];
                    return Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: ListTile(
                            title: Image.network(
                              bank.fieldImage,
                              width: 80.0,
                              height: 50.0,
                              fit: BoxFit.contain,
                            ),
                            trailing: InkWell(
                              child: Icon(Icons.chevron_right),
                            ),
                            onTap: () {
                              filterBoxAnimController.reverse();
                              filterIsOpen = !filterIsOpen;
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => BankPage(
                                            title: data[index].fieldImage,
                                            dataUpated: data[index].changed,
                                            usdBuy: data[index].fieldUsdBuy,
                                            usdSell: data[index].fieldUsdSell,
                                            euroBuy: data[index].fieldEuroBuy,
                                            euroSell: data[index].fieldEuroSell,
                                            rubBuy: data[index].fieldRubBuy,
                                            rubSell: data[index].fieldRubSell,
                                          )));
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.grey[400],
                        ),
                      ],
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              print('Error');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
