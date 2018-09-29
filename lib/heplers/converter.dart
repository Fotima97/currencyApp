import 'package:currency/heplers/other_currencies.dart';
import 'package:flutter/material.dart';
import 'package:currency/pages/converter_page.dart';

TextEditingController editingController = TextEditingController();

class ConverterWidget extends StatefulWidget {
  @override
  _ConverterWidgetState createState() => _ConverterWidgetState();
}

class _ConverterWidgetState extends State<ConverterWidget> {
  bool showErrorMessage = false;

  double cost = 0.0;

  validateInput(String data) {
    if (double.tryParse(data.trim()) == null) {
      showErrorMessage = true;
    } else {
      showErrorMessage = false;
    }
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

  double convertUZS(Currency currency) {
    if (editingController.text != null && !showErrorMessage) {
      cost = double.parse(editingController.text.trim()) /
          stringToDouble(currency.rate);
    } else {
      cost = 0.0;
    }

    return cost;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(
                  'UZS',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 18.0),
                ),
                subtitle: Text(
                  'Узбекский сум',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: TextField(
                  onSubmitted: (result) {
                    setState(() {
                      validateInput(result);
                    });
                  },
                  controller: editingController,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    errorText:
                        showErrorMessage ? 'Неправильно введен номер' : null,
                    hintStyle: TextStyle(fontSize: 18.0),
                    hintText: '100.0',
                    //border: InputBorder.none
                  ),
                )),
          ],
        ),
        Divider(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: curList.length,
          itemBuilder: (context, index) {
            Currency cur = curList[index];
            cost = convertUZS(cur);
            // cost = editingController.text != null
            //     ? double.parse(editingController.text) / getCurrencyCost(cur)
            //     : null;

            //  cost = 3.0;
            return Dismissible(
              key: Key(cur.curCode),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                curList.removeAt(index);
                saveCurrencyList();
              },
              background: new Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Удалить',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                color: Colors.red,
              ),
              child: ListTile(
                enabled: false,
                onTap: () {},
                title: Text(
                  cur.curCode,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                subtitle: Text(
                  cur.curName,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                trailing: Text(cost.toStringAsFixed(3),
                    style: TextStyle(fontSize: 16.0)),
              ),
            );
          },
        )
      ],
    );
  }
}
