import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class payments extends StatefulWidget {
  int? money;
  payments({this.money});

  @override
  _paymentsState createState() => _paymentsState();
}

double balance = 0;
void addMoney(double newBalance) {
  balance += newBalance;
}

final balanceController = TextEditingController();

class _paymentsState extends State<payments> {
  // Widget buildSheet() {
  //   return Container(
  //     height: 200,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(10),
  //           child: TextField(
  //             controller: balanceController,
  //             decoration: InputDecoration(label: Text('balance')),
  //           ),
  //         ),
  //         TextButton(
  //             onPressed: () {
  //               balance++;
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Add Money'))
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Amount of Money in Card: '),
          SizedBox(height: 5),
          Text('₺ $balance', style: TextStyle(fontSize: 30)),
          SizedBox(height: 30),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
            onPressed: () {
              showBottomSheet(
                  context: context, builder: (context) => buildSheet());
            },
            child:
                const Icon(Icons.account_balance_wallet, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildSheet() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: balanceController,
              decoration: InputDecoration(label: Text('balance')),
            ),
          ),
          TextButton(
              onPressed: () {
                addMoney(double.parse(balanceController.text));
                Navigator.of(context).pop();
              },
              child: const Text(
                'Add Money',
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
