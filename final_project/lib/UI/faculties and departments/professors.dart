import 'package:flutter/material.dart';

import '/services/firestore.dart';

class Professors extends StatelessWidget {
  final String departmentName;
  final String facultyName;
  const Professors(
      {Key? key, required this.facultyName, required this.departmentName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStore().getProfessors(departmentName, facultyName),
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return ListView.builder(
            itemCount: snapShot.data.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Image.network(
                        snapShot.data[index]["image"],
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        snapShot.data[index]["position"] != "no_such_a_thing"
                            ? Text(snapShot.data[index]["position"])
                            : Container(),
                        snapShot.data[index]["title"] != "no_such_a_thing"
                            ? Text(snapShot.data[index]["title"])
                            : Container(),
                        Text(snapShot.data[index]["name"] +
                            " " +
                            snapShot.data[index]["surname"]),
                        Text(snapShot.data[index]["email"]),
                      ],
                    ),
                  )
                ],
              );
            },
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
