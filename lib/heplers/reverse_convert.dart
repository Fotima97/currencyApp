import 'package:currency/heplers/other_currencies.dart';
import 'package:currency/pages/converter_page.dart';
import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';

Currency revConvertCur = curList[0];
double revConvertCost;

class ReverseConverter extends StatefulWidget {
  @override
  _ReverseConverterState createState() => _ReverseConverterState();
}

class _ReverseConverterState extends State<ReverseConverter> {
  double convertedUZS;
  bool showErrorMessage = false;
  double initValue = 0.0;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = initValue.toString();
  }

  double getCurrencyCost(String curCode) {
    double rate;
    // for (int i = 0; i < centralBank.length; i++) {
    //   if (centralBank[i].curCode == curCode) {
    //     rate = centralBank[i].curCost;
    //   }
    // }
    return rate;
  }

  double stringToDouble(String data) {
    double cost;
    if (data == '-') {
      cost = 0.0;
    } else if (data == null) {
      cost == 0.0;
    } else {
      String costV1 = data.replaceAll(new RegExp(r"\s+\b|\b\s"), '');
      cost = double.parse(costV1.substring(0, costV1.length - 3));
    }
    return cost;
  }

  validateInput(String data) {
    setState(() {
      if (double.tryParse(data.trim()) == null) {
        showErrorMessage = true;
      } else {
        showErrorMessage = false;
      }
    });
  }

  convertToUZS(String data) {
    if (!showErrorMessage) {
      double data1 = double.parse(data.trim());
      setState(() {
        convertedUZS = data1 * stringToDouble(revConvertCur.rate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: <Widget>[
      Expanded(
        flex: 3,
        child: Container(
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          revConvertCur.curName,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 200.0,
                              child: TextField(
                                onSubmitted: validateInput(controller.text),
                                controller: controller,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: TextStyle(
                                    fontSize: 22.0, color: Colors.white),
                                decoration: InputDecoration(
                                    errorText: showErrorMessage
                                        ? 'Неправильно введен номер'
                                        : null,
                                    hintText: '0.0',
                                    fillColor: Colors.white,
                                    border: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintStyle: TextStyle(
                                        fontSize: 22.0, color: Colors.white)),
                              ),
                            ),
                            Text(revConvertCur.curCode,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.grey[400]))
                          ]),
                    )
                  ],
                )
              ],
            )),
      ),
      Expanded(
        flex: 3,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Узбекский сум',
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        convertedUZS == null
                            ? '0.0'
                            : convertedUZS.toStringAsFixed(2),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Text(' UZS',
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.grey[600]))
                    ]),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color: accentColor,
            child: MaterialButton(
              minWidth: 200.0,
              height: 40.0,
              child: Text('Конвертировать',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              onPressed: () {
                convertToUZS(controller.text);
              },
            ),
          ),
        ),
      )
    ]);
  }
}
