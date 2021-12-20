import 'package:flutter/material.dart';

import '/services/firestore.dart';

class MealOfToday extends StatelessWidget {
  const MealOfToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List names = [
      {"dish": "mainDish", "cal": "mainCal"},
      {"dish": "sideDish", "cal": "sideCal"},
      {"dish": "soup", "cal": "soupCal"},
      {"dish": "appetiser", "cal": "appetiserCal"}
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          FutureBuilder(
            future: FireStore().getStudent(),
            builder: (context, AsyncSnapshot snapShot) {
              if (snapShot.hasData) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text(
                    "Current Balance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        letterSpacing: 3),
                  ),
                  subtitle: Text('₺${snapShot.data['wallet']}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          FutureBuilder(
            future: FireStore().getTodayMeal(),
            builder: (context, AsyncSnapshot snapShot) {
              if (snapShot.connectionState == ConnectionState.done) {
                if (snapShot.hasData) {
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(70),
                          topRight: Radius.circular(70),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width - 380,
                            30,
                            MediaQuery.of(context).size.width - 380,
                            50),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Type',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  ListView.builder(
                                    padding: const EdgeInsets.only(top: 10),
                                    shrinkWrap: true,
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: Text(
                                            snapShot.data[names[index]["dish"]],
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Calories',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  ListView.builder(
                                    padding: const EdgeInsets.only(top: 10),
                                    shrinkWrap: true,
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: Text(
                                            snapShot.data[names[index]["cal"]]
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Dining Hall Is Closed Today",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
