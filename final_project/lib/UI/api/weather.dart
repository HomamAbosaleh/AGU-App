import 'package:flutter/material.dart';

import '../../services/http.dart';

class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Http().getWeatherByLocation(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Card(
              child: Column(
                children: [
                  Text(snapshot.data),
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
