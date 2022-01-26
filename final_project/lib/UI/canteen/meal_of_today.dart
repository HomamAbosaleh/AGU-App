import 'package:final_project/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final List<String> Myimages = [
    'images/new_main.jpg',
    'images/new_second.jpg',
    'images/new_soup.jpg',
    'images/new_salad.jpg'
  ];

  final List<String> Mydishes = [
    'Main dish:',
    'Side dish:',
    'Soup:',
    'Appetiser:',
  ];

  final List<String> myFoods = [];

  void fillFoods(AsyncSnapshot snapshot) {
    myFoods.add(snapshot.data['mainDish']);
    myFoods.add(snapshot.data['sideDish']);
    myFoods.add(snapshot.data['soup']);
    myFoods.add(snapshot.data['appetiser']);
  }

  final List<String> myCals = [];

  void fillCals(AsyncSnapshot snapshot) {
    myCals.add(snapshot.data['mainCal'].toString());
    myCals.add(snapshot.data['sideCal'].toString());
    myCals.add(snapshot.data['soupCal'].toString());
    myCals.add(snapshot.data['appetiserCal'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   floating: true,
          //   elevation: 0,
          //   toolbarHeight: 60,
          //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //   title: Container(
          //     //margin: EdgeInsets.only(top: 25),
          //     child: ListTile(
          //       contentPadding: const EdgeInsets.all(8),
          //       title: Text(
          //         DateFormat.yMMMd().format(DateTime.now()),
          //         textAlign: TextAlign.center,
          //         style: Theme.of(context).textTheme.headline6,
          //       ),
          //       subtitle: Text(DateFormat.EEEE().format(DateTime.now()),
          //           textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline3),
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: FireStore().getTodayMeal(),
              builder: (context, AsyncSnapshot snapShot) {
                if (snapShot.connectionState == ConnectionState.done) {
                  if (snapShot.hasData) {
                    fillFoods(snapShot);
                    fillCals(snapShot);
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          title: Text(
                            DateFormat.yMMMd().format(DateTime.now()),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(DateFormat.EEEE().format(DateTime.now()),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline3),
                        ),
                        GridView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: 4,
                            //physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3 / 3.2,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.only(top: 10),
                                margin: const EdgeInsets.only(left: 20, right: 20),
                                child: Stack(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Theme.of(context).hoverColor,
                                      margin: const EdgeInsets.only(top: 30),
                                      child: SizedBox(
                                        height: double.infinity,
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: Align(
                                          alignment: const Alignment(-0.9, -0.2),
                                          child: Text(
                                            Mydishes[index].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0, 0.35),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              myFoods[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        bottom: .0,
                                        left: .0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5, bottom: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                myCals[index],
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                              Text(
                                                ' kcal',
                                                style: TextStyle(color: Colors.grey[600]),
                                              )
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                      top: .0,
                                      left: .0,
                                      right: .0,
                                      child: Container(
                                        width: 95,
                                        height: 95,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(Myimages[index]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    );
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              elevation: 0,
              toolbarHeight: 60,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: ListTile(
                title: Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(DateFormat.EEEE().format(DateTime.now()),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: FireStore().getTodayMeal(),
                builder: (context, AsyncSnapshot snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    if (snapShot.hasData) {
                      fillFoods(snapShot);
                      fillCals(snapShot);
                      return GridView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 4,
                          //physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 3.2,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.only(top: 10),
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Stack(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Theme.of(context).hoverColor,
                                    margin: const EdgeInsets.only(top: 30),
                                    child: SizedBox(
                                      height: double.infinity,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Align(
                                        alignment: const Alignment(-0.9, -0.2),
                                        child: Text(
                                          Mydishes[index].toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, 0.35),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            myFoods[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                ?.copyWith(fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      bottom: .0,
                                      left: .0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              myCals[index],
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              ' kcal',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            )
                                          ],
                                        ),
                                      )),
                                  Positioned(
                                    top: .0,
                                    left: .0,
                                    right: .0,
                                    child: Container(
                                      width: 95,
                                      height: 95,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(Myimages[index]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
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
            )
          ],
        ),
      ),
    );
  }
}
