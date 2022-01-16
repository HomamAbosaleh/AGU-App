import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/services/firestore.dart';

class MealOfToday extends StatelessWidget {
  MealOfToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStore().getStudent(),
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
              body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
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
              SliverToBoxAdapter(
                  child: FutureBuilder(
                future: FireStore().getWeekSchedule(),
                builder: (context, AsyncSnapshot snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    if (snapShot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapShot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return dayMenu(context, snapShot.data[index]);
                        },
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
              ))
            ],
          ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Widget dayMenu(BuildContext context, Map dayMenu) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
    height: 150,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).accentColor,
      child: Row(
        children: [
          DateFormat('yyyy-MM-dd').format(DateTime.now()) == dayMenu["date"]
              ? photo()
              : Container(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dayMenu['day'],
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  dayMenu["mainDish"],
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  dayMenu["sideDish"],
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  dayMenu["soup"],
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  dayMenu["appetiser"],
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget photo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      SizedBox(width: 10),
      Image(
        image: AssetImage('images/new_day.png'),
        width: 120,
        height: 120,
      ),
    ],
  );
}
