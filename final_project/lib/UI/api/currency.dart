import 'package:flutter/material.dart';

import '../../services/http.dart';

class Currency extends StatefulWidget {
  const Currency({Key? key}) : super(key: key);

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  FocusNode amountFocusNode = FocusNode();
  dynamic currency;
  TextEditingController amountController = TextEditingController();
  double? amount;
  bool a = false;

  @override
  void dispose() {
    amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: [
            TextField(
              focusNode: amountFocusNode,
              controller: amountController,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: "To TRY",
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField(
              hint: const Text("Desired Currency"),
              value: currency,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              items: [
                "AED",
                "AUD",
                "CAD",
                "EUR",
                "GBP",
                "KWD",
                "QAR",
                "SAR",
                "UAD",
                "USD",
              ].map<DropdownMenuItem<Object>>(dropDownBuilder).toList(),
              onChanged: (value) {
                setState(() {
                  currency = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (currency != null && amountController.text.isNotEmpty) {
                  var value = await Http()
                      .exchange(currency, double.parse(amountController.text));
                  amountController.clear();
                  amountFocusNode.unfocus();
                  setState(
                    () {
                      a = true;
                      amount = value;
                    },
                  );
                } else if (currency == null) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '❌ Error: Please enter the targeted currency',
                        style: TextStyle(fontSize: 20),
                      ),
                      duration: Duration(seconds: 8),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '❌ Error: Please enter the amount',
                        style: TextStyle(fontSize: 20),
                      ),
                      duration: Duration(seconds: 8),
                    ),
                  );
                }
              },
              child: const Text('Exchange'),
            ),
            a == true
                ? Card(
                    child: Text("TRY: " + amount.toString()),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

DropdownMenuItem<Object> dropDownBuilder(item) {
  return DropdownMenuItem(value: item, child: Text(item));
}
