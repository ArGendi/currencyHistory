import 'package:currency_converter/controllers/currency_controller.dart';
import 'package:currency_converter/widgets/custom_button.dart';
import 'package:currency_converter/widgets/my_dropdown_menu.dart';
import 'package:flutter/material.dart';

import '../models/currency_date.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var currencyController = CurrencyController();
  String fromCurrency = 'EGP';
  String toCurrency = 'USD';
  List<String>? symbols;
  bool notValidate = false;
  List<CurrencyDate> historyData = [];

  getSymbols() async {
    List<String>? temp = await currencyController.getSymbols();
    setState(() {
      symbols = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      getSymbols();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Exchange rates",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select start date range",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startDateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      labelText: "Start date (YYYY-MM-DD)",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      labelStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorText: notValidate ? "" : null,
                      errorStyle: TextStyle(fontSize: 0),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: endDateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      labelText: "Start date (YYYY-MM-DD)",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      labelStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorText: notValidate ? "" : null,
                      errorStyle: TextStyle(fontSize: 0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Select currencies",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            symbols != null
                ? Row(
                    children: [
                      Expanded(
                        child: MyDropDownMenu(
                          dropdownValue: fromCurrency,
                          items: symbols!,
                          onChange: (value) {
                            setState(() {
                              fromCurrency = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: MyDropDownMenu(
                          dropdownValue: toCurrency,
                          items: symbols!,
                          onChange: (value) {
                            setState(() {
                              toCurrency = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : const Text("Loading symbols..."),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              text: "Get exchange rates",
              onClick: () async {
                if (startDateController.text.isEmpty ||
                    endDateController.text.isEmpty) {
                  setState(() {
                    notValidate = true;
                  });
                } else {
                  setState(() {
                    notValidate = false;
                  });
                }
                if (!notValidate) {
                  List<CurrencyDate>? temp =
                      await currencyController.getTimeSeries(
                          startDateController.text,
                          endDateController.text,
                          fromCurrency,
                          toCurrency);
                  if (temp != null) {
                    setState(() {
                      historyData = temp;
                    });
                  }
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            if (historyData.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var hd in historyData)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hd.date,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(hd.value),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }
}
