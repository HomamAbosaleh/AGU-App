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
  double? amount, amountofone;
  String? exchangedmoney, exchangedmoneyof1;
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
            SizedBox(
              height: 10,
            ),
            Text("Exchange from desired currency to TRY",style: TextStyle(fontSize: 18),),
            SizedBox(
              height: 10,
            ),
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
                hintText: "Exchange X amount to TRY",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
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
                  currency = value;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (currency != null && amountController.text.isNotEmpty) {
                  var value = await Http()
                      .exchange(currency, double.parse(amountController.text));
                  var value1 = await Http()
                      .exchange(currency, 1);
                  amountFocusNode.unfocus();
                  setState(
                    () {
                      a = true;
                      amount = value;
                      amountofone = value1;
                      exchangedmoney = amount!.toStringAsFixed(3);
                      exchangedmoneyof1 = amountofone!.toStringAsFixed(3);
                    },
                  );
                } else if (currency == null) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '❌ Error: Please enter the targeted currency',
                        style: TextStyle(fontSize: 17),
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '❌ Error: Please enter the amount',
                        style: TextStyle(fontSize: 17),
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              },

              child: const Text('Exchange to TRY'),
            ),
            SizedBox(
              height: 10,
            ),

          a == true
                ?
              Column(
                children: [
                  Text("1 "+currency+" is "+exchangedmoneyof1!+" ₺",style: const TextStyle(fontSize: 18)),

                  Text(amountController.text+" "+currency+" is "+exchangedmoney!+" ₺",style: const TextStyle(fontSize: 20))
                ],
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
