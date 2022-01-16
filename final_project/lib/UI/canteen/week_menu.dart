import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/services/firestore.dart';

class MealOfToday extends StatelessWidget {
  const MealOfToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStore().getStudent(),
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(8),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: ListTile(
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
                          return Column(
                            children: [
                              snapShot.data[0]
                                  ? Center(
                                      child: Text("Next Week Menu",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    )
                                  : Container(),
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snapShot.data[1].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return dayMenu(
                                      context, snapShot.data[1][index]);
                                },
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              "End of Month",
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
                )
              ],
            ),
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
