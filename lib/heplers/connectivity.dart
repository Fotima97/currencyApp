import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:currency/heplers/app_constants.dart';
import 'dart:io';

bool hasConnection = false;

checkConnection(BuildContext context) async {
  var connectivityResult = await (new Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    hasConnection = true;
  } else {
    hasConnection = false;
    showDialogBox(context);
  }
  print(connectivityResult);
}

showDialogBox(BuildContext context) {
  CupertinoAlertDialog iosDialog = CupertinoAlertDialog(
    title: Text('Внимание!'),
    content: Text('Проверьте подключение к Интернету'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(
          'Продолжить',
          //  style: TextStyle(color: primaryColor),
        ),
        onPressed: () {
          Navigator.pop(context, 'Ok');
        },
      )
    ],
  );
  AlertDialog androidDialog = AlertDialog(
    title: Text(
      'Внимание!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.0),
    ),
    content: Text(
      'Проверьте подключение к Интернету',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18.0),
    ),
    actions: <Widget>[
      Material(
        color: Colors.transparent,
        child: MaterialButton(
          highlightColor: Colors.transparent,
          minWidth: 250.0,
          height: 40.0,
          child: Text(
            'Продолжить',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
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
