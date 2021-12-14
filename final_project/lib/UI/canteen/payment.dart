import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '/services/firestore.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final balanceController = TextEditingController();
  double balance = 0;
  void addMoney(double newBalance) {
    balance += newBalance;
  }

  Stream? student;

  getStudent() async {
    FireStore().getStudentStream().then((value) {
      setState(() {
        student = value;
      });
    });
  }

  @override
  void initState() {
    getStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: student,
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.data != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Amount of Money in Card: '),
                const SizedBox(height: 5),
                Text('${snapShot.data['wallet']}',
                    style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: () {
                    showBottomSheet(
                        context: context,
                        builder: (context) => buildSheet(snapShot));
                  },
                  child: const Icon(Icons.account_balance_wallet,
                      color: Colors.black),
                ),
              ],
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

  Widget buildSheet(AsyncSnapshot snapShot) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: balanceController,
              decoration: const InputDecoration(label: Text('balance')),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp("[- ]"))
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(
                () {
                  double newBalance = snapShot.data['wallet'] +
                      double.parse(balanceController.text);
                  FireStore().addMoney(newBalance);
                },
              );
              Navigator.of(context).pop();
            },
            child: const Text(
              'Add Money',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
