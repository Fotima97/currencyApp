import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:currency/pages/converter_page.dart';

bool accepted = false;

showDialogBox(BuildContext context) {
  CupertinoAlertDialog iosDialog = CupertinoAlertDialog(
    title: Text('Внимание!'),
    content: Text('Для обратной конвертации нужно выбрать только одну валюту'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(
          'Отменить',
          //  style: TextStyle(color: primaryColor),
        ),
        onPressed: () {
          Navigator.pop(context, 'Ok');
        },
      ),
      CupertinoDialogAction(
        child: Text(
          'Выбрать',
          //  style: TextStyle(color: primaryColor),
        ),
        onPressed: () {
          accepted = true;
          curList.clear();
          reverseConvert = !reverseConvert;
          Navigator.pop(context, 'Ok');
          Navigator.pushNamed(context, '/currency_list');
        },
      )
    ],
  );
  AlertDialog androidDialog = AlertDialog(
    title: Text(
      'Внимание!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18.0),
    ),
    content: Text(
      'Для обратной конвертации нужно выбрать только одну валюту',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.0),
    ),
    actions: <Widget>[
      Material(
        color: Colors.transparent,
        child: MaterialButton(
          highlightColor: Colors.transparent,
          height: 40.0,
          child: Text(
            'Отменить',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Material(
        color: Colors.transparent,
        child: MaterialButton(
          highlightColor: Colors.transparent,
          height: 40.0,
          child: Text(
            'Выбрать',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          onPressed: () {
            accepted = true;
            curList.clear();
            reverseConvert = !reverseConvert;

            Navigator.pop(context);
            Navigator.pushNamed(context, '/currency_list');
          },
        ),
      )
    ],
  );
  if (Platform.isAndroid) {
    showDialog(context: context, child: androidDialog);
  }
  if (Platform.isIOS) {
    showDialog(context: context, child: iosDialog);
  }
}

showDilogBox2(BuildContext context) {
  CupertinoAlertDialog iosDialog = CupertinoAlertDialog(
    title: Text('Только 1 валюта должна быть выбрана'),
    content:
        Text('Пожалуйста удалите выбранную валюту прежде чем выбрать другую'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(
          'Продолжить',
          //  style: TextStyle(color: primaryColor),
        ),
        onPressed: () {
          Navigator.pop(context, 'ОК');
        },
      )
    ],
  );
  AlertDialog androidDialog = AlertDialog(
    title: Text(
      'Только 1 валюта должна быть выбрана',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18.0),
    ),
    content: Text(
      'Пожалуйста удалите выбранныу валюту прежде чем выбрать другую',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.0),
    ),
    actions: <Widget>[
      Material(
        color: Colors.transparent,
        child: MaterialButton(
          highlightColor: Colors.transparent,
          minWidth: 200.0,
          height: 40.0,
          child: Text(
            'Продолжить',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      )
    ],
  );
  if (Platform.isAndroid) {
    showDialog(context: context, child: androidDialog);
  }
  if (Platform.isIOS) {
    showDialog(context: context, child: iosDialog);
  }
}
