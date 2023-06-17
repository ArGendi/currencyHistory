import 'dart:convert';

import 'package:currency_converter/models/currency_date.dart';
import 'package:currency_converter/services/web_services.dart';
import 'package:flutter/foundation.dart';

class CurrencyController {
  late WebServices _webServices;

  CurrencyController() {
    _webServices = WebServices();
  }

  Future<List<String>?> getSymbols() async {
    if (kDebugMode) {
      print("getting Symbols...");
    }
    var response =
        await _webServices.get("https://api.exchangerate.host/symbols");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var body = jsonDecode(response.body);
      return body["symbols"].keys.toList();
    } else {
      if (kDebugMode) {
        print("Symbols request error...");
      }
      return null;
    }
  }

  Future<List<CurrencyDate>?> getTimeSeries(String fromDate, String toDate,
      String fromCurrency, String toCurrency) async {
    if (kDebugMode) {
      print("getting time series...");
    }
    var response = await _webServices.get(
        "https://api.exchangerate.host/timeseries?start_date=$fromDate&end_date=$toDate&base=$fromCurrency&symbols=$toCurrency");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var body = jsonDecode(response.body);
      if (kDebugMode) {
        print("Completed..");
      }
      List<CurrencyDate> list = [];
      body['rates'].forEach((k, v) {
        list.add(CurrencyDate(k, v[toCurrency].toString()));
      });
      if (kDebugMode) {
        print(body['rates']);
      }
      return list;
    } else {
      if (kDebugMode) {
        print("time series request error...");
      }
      return null;
    }
  }
}
