// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:final_project/UI/canteen/payment.dart';
import 'package:final_project/model/meal.dart';
import 'package:flutter/material.dart';

class meal extends StatelessWidget {
  List<Meal> meals = [
    Meal(
        mainDish: "Boiled Rice",
        secondDish: "Fried Chicken",
        soup: "Mercemek Çorbası",
        salad: "Akdeniz Salata",
        CalMain: 500,
        CalSecond: 450,
        CalSalad: 50,
        CalSoup: 100),
  ];

  Widget build(BuildContext context) {
    Meal(CalMain: 15);
    return Container(
      // padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15),
          Text(
            "C u r r e n t   B a l a n c e",
            style: TextStyle(color: Colors.grey[700], fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text('₺14.05', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                  // bottomLeft: Radius.circular(50),
                  // bottomRight: Radius.circular(50),
                ),
                color: Color(0xF3000000),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Type',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 30),
                            ),
                            const SizedBox(height: 30),
                            Text(meals[0].mainDish.toString(),
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text(meals[0].secondDish.toString(),
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text(meals[0].soup.toString(),
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text(meals[0].salad.toString(),
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Calories',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 30)),
                            SizedBox(height: 30),
                            Text(meals[0].CalMain.toString(),
                                style: TextStyle(fontSize: 20)),
                            SizedBox(height: 10),
                            Text(meals[0].CalSecond.toString(),
                                style: TextStyle(fontSize: 20)),
                            SizedBox(height: 10),
                            Text(meals[0].CalSoup.toString(),
                                style: TextStyle(fontSize: 20)),
                            SizedBox(height: 10),
                            Text(meals[0].CalSalad.toString(),
                                style: TextStyle(fontSize: 20)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
