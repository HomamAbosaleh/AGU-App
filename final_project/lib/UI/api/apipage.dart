import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class apiPage extends StatefulWidget {
  const apiPage({Key? key}) : super(key: key);

  @override
  _apiPageState createState() => _apiPageState();
}


class _apiPageState extends State<apiPage> {
  int currentInd = 0;
   List<Widget> _apipages = <Widget>[
    Image.asset('images/agulocation.PNG'),
    Image.asset('images/dolartotl.PNG'),
    Image.asset('images/kayseriweather.PNG')
  ];
  List<Widget> _apipagenames = <Widget>[
   Text('University Location'),
   Text('Currency Exchange'),
   Text('Kayseri Weather'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _apipagenames.elementAt(currentInd),
      ),
      body: Center(
        child: _apipages.elementAt(currentInd),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentInd,
        selectedFontSize: 15,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
                Icons.location_on_rounded),
            label: 'Location',
          ),
          BottomNavigationBarItem(
              icon:
              Icon(Icons.cloud),
              label:'Weather'
          ),
          BottomNavigationBarItem(
              icon:
              Icon(Icons.attach_money),
              label: 'Currency'
          ),
        ],
        onTap: (index){
          setState(() {
            currentInd = index;
          });
        }
      ),
    );
  }
}
