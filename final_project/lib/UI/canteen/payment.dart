import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class payments extends StatefulWidget {
  const payments({Key? key}) : super(key: key);

  @override
  _paymentsState createState() => _paymentsState();
}

class _paymentsState extends State<payments> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Amount of Money in Card: '),
          Text('50tl'),
          ElevatedButton(onPressed: (){}, child: const Icon(Icons.account_balance_wallet),),
        ],
      ),

    );
  }
}
