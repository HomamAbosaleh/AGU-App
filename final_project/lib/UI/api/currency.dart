import 'package:flutter/material.dart';

import '../../services/http.dart';

class Currency extends StatefulWidget {
  const Currency({Key? key}) : super(key: key);

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  dynamic currency;
  @override
  Widget build(BuildContext context) {
    Http().getCurrency();
    return FutureBuilder(
      future: Http().getCurrencies(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Card(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    value: currency,
                    items: snapshot.data.keys
                        .map<DropdownMenuItem<Object>>(dropDownBuilder)
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        currency = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

DropdownMenuItem<Object> dropDownBuilder(item) {
  return DropdownMenuItem(value: item, child: Text(item));
}
