import 'package:flutter/material.dart';

import '/services/firestore.dart';

class MealOfToday extends StatelessWidget {
  MealOfToday({Key? key}) : super(key: key);

  final List<String> days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStore().getStudent(),
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: ListTile(
                contentPadding: const EdgeInsets.all(8),
                title: Text(
                  "Current Balance",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('₺${snapShot.data['wallet']}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3),
              ),
            ),
            body: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  height: 150,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).accentColor,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage('images/new_day.png'),
                              width: 120,
                              height: 120,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              days[index],
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'sdhgkdsjf sdhfgkjsd skdgsdf',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'sdhgkdsjf sdhfgkjsd skdgsdf',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'sdhgkdsjf sdhfgkjsd skdgsdf',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              'sdhgkdsjf sdhfgkjsd skdgsdf',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                );
              },
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
