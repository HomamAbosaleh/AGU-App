import 'package:flutter/material.dart';

class meal extends StatefulWidget {
  const meal({Key? key}) : super(key: key);

  @override
  _mealState createState() => _mealState();
}

class _mealState extends State<meal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.red[400],
            child: DataTable(
                sortColumnIndex: 1,
                sortAscending: true,
                headingRowHeight: 90,
                columnSpacing: 100,
                horizontalMargin: 40,
                dividerThickness: 5,
                dataRowHeight: 80,
                headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 10)),
                columns: const [
                  DataColumn(
                    label: Text('Type'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Cal'),
                    numeric: true,
                  )
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text(
                      'Food',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(
                        Text('500', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Pilav',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(
                        Text('500', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Food',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(
                        Text('400', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                      'Food',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(
                        Text('700', style: TextStyle(color: Colors.white))),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}
