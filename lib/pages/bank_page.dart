import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'package:currency/heplers/my_clipper.dart';
import 'package:currency/heplers/connectivity.dart';
//import 'package:charts_flutter/flutter.dart';
import 'dart:async';

class BankPage extends StatefulWidget {
  BankPage({
    Key key,
    this.title,
    this.dataUpated,
    this.usdBuy,
    this.usdSell,
    this.euroBuy,
    this.euroSell,
    this.rubBuy,
    this.rubSell,
  }) : super(key: key);

  final String title;
  final String dataUpated;
  final String usdBuy;
  final String usdSell;
  final String euroBuy;
  final String euroSell;
  final String rubBuy;
  final String rubSell;

  @override
  _BankPageState createState() => new _BankPageState();
}

class _BankPageState extends State<BankPage> {
  Future<Null> refreshData() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      checkConnection(context);
    });
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Банки',
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: refreshData,
        child: Container(
          color: Color(0x0A3d4000), // Color(0xFFe0eaf1),
          child: ListView(
            children: <Widget>[
              Container(
                child: ClipPath(
                  child: Container(
                    height: 250.0,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  widget.dataUpated,
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                                child: Image.network(
                              widget.title,
                              fit: BoxFit.cover,
                            )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                  ),
                  clipper: MyClipper(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 40.0, 20.0, 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: Text(
                                'USD',
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22.0),
                              ))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text('Покупка',
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Продажа',
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  widget.usdBuy == null
                                      ? '-'
                                      : widget.usdBuy + ' UZS',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  widget.usdSell == null
                                      ? '-'
                                      : widget.usdSell + ' UZS',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: Text(
                                'EUR',
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22.0),
                              ))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text('Покупка',
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Продажа',
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  widget.euroBuy == null
                                      ? '-'
                                      : widget.euroBuy + ' UZS',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  widget.euroSell == null
                                      ? '-'
                                      : widget.euroSell + ' UZS',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: Text(
                                'RUB',
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22.0),
                              ))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text('Покупка',
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Продажа',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  widget.rubBuy == null
                                      ? '-'
                                      : widget.rubBuy + ' UZS',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  widget.rubSell == null
                                      ? '-'
                                      : widget.rubSell + ' UZS',
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
