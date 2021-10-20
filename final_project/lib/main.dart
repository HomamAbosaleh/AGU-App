import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agu App',
      home: MasterScaffold()));
}

class MasterScaffold extends StatelessWidget {
  const MasterScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DaddyChill'),
      ),
      body: Center(
        child: Column(
          children: [Text('no u')],
        ),
      ),
    );
  }
}
